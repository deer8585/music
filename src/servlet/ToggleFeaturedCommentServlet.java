package servlet;

import dao.CommentDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "ToggleFeaturedCommentServlet", value = "/toggleFeaturedComment")
public class ToggleFeaturedCommentServlet extends HttpServlet {
    private CommentDAO commentDAO = new CommentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            long commentId = Long.parseLong(request.getParameter("id"));
            boolean success = commentDAO.toggleFeatured(commentId);
            
            if (success) {
                response.sendRedirect("comments");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "切换精华状态失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "切换精华状态失败");
        }
    }
}
