package Controller;

import Dal.InventoryItemDAO;
import Dal.RoomCategoryDAO;
import Dal.RoomCategoryInventoryDAO;
import Model.InventoryItem;
import Model.RoomCategory;
import Model.RoomCategoryInventory;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet for handling RoomCategoryInventory operations.
 */
@WebServlet(name = "RoomCategoryInventoryServlet", urlPatterns = {"/inventory-room"})
public class RoomCategoryInventoryServlet extends HttpServlet {

    // GET: Display list with relationships
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RoomCategoryInventoryDAO inventoryDAO = new RoomCategoryInventoryDAO();
        RoomCategoryDAO categoryDAO = new RoomCategoryDAO();
        InventoryItemDAO itemDAO = new InventoryItemDAO();

        // Fetch filter parameters
        String categoryIDParam = request.getParameter("categoryID");
        String itemIDParam = request.getParameter("itemID");

        // Fetch data
        List<RoomCategoryInventory> inventories = inventoryDAO.getAllRoomCategoryInventories();
        List<RoomCategory> categories = categoryDAO.getAllRoomCategories();
        List<InventoryItem> items = itemDAO.getAllInventoryItems();

        // Apply filters
        if (categoryIDParam != null && !categoryIDParam.isEmpty()) {
            int categoryID = Integer.parseInt(categoryIDParam);
            inventories.removeIf(inventory -> inventory.getCategory() == null || inventory.getCategory().getCategoryID() != categoryID);
        }
        if (itemIDParam != null && !itemIDParam.isEmpty()) {
            int itemID = Integer.parseInt(itemIDParam);
            inventories.removeIf(inventory -> inventory.getItem() == null || inventory.getItem().getItemID() != itemID);
        }

        // Set attributes for JSP
        request.setAttribute("inventories", inventories);
        request.setAttribute("categories", categories);
        request.setAttribute("items", items);

        // Forward to JSP
        request.getRequestDispatcher("View/Inventory/inventory-room.jsp").forward(request, response);
    }
    
    // POST: Add, update, delete operations
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RoomCategoryInventoryDAO inventoryDAO = new RoomCategoryInventoryDAO();

        // Handle delete operation
        String deleteInventoryID = request.getParameter("deleteInventoryID");
        if (deleteInventoryID != null && !deleteInventoryID.isEmpty()) {
            try {
                int id = Integer.parseInt(deleteInventoryID);
                inventoryDAO.deleteRoomCategoryInventory(id);
            } catch (NumberFormatException e) {
                // Ignore invalid ID format
            }
            response.sendRedirect("room-category-inventory");
            return;
        }

        // Handle add/update operations
        String roomCategoryInventoryID = request.getParameter("roomCategoryInventoryID");
        String categoryID = request.getParameter("categoryID");
        String itemID = request.getParameter("itemID");
        String defaultQuantity = request.getParameter("defaultQuantity");

        boolean isUpdate = roomCategoryInventoryID != null && !roomCategoryInventoryID.isEmpty();

        // Validate data
        if (categoryID == null || categoryID.trim().isEmpty()) {
            request.setAttribute("error", "Category ID cannot be empty.");
            doGet(request, response);
            return;
        }

        if (itemID == null || itemID.trim().isEmpty()) {
            request.setAttribute("error", "Item ID cannot be empty.");
            doGet(request, response);
            return;
        }

        if (defaultQuantity == null || defaultQuantity.trim().isEmpty()) {
            request.setAttribute("error", "Default quantity cannot be empty.");
            doGet(request, response);
            return;
        }

        try {
            int categoryIDInt = Integer.parseInt(categoryID);
            int itemIDInt = Integer.parseInt(itemID);
            int defaultQuantityInt = Integer.parseInt(defaultQuantity);

            // Ensure default quantity is non-negative
            if (defaultQuantityInt < 0) {
                request.setAttribute("error", "Default quantity must be non-negative.");
                doGet(request, response);
                return;
            }

            RoomCategoryInventory inventory = new RoomCategoryInventory();
            if (isUpdate) {
                inventory.setRoomCategoryInventoryID(Integer.parseInt(roomCategoryInventoryID));
            }
            inventory.setCategoryID(categoryIDInt);
            inventory.setItemID(itemIDInt);
            inventory.setDefaultQuantity(defaultQuantityInt);

            // Add or update inventory
            if (isUpdate) {
                inventoryDAO.updateRoomCategoryInventory(inventory);
            } else {
                inventoryDAO.addRoomCategoryInventory(inventory);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid numeric value for ID or quantity.");
            doGet(request, response);
            return;
        }

        // Redirect to the inventory list
        response.sendRedirect("inventory-room");
    }
}