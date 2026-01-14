package servlet;

import dao.MusicDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/incrementPlayCount")
public class IncrementPlayCountServlet extends HttpServlet {
    private MusicDAO musicDAO = new MusicDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String songIdStr = request.getParameter("songId");
            if (songIdStr == null || songIdStr.trim().isEmpty()) {
                out.print("{\"success\":false,\"message\":\"歌曲ID不能为空\"}");
                return;
            }

            long songId = Long.parseLong(songIdStr);
            boolean success = musicDAO.incrementPlayCount(songId);

            if (success) {
                out.print("{\"success\":true,\"message\":\"播放量增加成功\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"播放量增加失败\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"歌曲ID格式错误\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"服务器错误\"}");
        } finally {
            out.flush();
            out.close();
        }
    }
}
