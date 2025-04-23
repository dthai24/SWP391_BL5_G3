package Dal;

import DBContext.DBContext;
import Model.InventoryItem;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryItemDAO {
    
    private Connection connection;

    // Constructor to initialize the connection
    public InventoryItemDAO() {
        try {
            DBContext db = new DBContext();
            connection = db.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Create a new InventoryItem
    public boolean addInventoryItem(InventoryItem item) {
        String query = "INSERT INTO InventoryItems (itemName, description, defaultCharge, isDeleted) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, item.getItemName());
            stmt.setString(2, item.getDescription());
            stmt.setBigDecimal(3, item.getDefaultCharge());
            stmt.setBoolean(4, item.getIsDeleted());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Read an InventoryItem by its ID
    public InventoryItem getInventoryItemById(int itemID) {
        String query = "SELECT * FROM InventoryItems WHERE itemID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, itemID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToInventoryItem(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update an InventoryItem
    public boolean updateInventoryItem(InventoryItem item) {
        String query = "UPDATE InventoryItems SET itemName = ?, description = ?, defaultCharge = ?, isDeleted = ? WHERE itemID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, item.getItemName());
            stmt.setString(2, item.getDescription());
            stmt.setBigDecimal(3, item.getDefaultCharge());
            stmt.setBoolean(4, item.getIsDeleted());
            stmt.setInt(5, item.getItemID());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete an InventoryItem (soft delete)
    public boolean deleteInventoryItem(int itemID) {
        String query = "UPDATE InventoryItems SET isDeleted = 1 WHERE itemID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, itemID);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all InventoryItems
    public List<InventoryItem> getAllInventoryItems() {
        List<InventoryItem> items = new ArrayList<>();
        String query = "SELECT * FROM InventoryItems WHERE isDeleted = 0";
        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                items.add(mapResultSetToInventoryItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    // Helper method to map ResultSet to InventoryItem object
    private InventoryItem mapResultSetToInventoryItem(ResultSet rs) throws SQLException {
        int itemID = rs.getInt("itemID");
        String itemName = rs.getString("itemName");
        String description = rs.getString("description");
        BigDecimal defaultCharge = rs.getBigDecimal("defaultCharge");
        boolean isDeleted = rs.getBoolean("isDeleted");

        return new InventoryItem(itemID, itemName, description, defaultCharge, isDeleted);
    }
}
