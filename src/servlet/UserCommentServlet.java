package servlet;

import dao.CommentDAO;
import dao.MusicDAO;
import entity.Comment;
import entity.Music;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "UserCommentServlet", value = {"/user/song-comments", "/user/add-comment"})
public class UserCommentServlet extends HttpServlet {
    private CommentDAO commentDAO = new CommentDAO();
    private MusicDAO musicDAO = new MusicDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if (path.equals("/user/song-comments")) {
            // 显示歌曲评论页面
            showSongComments(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        String path = request.getServletPath();
        
        if (path.equals("/user/add-comment")) {
            // 添加评论
            addComment(request, response);
        }
    }

    /**
     * 显示歌曲评论页面
     */
    private void showSongComments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 获取歌曲ID
            String musicIdStr = request.getParameter("musicId");
            if (musicIdStr == null || musicIdStr.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少歌曲ID参数");
                return;
            }
            
            long musicId = Long.parseLong(musicIdStr);
            
            // 获取歌曲信息
            Music music = musicDAO.getMusicById(musicId);
            if (music == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "歌曲不存在");
                return;
            }
            
            // 获取评论列表
            List<Comment> comments = commentDAO.getCommentsByMusicId(musicId);
            
            // 设置属性
            request.setAttribute("music", music);
            request.setAttribute("comments", comments);
            request.setAttribute("commentCount", comments.size());
            
            // 转发到评论页面
            request.getRequestDispatcher("/user-song-comments.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的歌曲ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取评论失败");
        }
    }

    /**
     * 添加评论
     */
    private void addComment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        
        try {
            // 检查用户是否登录
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                out.print("{\"success\":false,\"message\":\"请先登录\"}");
                return;
            }
            
            User user = (User) session.getAttribute("user");
            
            // 获取参数
            String musicIdStr = request.getParameter("musicId");
            String content = request.getParameter("content");
            
            // 验证参数
            if (musicIdStr == null || content == null || content.trim().isEmpty()) {
                out.print("{\"success\":false,\"message\":\"评论内容不能为空\"}");
                return;
            }
            
            long musicId = Long.parseLong(musicIdStr);
            
            // 添加评论
            boolean success = commentDAO.addComment(user.getId(), musicId, content.trim());
            
            if (success) {
                out.print("{\"success\":true,\"message\":\"评论发表成功\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"评论发表失败，请稍后重试\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"无效的歌曲ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"系统错误：" + e.getMessage() + "\"}");
        }
    }
}
