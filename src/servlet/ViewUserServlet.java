package servlet;

import dao.UserDAO;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "ViewUserServlet", value = "/user/view")
public class ViewUserServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查管理员权限
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String userIdStr = request.getParameter("id");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/list?error=invalid_id");
            return;
        }

        try {
            Long userId = Long.parseLong(userIdStr);
            User user = userDAO.getUserById(userId);
            
            if (user != null) {
                request.setAttribute("viewUser", user);
                request.getRequestDispatcher("/viewUser.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/user/list?error=user_not_found");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user/list?error=invalid_id");
        }
    }
}
