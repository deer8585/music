package servlet;

import dao.MusicDAO;
import entity.Music;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(name = "UserMusicServlet", value = "/user/music")
public class UserMusicServlet extends HttpServlet {
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
            List<Music> newSongs;
            int totalCount;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                // 执行搜索（暂不分页）
                newSongs = musicDAO.searchMusic(keyword.trim());
                totalCount = newSongs.size();
                request.setAttribute("keyword", keyword);
            } else {
                // 分页获取随机排序的音乐
                totalCount = musicDAO.getMusicCount();
                newSongs = musicDAO.getRandomMusicByPage(page, pageSize);
            }

            // 在Java层格式化时间
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            for (Music song : newSongs) {
                song.setFormattedReleaseTime(sdf.format(song.getReleaseTime()));
            }

            // 获取用户收藏状态
            HttpSession session = request.getSession();
            entity.User user = (entity.User) session.getAttribute("user");
            if (user != null) {
                for (Music song : newSongs) {
                    boolean isFavorite = musicDAO.isFavorite(user.getId(), song.getId());
                    song.setFavorited(isFavorite);
                }
            }

            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            
            request.setAttribute("newSongs", newSongs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCount", totalCount);
            request.getRequestDispatcher("/UserMusic.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "加载音乐数据失败: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}