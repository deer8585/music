package servlet;

import dao.AlbumDAO;
import entity.Album;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AlbumsServlet", value = "/albums")
public class AlbumsServlet extends HttpServlet {
    private AlbumDAO albumDAO = new AlbumDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Album> albums = albumDAO.getAllAlbums();
            request.setAttribute("albums", albums);
            request.getRequestDispatcher("/albums.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取专辑列表失败");
        }
    }
}
