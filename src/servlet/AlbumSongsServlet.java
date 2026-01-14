package servlet;

import dao.AlbumDAO;
import dao.MusicDAO;
import entity.Music;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AlbumSongsServlet", value = "/album-songs")
public class AlbumSongsServlet extends HttpServlet {
    private AlbumDAO albumDAO = new AlbumDAO();
    private MusicDAO musicDAO = new MusicDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String albumName = request.getParameter("album");
        String artist = request.getParameter("artist");
        
        if (albumName == null || artist == null) {
            response.sendRedirect(request.getContextPath() + "/albums");
            return;
        }
        
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
            
            int totalCount = albumDAO.getSongCountByAlbum(albumName, artist);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            List<Music> songs = albumDAO.getSongsByAlbumWithPage(albumName, artist, page, pageSize);
            
            HttpSession session = request.getSession();
            entity.User user = (entity.User) session.getAttribute("user");
            if (user != null) {
                for (Music song : songs) {
                    boolean isFavorite = musicDAO.isFavorite(user.getId(), song.getId());
                    song.setFavorited(isFavorite);
                }
            }
            
            request.setAttribute("albumName", albumName);
            request.setAttribute("artist", artist);
            request.setAttribute("songs", songs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCount", totalCount);
            request.getRequestDispatcher("/album-songs.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取专辑歌曲失败");
        }
    }
}
