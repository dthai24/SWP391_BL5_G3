/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import Dal.InventoryItemDAO;
import Model.InventoryItem;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "InventoryServlet", urlPatterns = {"/inventory-item"})
public class InventoryServlet extends HttpServlet {
    private InventoryItemDAO inventoryItemDAO;

    @Override
    public void init() {
        inventoryItemDAO = new InventoryItemDAO();
    }

    // GET: Hiển thị danh sách và xử lý edit
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String itemIdParam = request.getParameter("edit");
        InventoryItem editItem = null;

        if (itemIdParam != null) {
            try {
                int itemId = Integer.parseInt(itemIdParam);
                editItem = inventoryItemDAO.getInventoryItemById(itemId);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID không hợp lệ.");
            }
        }

        List<InventoryItem> items = inventoryItemDAO.getAllInventoryItems();
        request.setAttribute("items", items);
        request.setAttribute("editItem", editItem);
        request.getRequestDispatcher("View/Inventory/inventory-item.jsp").forward(request, response);
    }

    // POST: Thêm, sửa, xóa
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String deleteId = request.getParameter("deleteItemID");

        if (deleteId != null && !deleteId.isEmpty()) {
            handleDeleteInventoryItem(request, response, deleteId);
            return;
        }

        if ("add".equals(action)) {
            handleAddInventoryItem(request, response);
        } else if ("edit".equals(action)) {
            handleEditInventoryItem(request, response);
        } else {
            response.sendRedirect("inventory-item");
        }
    }
    private void handleAddInventoryItem(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        InventoryItem item = extractInventoryItemFromRequest(request);
        Map<String, String> errors = validateInventoryItemInputs(item, false, null);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            doGet(request, response);
            return;
        }

        boolean success = inventoryItemDAO.addInventoryItem(item);
        if (success) {
            request.setAttribute("successMessage", "Thêm vật phẩm thành công!");
        } else {
            request.setAttribute("errorMessage", "Không thể thêm vật phẩm.");
        }

        doGet(request, response);
    }


    private void handleEditInventoryItem(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String itemIdParam = request.getParameter("itemID");
        if (itemIdParam == null || itemIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "ID vật phẩm không hợp lệ.");
            doGet(request, response);
            return;
        }

        try {
            int itemID = Integer.parseInt(itemIdParam);
            InventoryItem item = inventoryItemDAO.getInventoryItemById(itemID);

            if (item == null) {
                request.setAttribute("errorMessage", "Không tìm thấy vật phẩm.");
                doGet(request, response);
                return;
            }

            // Cập nhật dữ liệu vật phẩm từ request
            updateInventoryItemFromRequest(request, item);
            Map<String, String> errors = validateInventoryItemInputs(item, true, itemID);

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                doGet(request, response);
                return;
            }

            boolean success = inventoryItemDAO.updateInventoryItem(item);
            if (success) {
                request.setAttribute("successMessage", "Chỉnh sửa vật phẩm thành công!");
            } else {
                request.setAttribute("errorMessage", "Không thể chỉnh sửa vật phẩm.");
            }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID vật phẩm không hợp lệ.");
            }

        doGet(request, response);
    }
    
    private void handleDeleteInventoryItem(HttpServletRequest request, HttpServletResponse response, String deleteItemIdParam)
        throws IOException {
        try {
            int deleteItemId = Integer.parseInt(deleteItemIdParam);
            boolean success = inventoryItemDAO.deleteInventoryItem(deleteItemId);

            if (success) {
                request.setAttribute("successMessage", "Xóa vật phẩm thành công!");
            } else {
                request.setAttribute("errorMessage", "Không thể xóa vật phẩm.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID vật phẩm không hợp lệ.");
        }
        response.sendRedirect("inventory-item");
    }

    private InventoryItem extractInventoryItemFromRequest(HttpServletRequest request) {
        InventoryItem inventory = new InventoryItem();
        inventory.setItemName(request.getParameter("itemName"));
        inventory.setDescription(request.getParameter("description"));
        String chargeStr = request.getParameter("defaultCharge");
        if (chargeStr != null && !chargeStr.isEmpty()) {
            inventory.setDefaultCharge(new BigDecimal(chargeStr));
        }
        inventory.setIsDeleted(false);
        return inventory;
    }

    private Map<String, String> validateInventoryItemInputs(InventoryItem item, boolean isEdit, Object itemID) {
        Map<String, String> errors = new HashMap<>();

        if (item.getItemName() == null || item.getItemName().trim().isEmpty()) {
            errors.put("itemName", "Tên vật phẩm không được để trống.");
        }

        if (item.getDefaultCharge() == null) {
            errors.put("defaultCharge", "Giá mặc định không được để trống.");
        } else if (item.getDefaultCharge().compareTo(BigDecimal.ZERO) < 0) {
            errors.put("defaultCharge", "Giá mặc định phải lớn hơn hoặc bằng 0.");
        }

        return errors;
    }

    private void updateInventoryItemFromRequest(HttpServletRequest request, InventoryItem item) {
        item.setItemName(request.getParameter("username"));
        item.setItemName(request.getParameter("username"));
        String chargeStr = request.getParameter("defaultCharge");
        if (chargeStr != null && !chargeStr.isEmpty()) {
            item.setDefaultCharge(new BigDecimal(chargeStr));
        }
    }
}