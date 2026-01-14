package servlet;

import dao.UserDAO;
import entity.User;
import util.FileUploadUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/user/profile")
@MultipartConfig
public class UserProfileServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 获取最新的用户信息
        User latestUser = userDAO.getUserById(user.getId());
        if (latestUser != null) {
            session.setAttribute("user", latestUser);
            request.setAttribute("user", latestUser);
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("update".equals(action)) {
            String nickname = request.getParameter("nickname");
            String gender = request.getParameter("gender");
            String signature = request.getParameter("signature");
            String currentAvatar = user.getAvatar();

            // 处理头像上传
            Part avatarPart = request.getPart("avatar");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("/images/" + user.getUsername());
                String avatarPath = FileUploadUtil.uploadFile(avatarPart, uploadPath);
                if (avatarPath != null) {
                    currentAvatar = "images/" + user.getUsername() + "/" + avatarPath;
                }
            }

            boolean success = userDAO.updateUserProfile(user.getId(), nickname, gender, signature, currentAvatar);

            if (success) {
                // 更新session中的用户信息
                User updatedUser = userDAO.getUserById(user.getId());
                session.setAttribute("user", updatedUser);
                response.sendRedirect(request.getContextPath() + "/user/profile?success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/profile?error=true");
            }
        }
    }
}
