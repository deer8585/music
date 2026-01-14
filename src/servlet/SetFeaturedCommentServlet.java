package servlet;

import dao.CommentDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "SetFeaturedCommentServlet", value = "/setFeaturedComment")
public class SetFeaturedCommentServlet extends HttpServlet {
    private CommentDAO commentDAO = new CommentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 获取评论ID
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                out.print("{\"success\":false,\"message\":\"缺少评论ID参数\"}");
                return;
            }

            long commentId = Long.parseLong(idStr);

            // 设置为精华评论
            boolean success = commentDAO.setFeatured(commentId, true);

            if (success) {
                out.print("{\"success\":true,\"message\":\"设置精华评论成功\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"设置精华评论失败\"}");
            }

        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"无效的评论ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"系统错误：" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 重定向到POST方法
        doPost(request, response);
    }
}
