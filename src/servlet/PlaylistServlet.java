package servlet;

import dao.PlaylistDAO;
import entity.Music;
import entity.Playlist;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "PlaylistServlet", value = "/playlists")
public class PlaylistServlet extends HttpServlet {
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

        // 获取用户的所有歌单
        List<Playlist> playlists = playlistDAO.getPlaylistsByUserId(user.getId());
        request.setAttribute("playlists", playlists);

        request.getRequestDispatcher("/playlists.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            out.write("{\"success\": false, \"message\": \"请先登录\"}");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createPlaylist(request, response, user, out);
                    break;
                case "delete":
                    deletePlaylist(request, response, user, out);
                    break;
                case "update":
                    updatePlaylist(request, response, user, out);
                    break;
                case "addSong":
                    addSongToPlaylist(request, response, user, out);
                    break;
                case "removeSong":
                    removeSongFromPlaylist(request, response, user, out);
                    break;
                case "getUserPlaylists":
                    getUserPlaylists(request, response, user, out);
                    break;
                default:
                    out.write("{\"success\": false, \"message\": \"无效的操作\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"success\": false, \"message\": \"操作失败: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }

    private void createPlaylist(HttpServletRequest request, HttpServletResponse response,
                                User user, PrintWriter out) {
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        if (name == null || name.trim().isEmpty()) {
            out.write("{\"success\": false, \"message\": \"歌单名称不能为空\"}");
            return;
        }

        Playlist playlist = new Playlist();
        playlist.setUserId(user.getId());
        playlist.setName(name.trim());
        playlist.setDescription(description != null ? description.trim() : "");
        playlist.setCoverPath("images/avatar.png");

        boolean success = playlistDAO.createPlaylist(playlist);
        if (success) {
            out.write("{\"success\": true, \"message\": \"创建成功\", \"playlistId\": " + playlist.getId() + "}");
        } else {
            out.write("{\"success\": false, \"message\": \"创建失败\"}");
        }
    }

    private void deletePlaylist(HttpServletRequest request, HttpServletResponse response,
                                User user, PrintWriter out) {
        String playlistIdStr = request.getParameter("playlistId");
        if (playlistIdStr == null) {
            out.write("{\"success\": false, \"message\": \"参数不完整\"}");
            return;
        }

        long playlistId = Long.parseLong(playlistIdStr);
        Playlist playlist = playlistDAO.getPlaylistById(playlistId);

        if (playlist == null) {
            out.write("{\"success\": false, \"message\": \"歌单不存在\"}");
            return;
        }

        if (playlist.getUserId() != user.getId()) {
            out.write("{\"success\": false, \"message\": \"无权删除此歌单\"}");
            return;
        }

        boolean success = playlistDAO.deletePlaylist(playlistId);
        out.write("{\"success\": " + success + ", \"message\": \"" + (success ? "删除成功" : "删除失败") + "\"}");
    }

    private void updatePlaylist(HttpServletRequest request, HttpServletResponse response,
                                User user, PrintWriter out) {
        String playlistIdStr = request.getParameter("playlistId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String coverPath = request.getParameter("coverPath");

        if (playlistIdStr == null || name == null || name.trim().isEmpty()) {
            out.write("{\"success\": false, \"message\": \"参数不完整\"}");
            return;
        }

        long playlistId = Long.parseLong(playlistIdStr);
        Playlist playlist = playlistDAO.getPlaylistById(playlistId);

        if (playlist == null) {
            out.write("{\"success\": false, \"message\": \"歌单不存在\"}");
            return;
        }

        if (playlist.getUserId() != user.getId()) {
            out.write("{\"success\": false, \"message\": \"无权修改此歌单\"}");
            return;
        }

        playlist.setName(name.trim());
        playlist.setDescription(description != null ? description.trim() : "");
        if (coverPath != null && !coverPath.trim().isEmpty()) {
            playlist.setCoverPath(coverPath.trim());
        }

        boolean success = playlistDAO.updatePlaylist(playlist);
        out.write("{\"success\": " + success + ", \"message\": \"" + (success ? "更新成功" : "更新失败") + "\"}");
    }

    private void addSongToPlaylist(HttpServletRequest request, HttpServletResponse response,
                                   User user, PrintWriter out) {
        String playlistIdStr = request.getParameter("playlistId");
        String songIdStr = request.getParameter("songId");

        if (playlistIdStr == null || songIdStr == null) {
            out.write("{\"success\": false, \"message\": \"参数不完整\"}");
            return;
        }

        long playlistId = Long.parseLong(playlistIdStr);
        long songId = Long.parseLong(songIdStr);

        Playlist playlist = playlistDAO.getPlaylistById(playlistId);
        if (playlist == null) {
            out.write("{\"success\": false, \"message\": \"歌单不存在\"}");
            return;
        }

        if (playlist.getUserId() != user.getId()) {
            out.write("{\"success\": false, \"message\": \"无权操作此歌单\"}");
            return;
        }

        if (playlistDAO.isSongInPlaylist(playlistId, songId)) {
            out.write("{\"success\": false, \"message\": \"歌曲已在歌单中\"}");
            return;
        }

        boolean success = playlistDAO.addSongToPlaylist(playlistId, songId);
        out.write("{\"success\": " + success + ", \"message\": \"" + (success ? "添加成功" : "添加失败") + "\"}");
    }

    private void removeSongFromPlaylist(HttpServletRequest request, HttpServletResponse response,
                                        User user, PrintWriter out) {
        String playlistIdStr = request.getParameter("playlistId");
        String songIdStr = request.getParameter("songId");

        if (playlistIdStr == null || songIdStr == null) {
            out.write("{\"success\": false, \"message\": \"参数不完整\"}");
            return;
        }

        long playlistId = Long.parseLong(playlistIdStr);
        long songId = Long.parseLong(songIdStr);

        Playlist playlist = playlistDAO.getPlaylistById(playlistId);
        if (playlist == null) {
            out.write("{\"success\": false, \"message\": \"歌单不存在\"}");
            return;
        }

        if (playlist.getUserId() != user.getId()) {
            out.write("{\"success\": false, \"message\": \"无权操作此歌单\"}");
            return;
        }

        boolean success = playlistDAO.removeSongFromPlaylist(playlistId, songId);
        out.write("{\"success\": " + success + ", \"message\": \"" + (success ? "移除成功" : "移除失败") + "\"}");
    }

    private void getUserPlaylists(HttpServletRequest request, HttpServletResponse response,
                                  User user, PrintWriter out) {
        List<Playlist> playlists = playlistDAO.getPlaylistsByUserId(user.getId());
        StringBuilder json = new StringBuilder("{\"success\": true, \"playlists\": [");

        for (int i = 0; i < playlists.size(); i++) {
            Playlist p = playlists.get(i);
            json.append("{\"id\": ").append(p.getId())
                    .append(", \"name\": \"").append(p.getName().replace("\"", "\\\""))
                    .append("\", \"songCount\": ").append(p.getSongCount())
                    .append("}");
            if (i < playlists.size() - 1) {
                json.append(",");
            }
        }
        json.append("]}");
        out.write(json.toString());
    }
}
