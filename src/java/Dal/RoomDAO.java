package Dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Model.Room;
import DBContext.DBContext;
import java.math.BigDecimal;

public class RoomDAO {

    private Connection connection;

    // Constructor to initialize the connection using DBContext
    public RoomDAO() {
        try {
            this.connection = new DBContext().getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Add a new room
    public boolean addRoom(Room room) {
        String sql = "INSERT INTO Rooms (roomNumber, categoryID, vacancyStatus, description, priceOverride, createdAt, updatedAt, isDeleted) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, room.getRoomNumber());
            statement.setInt(2, room.getCategoryID());
            statement.setString(3, room.getVacancyStatus());
            statement.setString(4, room.getDescription());
            statement.setBigDecimal(5, room.getPriceOverride());
            statement.setTimestamp(6, new Timestamp(room.getCreatedAt().getTime()));
            statement.setTimestamp(7, new Timestamp(room.getUpdatedAt().getTime()));
            statement.setBoolean(8, room.getIsDeleted());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Edit an existing room
    public boolean editRoom(Room room) {
        String sql = "UPDATE Rooms SET roomNumber = ?, categoryID = ?, vacancyStatus = ?, description = ?, priceOverride = ?, updatedAt = ? "
                + "WHERE roomID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, room.getRoomNumber());
            statement.setInt(2, room.getCategoryID());
            statement.setString(3, room.getVacancyStatus());
            statement.setString(4, room.getDescription());
            statement.setBigDecimal(5, room.getPriceOverride());
            statement.setTimestamp(6, new Timestamp(room.getUpdatedAt().getTime()));
            statement.setInt(7, room.getRoomID());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a room (soft delete)
    public boolean deleteRoom(int roomID) {
        String sql = "UPDATE Rooms SET isDeleted = 1 WHERE roomID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, roomID);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // List all rooms (non-deleted)
    public List<Room> listAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM Rooms WHERE isDeleted = 0";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                rooms.add(mapResultSetToRoom(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Get room by ID
    public Room getRoomById(int roomID) {
        String sql = "SELECT * FROM Rooms WHERE roomID = ? AND isDeleted = 0";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, roomID);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return mapResultSetToRoom(resultSet);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Count total rooms (non-deleted)
    public int countRooms() {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE isDeleted = 0";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Get rooms by page (non-deleted)
    public List<Room> getRoomsByPage(int page, int pageSize) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM Rooms WHERE isDeleted = 0 ORDER BY roomID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, (page - 1) * pageSize);
            statement.setInt(2, pageSize);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                rooms.add(mapResultSetToRoom(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Kiểm tra RoomNumber đã tồn tại chưa
    public boolean isRoomNumberExists(String roomNumber) {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE roomNumber = ? AND isDeleted = 0";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, roomNumber);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Helper method to map ResultSet to Room object
    private Room mapResultSetToRoom(ResultSet resultSet) throws SQLException {
        return new Room(
                resultSet.getInt("roomID"),
                resultSet.getString("roomNumber"),
                resultSet.getInt("categoryID"),
                resultSet.getString("vacancyStatus"),
                resultSet.getString("description"),
                resultSet.getBigDecimal("priceOverride"),
                resultSet.getTimestamp("createdAt"),
                resultSet.getTimestamp("updatedAt"),
                resultSet.getBoolean("isDeleted")
        );
    }

    public BigDecimal getRoomCategoryBasePrice(int categoryID) {
        String sql = "SELECT BasePricePerNight FROM RoomCategories WHERE CategoryID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, categoryID);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("BasePricePerNight");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public List<Room> getAllRoomsWithCategoryNames() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rc.CategoryName FROM Rooms r "
                + "JOIN RoomCategories rc ON r.CategoryID = rc.CategoryID "
                + "WHERE r.isDeleted = 0 ORDER BY r.roomNumber";

        try (PreparedStatement statement = connection.prepareStatement(sql); ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Room room = mapResultSetToRoom(resultSet);
                // Store category name in a separate field or as an additional property
                room.setCategoryName(resultSet.getString("CategoryName"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return rooms;
    }

    // Main method to test listAllRooms and getRoomById
    public static void main(String[] args) {
        RoomDAO roomDAO = new RoomDAO();

        System.out.println("=== Testing listAllRooms ===");
        List<Room> allRooms = roomDAO.listAllRooms();
        for (Room room : allRooms) {
            System.out.println(room);
        }

        int testRoomId = 1; // Replace with an actual room ID from your database
        System.out.println("\n=== Testing getRoomById ===");
        Room roomById = roomDAO.getRoomById(testRoomId);
        System.out.println(roomById);
    }
}
