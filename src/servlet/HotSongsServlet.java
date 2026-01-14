package servlet;

import dao.MusicDAO;
import entity.Music;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HotSongsServlet", value = "/hot-songs")
public class HotSongsServlet extends HttpServlet {
    private MusicDAO musicDAO = new MusicDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
            
            String keyword = request.getParameter("keyword");
            List<Music> hotSongs;
            int totalCount;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                // 执行搜索（暂不分页）
                hotSongs = musicDAO.searchMusic(keyword.trim());
                totalCount = hotSongs.size();
                request.setAttribute("keyword", keyword);
            } else {
                // 分页获取热门歌曲
                totalCount = musicDAO.getMusicCount();
                hotSongs = musicDAO.getHotMusicByPage(page, pageSize);
            }
            
            // 获取用户收藏状态
            HttpSession session = request.getSession();
            entity.User user = (entity.User) session.getAttribute("user");
            if (user != null) {
                for (Music song : hotSongs) {
                    boolean isFavorite = musicDAO.isFavorite(user.getId(), song.getId());
                    song.setFavorited(isFavorite);
                }
            }
            
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            
            request.setAttribute("hotSongs", hotSongs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCount", totalCount);
            request.getRequestDispatcher("/hot-songs.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取热榜失败");
        }
    }
}