package servlet;

import dao.PlaylistDAO;
import entity.Playlist;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import util.FileUploadUtil;

import java.io.IOException;

@WebServlet(name = "UpdatePlaylistCoverServlet", value = "/update-playlist-cover")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,        // 10MB
        maxRequestSize = 1024 * 1024 * 50      // 50MB
)
public class UpdatePlaylistCoverServlet extends HttpServlet {
    private PlaylistDAO playlistDAO = new PlaylistDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // 获取歌单ID
            String playlistIdStr = request.getParameter("playlistId");
            if (playlistIdStr == null) {
                request.setAttribute("error", "参数错误");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            long playlistId = Long.parseLong(playlistIdStr);
            Playlist playlist = playlistDAO.getPlaylistById(playlistId);

            if (playlist == null) {
                request.setAttribute("error", "歌单不存在");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // 检查权限
            if (playlist.getUserId() != user.getId()) {
                request.setAttribute("error", "无权修改此歌单");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // 获取上传的封面文件
            Part coverPart = request.getPart("cover");
            if (coverPart == null || coverPart.getSize() == 0) {
                request.setAttribute("error", "请选择封面图片");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // 上传封面
            String webPath = getServletContext().getRealPath("/");
            String coverPath = FileUploadUtil.uploadPlaylistCover(coverPart, playlist.getName(), webPath);

            // 更新歌单封面路径
            playlist.setCoverPath(coverPath);
            boolean success = playlistDAO.updatePlaylist(playlist);

            if (success) {
                // 直接重定向到歌单详情页，避免使用通用success页面
                session.setAttribute("successMessage", "封面更新成功");
                response.sendRedirect(request.getContextPath() + "/playlist-detail?id=" + playlistId);
            } else {
                request.setAttribute("error", "封面更新失败");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "上传失败: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
