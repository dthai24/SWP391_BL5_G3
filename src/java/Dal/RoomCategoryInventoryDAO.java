package Dal;

import DBContext.DBContext;
import Model.InventoryItem;
import Model.RoomCategory;
import Model.RoomCategoryInventory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomCategoryInventoryDAO {

    private Connection connection;

    // Constructor to initialize the connection
    public RoomCategoryInventoryDAO() {
        try {
            DBContext db = new DBContext();
            connection = db.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Create a new RoomCategoryInventory
    public boolean addRoomCategoryInventory(RoomCategoryInventory inventory) {
        String query = "INSERT INTO RoomCategoryInventory (categoryID, itemID, defaultQuantity) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, inventory.getCategoryID());
            stmt.setInt(2, inventory.getItemID());
            stmt.setInt(3, inventory.getDefaultQuantity());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Read a RoomCategoryInventory by its ID
    public RoomCategoryInventory getRoomCategoryInventoryById(int roomCategoryInventoryID) {
        String query = "SELECT * FROM RoomCategoryInventory WHERE roomCategoryInventoryID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, roomCategoryInventoryID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToRoomCategoryInventory(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update a RoomCategoryInventory
    public boolean updateRoomCategoryInventory(RoomCategoryInventory inventory) {
        String query = "UPDATE RoomCategoryInventory SET categoryID = ?, itemID = ?, defaultQuantity = ? WHERE roomCategoryInventoryID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, inventory.getCategoryID());
            stmt.setInt(2, inventory.getItemID());
            stmt.setInt(3, inventory.getDefaultQuantity());
            stmt.setInt(4, inventory.getRoomCategoryInventoryID());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a RoomCategoryInventory by its ID
    public boolean deleteRoomCategoryInventory(int roomCategoryInventoryID) {
        String query = "DELETE FROM RoomCategoryInventory WHERE roomCategoryInventoryID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, roomCategoryInventoryID);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all RoomCategoryInventory with category name, item name, and default quantity
    public List<RoomCategoryInventory> getAllRoomCategoryInventories() {
        List<RoomCategoryInventory> inventories = new ArrayList<>();
        String sql = """
            SELECT 
                rci.roomCategoryInventoryID, 
                rc.categoryName AS categoryName, 
                ii.itemName AS itemName,
                rci.defaultQuantity AS defaultQuantity
            FROM 
                RoomCategoryInventory rci
            JOIN 
                RoomCategories rc ON rci.categoryID = rc.categoryID
            JOIN 
                InventoryItems ii ON rci.itemID = ii.itemID
        """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                inventories.add(mapResultSetToRoomCategoryInventory(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return inventories;
    }

    // Helper method to map ResultSet to RoomCategoryInventory object
    private RoomCategoryInventory mapResultSetToRoomCategoryInventory(ResultSet rs) throws SQLException {
        RoomCategoryInventory roomInventory = new RoomCategoryInventory();

        // Map RoomCategoryInventoryID and Default Quantity
        roomInventory.setRoomCategoryInventoryID(rs.getInt("roomCategoryInventoryID"));
        roomInventory.setDefaultQuantity(rs.getInt("defaultQuantity"));

        // Set category name
        RoomCategory category = new RoomCategory();
        category.setCategoryName(rs.getString("categoryName"));
        roomInventory.setCategory(category);

        // Set item name
        InventoryItem item = new InventoryItem();
        item.setItemName(rs.getString("itemName"));
        roomInventory.setItem(item);

        return roomInventory;
    }
    
    public static void main(String[] args) {
        // Test RoomCategoryInventory
        System.out.println("=== Testing RoomCategoryInventory List ===");
        RoomCategoryInventoryDAO inventoryDAO = new RoomCategoryInventoryDAO();
        List<RoomCategoryInventory> inventories = inventoryDAO.getAllRoomCategoryInventories();
        if (inventories != null && !inventories.isEmpty()) {
            for (RoomCategoryInventory inventory : inventories) {
                System.out.println("ID: " + inventory.getRoomCategoryInventoryID());
                System.out.println("Category: " + (inventory.getCategory() != null ? inventory.getCategory().getCategoryName() : "null"));
                System.out.println("Item: " + (inventory.getItem() != null ? inventory.getItem().getItemName() : "null"));
                System.out.println("Default Quantity: " + inventory.getDefaultQuantity());
                System.out.println("----------------------------------");
            }
        } else {
            System.out.println("No RoomCategoryInventory found.");
        }

        // Test RoomCategory
        System.out.println("\n=== Testing RoomCategory List ===");
        RoomCategoryDAO categoryDAO = new RoomCategoryDAO();
        List<RoomCategory> categories = categoryDAO.getAllRoomCategories();
        if (categories != null && !categories.isEmpty()) {
            for (RoomCategory category : categories) {
                System.out.println("Category ID: " + category.getCategoryID());
                System.out.println("Category Name: " + category.getCategoryName());
                System.out.println("Description: " + category.getDescription());
                System.out.println("Base Price Per Night: " + category.getBasePricePerNight());
                System.out.println("Capacity: " + category.getCapacity());
                System.out.println("----------------------------------");
            }
        } else {
            System.out.println("No RoomCategory found.");
        }

        // Test InventoryItem
        System.out.println("\n=== Testing InventoryItem List ===");
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        List<InventoryItem> items = itemDAO.getAllInventoryItems();
        if (items != null && !items.isEmpty()) {
            for (InventoryItem item : items) {
                System.out.println("Item ID: " + item.getItemID());
                System.out.println("Item Name: " + item.getItemName());
                System.out.println("Description: " + item.getDescription());
                System.out.println("Default Charge: " + item.getDefaultCharge());
                System.out.println("----------------------------------");
            }
        } else {
            System.out.println("No InventoryItem found.");
        }
    }
}
