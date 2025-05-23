package Controller;

import Dal.RoomCategoryDAO;
import Model.RoomCategory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "RoomCategoryServlet", urlPatterns = {"/roomcategory"})
public class RoomCategoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RoomCategoryDAO categoryDAO = new RoomCategoryDAO();
        String filterStatus = request.getParameter("filterStatus");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");
        List<RoomCategory> categories = categoryDAO.getAllRoomCategories();
        if (filterStatus != null && !filterStatus.isEmpty()) {
            if ("active".equals(filterStatus)) {
                categories.removeIf(cat -> cat.getIsDeleted());
            } else if ("deleted".equals(filterStatus)) {
                categories.removeIf(cat -> !cat.getIsDeleted());
            }
        }
        if ((minPriceParam != null && !minPriceParam.isEmpty()) || (maxPriceParam != null && !maxPriceParam.isEmpty())) {
            try {
                java.math.BigDecimal minPrice = minPriceParam != null && !minPriceParam.isEmpty() ? new java.math.BigDecimal(minPriceParam) : null;
                java.math.BigDecimal maxPrice = maxPriceParam != null && !maxPriceParam.isEmpty() ? new java.math.BigDecimal(maxPriceParam) : null;
                categories.removeIf(cat -> (minPrice != null && cat.getBasePricePerNight().compareTo(minPrice) < 0)
                        || (maxPrice != null && cat.getBasePricePerNight().compareTo(maxPrice) > 0));
            } catch (NumberFormatException e) {
                // ignore invalid input
            }
        }
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("RoomCategory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RoomCategoryDAO categoryDAO = new RoomCategoryDAO();
        String deleteCategoryID = request.getParameter("deleteCategoryID");
        if (deleteCategoryID != null && !deleteCategoryID.isEmpty()) {
            try {
                int id = Integer.parseInt(deleteCategoryID);
                categoryDAO.deleteRoomCategory(id);
            } catch (NumberFormatException e) {
                // ignore
            }
            response.sendRedirect("roomcategory");
            return;
        }
        String categoryID = request.getParameter("categoryID");
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        String basePricePerNight = request.getParameter("basePricePerNight");
        boolean isUpdate = categoryID != null && !categoryID.isEmpty();
        if (categoryName == null || categoryName.trim().isEmpty()) {
            request.setAttribute("error", "Tên loại phòng không được để trống.");
            doGet(request, response);
            return;
        }
        RoomCategory category = new RoomCategory();
        if (isUpdate) {
            category.setCategoryID(Integer.parseInt(categoryID));
        }
        category.setCategoryName(categoryName);
        category.setDescription(description);
        try {
            category.setBasePricePerNight(new BigDecimal(basePricePerNight));
        } catch (Exception e) {
            category.setBasePricePerNight(BigDecimal.ZERO);
        }
        if (isUpdate) {
            categoryDAO.updateRoomCategory(category);
        } else {
            categoryDAO.addRoomCategory(category);
        }
        response.sendRedirect("roomcategory");
    }
}
