package servlet;

import dao.MusicDAO;
import entity.Music;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(name = "SearchServlet", value = "/search")
public class SearchServlet extends HttpServlet {
    private MusicDAO musicDAO = new MusicDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        
        if (keyword == null || keyword.trim().isEmpty()) {
            // 如果没有搜索关键词，重定向到首页
            response.sendRedirect(request.getContextPath() + "/user/music");
            return;
        }
        
        try {
            // 执行搜索
            List<Music> searchResults = musicDAO.searchMusic(keyword.trim());
            
            // 格式化时间
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            for (Music song : searchResults) {
                song.setFormattedReleaseTime(sdf.format(song.getReleaseTime()));
            }
            
            // 获取用户收藏状态
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                for (Music song : searchResults) {
                    boolean isFavorite = musicDAO.isFavorite(user.getId(), song.getId());
                    song.setFavorited(isFavorite);
                }
            }
            
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("/SearchResults.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "搜索失败: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}