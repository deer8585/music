package servlet;

import dao.MusicDAO;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "CheckFavoriteServlet", value = "/check-favorite")
public class CheckFavoriteServlet extends HttpServlet {
    private MusicDAO musicDAO = new MusicDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                out.write("{\"isFavorite\": false}");
                return;
            }

            String songIdStr = request.getParameter("songId");
            if (songIdStr == null) {
                out.write("{\"isFavorite\": false}");
                return;
            }

            long songId = Long.parseLong(songIdStr);
            boolean isFavorite = musicDAO.isFavorite(user.getId(), songId);

            out.write("{\"isFavorite\": " + isFavorite + "}");

        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"isFavorite\": false}");
        } finally {
            out.close();
        }
    }
}
