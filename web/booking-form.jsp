<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="Model.RoomCategory" %>
<%@page import="Dal.RoomCategoryDAO" %>
<%@include file="header.jsp" %>
<%
    String categoryIdParam = request.getParameter("categoryId");
    RoomCategory category = null;
    if (categoryIdParam != null) {
        try {
            int categoryId = Integer.parseInt(categoryIdParam);
            category = new RoomCategoryDAO().getRoomCategoryById(categoryId);
        } catch (Exception e) {
            // handle error
        }
    }
    // Giả sử thông tin người dùng được lấy từ session hoặc một nguồn khác
    String userFullName = "Nguyễn Văn A"; // Thay thế bằng session hoặc dữ liệu thực tế
    String userEmail = "nguyenvana@example.com"; // Thay thế bằng session hoặc dữ liệu thực tế
%>
<div class="container mt-5">
    <!-- Nút Quay lại -->
    <div class="text-left mb-3">
        <a href="RoomDetailsPage.jsp?categoryId=<%=categoryIdParam%>" class="btn btn-secondary">Quay lại</a>
    </div>

    <!-- Form Booking -->
    <div id="bookingFormContainer" class="booking-form shadow p-4 rounded bg-light">
        <h3 class="text-center mb-4">Booking Your Hotel</h3>
        <form action="BookingServlet" method="post">
            <!-- Hidden field to pass the category ID -->
            <input type="hidden" name="categoryId" value="<%=category != null ? category.getCategoryID() : ""%>">

            <!-- Họ và Tên khách hàng + Email -->
            <div class="form-row mb-3">
                <div class="col">
                    <label for="customerName">Họ và Tên khách hàng:</label>
                    <input type="text" id="customerName" class="form-control" value="<%=userFullName%>" readonly>
                </div>
                <div class="col">
                    <label for="customerEmail">Email:</label>
                    <input type="email" id="customerEmail" class="form-control" value="<%=userEmail%>" readonly>
                </div>
            </div>

            <!-- Thời gian Check-in và Check-out (24 giờ) -->
            <div class="form-row mb-3">
                <div class="col">
                    <label for="date-in">Thời gian Check-in:</label>
                    <input type="datetime-local" class="form-control" id="date-in" name="checkIn" required>
                </div>
                <div class="col">
                    <label for="date-out">Thời gian Check-out:</label>
                    <input type="datetime-local" class="form-control" id="date-out" name="checkOut" required>
                </div>
            </div>

            <!-- Tên phòng -->
            <div class="form-row mb-3">
                <div class="col">
                    <label for="roomName">Tên phòng:</label>
                    <input type="text" id="roomName" class="form-control" value="<%=category != null ? category.getCategoryName() : "Unknown"%>" readonly>
                </div>
            </div>

            <!-- Số lượng người lớn + Trẻ em -->
            <div class="form-row mb-3">
                <div class="col">
                    <label for="numberOfGuests">Số lượng người:</label>
                    <input type="number" id="numberOfGuests" class="form-control" required>                
                </div>
            </div>

            <!-- Ghi chú -->
            <div class="form-row mb-3">
                <div class="col">
                    <label for="requests">Ghi chú:</label>
                    <textarea id="requests" name="requests" class="form-control" placeholder="Nhập ghi chú (nếu có)"></textarea>
                </div>
            </div>

            <!-- Nút Đặt -->
            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary px-4">Đặt</button>
            </div>
        </form>
    </div>
</div>
<%@include file="footer.jsp" %>