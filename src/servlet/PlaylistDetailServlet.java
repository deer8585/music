package servlet;

import dao.PlaylistDAO;
import entity.Music;
import entity.Playlist;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PlaylistDetailServlet", value = "/playlist-detail")
public class PlaylistDetailServlet extends HttpServlet {
    private PlaylistDAO playlistDAO = new PlaylistDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String playlistIdStr = request.getParameter("id");
        if (playlistIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/playlists");
            return;
        }

        try {
            long playlistId = Long.parseLong(playlistIdStr);
            Playlist playlist = playlistDAO.getPlaylistById(playlistId);

            if (playlist == null) {
                response.sendRedirect(request.getContextPath() + "/playlists");
                return;
            }

            // 检查权限
            if (playlist.getUserId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/playlists");
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

            // 分页获取歌单中的歌曲
            int totalCount = playlistDAO.getSongCountByPlaylistId(playlistId);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            List<Music> songs = playlistDAO.getSongsByPlaylistIdWithPage(playlistId, page, pageSize);

            // 更新歌单对象的歌曲数量为实际数量
            playlist.setSongCount(totalCount);

            request.setAttribute("playlist", playlist);
            request.setAttribute("songs", songs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCount", totalCount);
            request.getRequestDispatcher("/playlist-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/playlists");
        }
    }
}
