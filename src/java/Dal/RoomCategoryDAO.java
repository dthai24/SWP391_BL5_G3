package Dal;

import DBContext.DBContext;
import Model.RoomCategory;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RoomCategoryDAO {
    private Connection connection;

    public RoomCategoryDAO() {
        try {
            this.connection = new DBContext().getConnection();
            if (this.connection == null) {
                throw new RuntimeException("Database connection is null. Please check your DBContext configuration and database connectivity.");
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize database connection in RoomCategoryDAO: " + e.getMessage(), e);
        }
    }

    public RoomCategory getRoomCategoryById(int categoryID) {
        String sql = "SELECT * FROM RoomCategories WHERE CategoryID = ? AND IsDeleted = 0";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, categoryID);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                return new RoomCategory(
                    rs.getInt("CategoryID"),
                    rs.getString("CategoryName"),
                    rs.getString("Description"),
                    rs.getBigDecimal("BasePricePerNight"),
                    rs.getBoolean("IsDeleted")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<RoomCategory> getAllRoomCategories() {
        List<RoomCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM RoomCategories WHERE IsDeleted = 0 ORDER BY CategoryID";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                RoomCategory cat = new RoomCategory(
                    rs.getInt("CategoryID"),
                    rs.getString("CategoryName"),
                    rs.getString("Description"),
                    rs.getBigDecimal("BasePricePerNight"),
                    rs.getBoolean("IsDeleted")
                );
                list.add(cat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteRoomCategory(int categoryID) {
        String sql = "UPDATE RoomCategories SET IsDeleted = 1 WHERE CategoryID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, categoryID);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addRoomCategory(RoomCategory category) {
        String sql = "INSERT INTO RoomCategories (CategoryName, Description, BasePricePerNight, IsDeleted) VALUES (?, ?, ?, 0)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, category.getCategoryName());
            statement.setString(2, category.getDescription());
            statement.setBigDecimal(3, category.getBasePricePerNight());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRoomCategory(RoomCategory category) {
        String sql = "UPDATE RoomCategories SET CategoryName = ?, Description = ?, BasePricePerNight = ? WHERE CategoryID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, category.getCategoryName());
            statement.setString(2, category.getDescription());
            statement.setBigDecimal(3, category.getBasePricePerNight());
            statement.setInt(4, category.getCategoryID());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
