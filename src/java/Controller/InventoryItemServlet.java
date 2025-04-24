package Controller;

import Dal.InventoryItemDAO;
import Model.InventoryItem;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.List;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "InventoryItemServlet", urlPatterns = {"/inventory-item"})
public class InventoryItemServlet extends HttpServlet {

    // GET: Hiển thị danh sách và filter
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        InventoryItemDAO inventoryItemDAO = new InventoryItemDAO();
        List<InventoryItem> items = inventoryItemDAO.getAllInventoryItems();
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");
        if ((minPriceParam != null && !minPriceParam.isEmpty()) || (maxPriceParam != null && !maxPriceParam.isEmpty())) {
            try {
                java.math.BigDecimal minPrice = minPriceParam != null && !minPriceParam.isEmpty() ? new java.math.BigDecimal(minPriceParam) : null;
                java.math.BigDecimal maxPrice = maxPriceParam != null && !maxPriceParam.isEmpty() ? new java.math.BigDecimal(maxPriceParam) : null;
                items.removeIf(cat -> (minPrice != null && cat.getDefaultCharge().compareTo(minPrice) < 0)
                        || (maxPrice != null && cat.getDefaultCharge().compareTo(maxPrice) > 0));
            } catch (NumberFormatException e) {
                // ignore invalid input
            }
        }
        request.setAttribute("items", items);
        request.getRequestDispatcher("View/Inventory/inventory-item.jsp").forward(request, response);
    }

    // POST: Thêm, sửa, xóa
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        InventoryItemDAO inventoryItemDAO = new InventoryItemDAO();
        String deleteItemID = request.getParameter("deleteItemID");
        if (deleteItemID != null && !deleteItemID.isEmpty()) {
            try {
                int id = Integer.parseInt(deleteItemID);
                inventoryItemDAO.deleteInventoryItem(id);
            } catch (NumberFormatException e) {
                // ignore
            }
            response.sendRedirect("inventory-item");
            return;
        }
        // Lấy dữ liệu từ request
        String itemID = request.getParameter("itemID");
        String itemName = request.getParameter("itemName");
        String description = request.getParameter("description");
        String defaultCharge = request.getParameter("defaultCharge");
        boolean isUpdate = itemID != null && !itemID.isEmpty();

        // Kiểm tra tính hợp lệ của dữ liệu
        if (itemName == null || itemName.trim().isEmpty()) {
            request.setAttribute("error", "Tên vật phẩm không được để trống.");
            doGet(request, response);
            return;
        }
        if (!isUpdate && inventoryItemDAO.isItemNameTaken(itemName)){
            request.setAttribute("error", "Tên vật phẩm không được trùng.");
            doGet(request, response);
            return;
        }

        InventoryItem item = new InventoryItem();
        if (isUpdate) {
            item.setItemID(Integer.parseInt(itemID));
        }
        item.setItemName(itemName);
        item.setDescription(description);
        try {
            if (defaultCharge == null || defaultCharge.trim().isEmpty()) {
                request.setAttribute("error", "Giá mặc định không được để trống.");
                doGet(request, response);
                return;
            } else {
                try {
                    BigDecimal charge = new BigDecimal(defaultCharge);

                    // Kiểm tra nếu giá trị nhỏ hơn 0
                    if (charge.compareTo(BigDecimal.ZERO) < 0) {
                        request.setAttribute("error", "Giá mặc định phải lớn hơn hoặc bằng 0.");
                        doGet(request, response);
                        return;
                    } else {
                        item.setDefaultCharge(charge); // Gán giá trị hợp lệ
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Giá mặc định phải là một số hợp lệ.");
                    doGet(request, response);
                    return;
                }
            }
        } catch (Exception e) {
            item.setDefaultCharge(BigDecimal.ZERO); // Giá mặc định là 0 nếu không hợp lệ
        }

        // Thực hiện cập nhật hoặc thêm mới
        if (isUpdate) {
            inventoryItemDAO.updateInventoryItem(item);
        } else {
            inventoryItemDAO.addInventoryItem(item);
        }

        // Chuyển hướng về danh sách vật phẩm
        response.sendRedirect("inventory-item");
    }
}

