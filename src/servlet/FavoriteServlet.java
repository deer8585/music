package servlet;

import dao.MusicDAO;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "FavoriteServlet", value = "/favorite")
public class FavoriteServlet extends HttpServlet {
    private MusicDAO musicDAO = new MusicDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // 获取用户信息
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                out.write("{\"success\": false, \"message\": \"请先登录\"}");
                return;
            }
            
            // 获取参数
            String songIdStr = request.getParameter("songId");
            String action = request.getParameter("action"); // "add" 或 "remove"
            
            if (songIdStr == null || action == null) {
                out.write("{\"success\": false, \"message\": \"参数不完整\"}");
                return;
            }
            
            long songId = Long.parseLong(songIdStr);
            long userId = user.getId();
            
            boolean success = false;
            String message = "";
            
            if ("add".equals(action)) {
                // 检查是否已收藏
                if (musicDAO.isFavorite(userId, songId)) {
                    out.write("{\"success\": false, \"message\": \"已经收藏过了\"}");
                    return;
                }
                success = musicDAO.addFavorite(userId, songId);
                message = success ? "收藏成功" : "收藏失败";
            } else if ("remove".equals(action)) {
                success = musicDAO.removeFavorite(userId, songId);
                message = success ? "取消收藏成功" : "取消收藏失败";
            } else {
                out.write("{\"success\": false, \"message\": \"无效的操作\"}");
                return;
            }
            
            out.write("{\"success\": " + success + ", \"message\": \"" + message + "\"}");
            
        } catch (NumberFormatException e) {
            out.write("{\"success\": false, \"message\": \"无效的歌曲ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"success\": false, \"message\": \"操作失败: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }
}