package servlet;

import dao.CommentDAO;
import entity.Comment;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CommentServlet", value = {"/comments", "/deleteComment"})
public class CommentServlet extends HttpServlet {
    private CommentDAO commentDAO;

    @Override
    public void init() {
        commentDAO = new CommentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if (path.equals("/comments")) {
            try {
                int page = 1;
                int pageSize = 10;
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    try {
                        page = Integer.parseInt(pageParam);
                        if (page < 1) page = 1;
                    } catch (NumberFormatException e) {
                        page = 1;
                    }
                }
                
                // 获取搜索关键词
                String keyword = request.getParameter("keyword");
                List<Comment> comments;
                int totalCount;
                
                if (keyword != null && !keyword.trim().isEmpty()) {
                    // 模糊搜索（暂不分页）
                    comments = commentDAO.searchComments(keyword.trim());
                    totalCount = comments.size();
                    request.setAttribute("keyword", keyword);
                } else {
                    // 分页获取所有评论
                    totalCount = commentDAO.getCommentCount();
                    comments = commentDAO.getCommentsByPage(page, pageSize);
                }
                
                int totalPages = (int) Math.ceil((double) totalCount / pageSize);
                
                request.setAttribute("comments", comments);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("totalCount", totalCount);
                request.getRequestDispatcher("/comments.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "无法获取评论列表");
            }
        } else if (path.equals("/deleteComment")) {
            try {
                long commentId = Long.parseLong(request.getParameter("id"));
                commentDAO.deleteComment(commentId);
                response.sendRedirect("comments");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "删除评论失败");
            }
        }
    }
}
