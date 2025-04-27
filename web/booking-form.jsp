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
    // Gi? s? thông tin ng??i dùng ???c l?y t? session ho?c m?t ngu?n khác
    String userFullName = "Nguy?n V?n A"; // Thay th? b?ng session ho?c d? li?u th?c t?
    String userEmail = "nguyenvana@example.com"; // Thay th? b?ng session ho?c d? li?u th?c t?
%>
<div class="container mt-5">
    <!-- Nút Quay l?i -->
    <div class="text-left mb-3">
        <a href="RoomDetailPage.jsp?categoryId=<%=categoryIdParam%>" class="btn btn-secondary">Quay l?i</a>
    </div>

    <!-- Form Booking -->
    <div id="bookingFormContainer" class="booking-form shadow p-4 rounded bg-light">
        <h3 class="text-center mb-4">Booking Your Hotel</h3>
        <form action="BookingServlet" method="post">
            <!-- Hidden field to pass the category ID -->
            <input type="hidden" name="categoryId" value="<%=category != null ? category.getCategoryID() : ""%>">

            <!-- H? và Tên khách hàng + Email -->
            <div class="form-row mb-3">
                <div class="col">
                    <label for="customerName">H? và Tên khách hàng:</label>
                    <input type="text" id="customerName" class="form-control" value="<%=userFullName%>" readonly>
                </div>
                <div class="col">
                    <label for="customerEmail">Email:</label>
                    <input type="email" id="customerEmail" class="form-control" value="<%=userEmail%>" readonly>
                </div>
            </div>

            <!-- Th?i gian Check-in và Check-out (24 gi?) -->
            <div class="form-row mb-3">
                <div class="col">
                    <label for="date-in">Th?i gian Check-in:</label>
                    <input type="datetime-local" class="form-control" id="date-in" name="checkIn" required>
                </div>
                <div class="col">
                    <label for="date-out">Th?i gian Check-out:</label>
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

            <!-- S? l??ng ng??i l?n + Tr? em -->
            <div class="form-row mb-3">
                <div class="col">
                    <label for="adults">S? l??ng ng??i l?n:</label>
                    <select id="adults" name="adults" class="form-control">
                        <option value="1">1 Ng??i l?n</option>
                        <option value="2">2 Ng??i l?n</option>
                        <option value="3">3 Ng??i l?n</option>
                        <option value="4">4 Ng??i l?n</option>
                    </select>
                </div>
                <div class="col">
                    <label for="children">S? l??ng tr? em:</label>
                    <select id="children" name="children" class="form-control">
                        <option value="0">0 Tr? em</option>
                        <option value="1">1 Tr? em</option>
                        <option value="2">2 Tr? em</option>
                        <option value="3">3 Tr? em</option>
                    </select>
                </div>
            </div>

            <!-- Ghi chú -->
            <div class="form-row mb-3">
                <div class="col">
                    <label for="requests">Ghi chú:</label>
                    <textarea id="requests" name="requests" class="form-control" placeholder="Nh?p ghi chú (n?u có)"></textarea>
                </div>
            </div>

            <!-- Nút ??t -->
            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary px-4">??t</button>
            </div>
        </form>
    </div>
</div>
<%@include file="footer.jsp" %>