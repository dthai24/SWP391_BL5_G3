package Controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Dal.RoomDAO;
import Dal.RoomCategoryDAO;
import Model.Room;
import Model.RoomCategory;

@WebServlet(name = "RoomServlet", urlPatterns = {"/room"})
public class RoomServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RoomDAO roomDAO = new RoomDAO();
        RoomCategoryDAO roomCategoryDAO = new RoomCategoryDAO();
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
        String filterCategory = request.getParameter("filterCategory");
        String filterStatus = request.getParameter("filterStatus");
        // Lấy toàn bộ danh sách phòng, không phân trang
        List<Room> rooms = roomDAO.listAllRooms();
        // Lọc theo loại phòng nếu có
        if (filterCategory != null && !filterCategory.isEmpty()) {
            try {
                int catId = Integer.parseInt(filterCategory);
                rooms.removeIf(r -> r.getCategoryID() != catId);
            } catch (NumberFormatException e) {
                // ignore
            }
        }
        // Lọc theo trạng thái nếu có
        if (filterStatus != null && !filterStatus.isEmpty()) {
            rooms.removeIf(r -> !filterStatus.equals(r.getVacancyStatus()));
        }
        // Lấy thông tin RoomCategory cho từng phòng
        Map<Integer, RoomCategory> roomCategoryMap = new HashMap<>();
        for (Room room : rooms) {
            int catId = room.getCategoryID();
            if (!roomCategoryMap.containsKey(catId)) {
                RoomCategory cat = roomCategoryDAO.getRoomCategoryById(catId);
                if (cat != null) roomCategoryMap.put(catId, cat);
            }
        }
        // Lấy toàn bộ danh sách loại phòng cho filter/add/edit
        List<RoomCategory> allCategories = roomCategoryDAO.getAllRoomCategories();
        request.setAttribute("rooms", rooms);
        request.setAttribute("roomCategoryMap", roomCategoryMap);
        request.setAttribute("allCategories", allCategories);
        request.setAttribute("editRoom", editRoom);
        request.getRequestDispatcher("Room.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RoomDAO roomDAO = new RoomDAO();
        String deleteRoomIdParam = request.getParameter("deleteRoomID");
        if (deleteRoomIdParam != null && !deleteRoomIdParam.isEmpty()) {
            try {
                int deleteRoomId = Integer.parseInt(deleteRoomIdParam);
                roomDAO.deleteRoom(deleteRoomId);
            } catch (NumberFormatException e) {
                // ignore
            }
            response.sendRedirect("room");
            return;
        }
        String roomIdParam = request.getParameter("roomID");
        String roomNumber = request.getParameter("roomNumber");
        String categoryID = request.getParameter("categoryID");
        String vacancyStatus = request.getParameter("vacancyStatus");
        String description = request.getParameter("description");
        String priceOverride = request.getParameter("priceOverride");
        Date now = new Date();
        boolean isUpdate = roomIdParam != null && !roomIdParam.isEmpty();
        Room room = new Room();
        // Validate RoomNumber không để trống, không khoảng trắng, chỉ số
        if (roomNumber == null || roomNumber.trim().isEmpty()) {
            request.setAttribute("error", "RoomNumber không được để trống.");
            doGet(request, response);
            return;
        }
        if (roomNumber.contains(" ")) {
            request.setAttribute("error", "RoomNumber không được chứa khoảng trắng.");
            doGet(request, response);
            return;
        }
        if (!roomNumber.matches("\\d+")) {
            request.setAttribute("error", "RoomNumber chỉ được chứa các số.");
            doGet(request, response);
            return;
        }
        // Kiểm tra trùng RoomNumber khi thêm mới hoặc sửa (nếu đổi số phòng)
        if (!isUpdate) {
            if (roomDAO.isRoomNumberExists(roomNumber)) {
                request.setAttribute("error", "RoomNumber đã tồn tại.");
                doGet(request, response);
                return;
            }
        } else {
            Room oldRoom = roomDAO.getRoomById(Integer.parseInt(roomIdParam));
            if (oldRoom != null && !oldRoom.getRoomNumber().equals(roomNumber) && roomDAO.isRoomNumberExists(roomNumber)) {
                request.setAttribute("error", "RoomNumber đã tồn tại.");
                doGet(request, response);
                return;
            }
        }
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
