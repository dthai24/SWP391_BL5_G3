package Controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Dal.RoomDAO;
import Model.Room;

@WebServlet(name = "RoomServlet", urlPatterns = {"/room"})
public class RoomServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RoomDAO roomDAO = new RoomDAO();
        String roomIdParam = request.getParameter("edit");
        Room editRoom = null;
        if (roomIdParam != null) {
            try {
                int roomId = Integer.parseInt(roomIdParam);
                editRoom = roomDAO.getRoomById(roomId);
            } catch (NumberFormatException e) {
                // ignore, invalid id
            }
        }
        // Pagination logic
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int totalRooms = roomDAO.countRooms();
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);
        if (page > totalPages && totalPages > 0) page = totalPages;
        List<Room> rooms = roomDAO.getRoomsByPage(page, pageSize);
        request.setAttribute("rooms", rooms);
        request.setAttribute("editRoom", editRoom);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("Room.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RoomDAO roomDAO = new RoomDAO();
        String roomIdParam = request.getParameter("roomID");
        String roomNumber = request.getParameter("roomNumber");
        String categoryID = request.getParameter("categoryID");
        String vacancyStatus = request.getParameter("vacancyStatus");
        String description = request.getParameter("description");
        String priceOverride = request.getParameter("priceOverride");
        Date now = new Date();
        boolean isUpdate = roomIdParam != null && !roomIdParam.isEmpty();
        Room room = new Room();
        if (isUpdate) {
            room.setRoomID(Integer.parseInt(roomIdParam));
            room.setUpdatedAt(now);
        } else {
            room.setCreatedAt(now);
            room.setUpdatedAt(now);
            room.setIsDeleted(false);
        }
        room.setRoomNumber(roomNumber);
        room.setCategoryID(Integer.parseInt(categoryID));
        room.setVacancyStatus(vacancyStatus);
        room.setDescription(description);
        room.setPriceOverride(new BigDecimal(priceOverride));
        boolean success;
        if (isUpdate) {
            success = roomDAO.editRoom(room);
        } else {
            success = roomDAO.addRoom(room);
        }
        response.sendRedirect("room");
    }
}
