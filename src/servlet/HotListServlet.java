package servlet;

import dao.MusicDAO;
import entity.Music;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HotListServlet", value = "/hotlist")
public class HotListServlet extends HttpServlet {
    private MusicDAO musicDAO;

    @Override
    public void init() {
        musicDAO = new MusicDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 获取播放量前十的歌曲
            List<Music> hotList = musicDAO.getTop10ByPlayCount();
            request.setAttribute("hotList", hotList);
            request.getRequestDispatcher("/hotlist.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取热榜失败");
        }
    }
}
