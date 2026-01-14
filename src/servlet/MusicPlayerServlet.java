package servlet;

import dao.MusicDAO;
import entity.Music;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

@WebServlet(name = "MusicPlayerServlet", value = "/music/play/*")
public class MusicPlayerServlet extends HttpServlet {
    private MusicDAO musicDAO = new MusicDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "音乐ID不能为空");
            return;
        }

        try {
            // 从URL路径中获取音乐ID
            long musicId = Long.parseLong(pathInfo.substring(1));
            Music music = musicDAO.getMusicById(musicId);
            
            if (music == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "音乐不存在");
                return;
            }

            // 设置响应头
            response.setContentType("audio/mpeg");
            response.setHeader("Accept-Ranges", "bytes");
            response.setHeader("Cache-Control", "public, max-age=3600");
            
            // 这里简化处理，实际项目中应该从文件系统或云存储读取音乐文件
            // 目前返回一个示例响应
            response.getWriter().write("音乐播放: " + music.getTitle() + " - " + music.getArtist());
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的音乐ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "播放失败");
        }
    }
}