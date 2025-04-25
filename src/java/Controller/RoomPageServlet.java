package Controller;

import Dal.RoomCategoryDAO;
import Model.RoomCategory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "RoomPageServlet", urlPatterns = {"/roompage"})
public class RoomPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RoomCategoryDAO categoryDAO = new RoomCategoryDAO();
        List<RoomCategory> categories = categoryDAO.getAllRoomCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("RoomPage.jsp").forward(request, response);
    }
}
