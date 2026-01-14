package servlet;

import dao.UserDAO;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "DeleteUserServlet", value = "/deleteUser")
public class DeleteUserServlet extends HttpServlet {
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
            boolean success = userDAO.deleteUser(userId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/user/list?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/list?error=delete_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user/list?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/list?error=system_error");
        }
    }
}
