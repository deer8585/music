package servlet;

import dao.MusicDAO;
import entity.Music;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "FavoritesServlet", value = "/favorites")
public class FavoritesServlet extends HttpServlet {
    private MusicDAO musicDAO = new MusicDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

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

        // 分页获取用户收藏的音乐列表
        int totalCount = musicDAO.getFavoritesCountByUserId(user.getId());
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        List<Music> favoritesList = musicDAO.getFavoritesByUserIdWithPage(user.getId(), page, pageSize);
        
        request.setAttribute("favoritesList", favoritesList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.getRequestDispatcher("/favorites.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                out.write("{\"success\": false, \"message\": \"请先登录\"}");
                return;
            }

            String songIdStr = request.getParameter("songId");
            String action = request.getParameter("action");

            if (songIdStr == null || action == null) {
                out.write("{\"success\": false, \"message\": \"参数不完整\"}");
                return;
            }

            long songId = Long.parseLong(songIdStr);
            long userId = user.getId();

            boolean success = false;
            String message = "";

            if ("add".equals(action)) {
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
