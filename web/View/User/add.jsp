<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Người Dùng</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <!-- Hiển thị thông báo nếu có -->
    <% String message = (String) request.getAttribute("success");
       String error = (String) request.getAttribute("error");
       if (message != null) { %>
        <div class="alert alert-success"><%= message %></div>
    <% } else if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <div class="card shadow-lg">
        <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
            <h3>Thêm Người Dùng</h3>
            <!-- Nút quay lại danh sách -->
            <a href="<%= request.getContextPath() %>/user?action=list" class="btn btn-light btn-sm">Back to List</a>
        </div>
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/user" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-group">
                    <label for="username">Tên Người Dùng</label>
                    <input type="text" id="username" name="username" class="form-control" placeholder="Nhập tên người dùng" required>
                </div>
                <div class="form-group">
                    <label for="fullName">Họ Tên</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" placeholder="Nhập họ và tên" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="Nhập email" required>
                </div>
                <div class="form-group">
                    <label for="phoneNumber">Số Điện Thoại</label>
                    <input type="text" id="phoneNumber" name="phoneNumber" class="form-control" placeholder="Nhập số điện thoại (tùy chọn)">
                </div>
                <div class="form-group">
                    <label for="address">Địa Chỉ</label>
                    <input type="text" id="address" name="address" class="form-control" placeholder="Nhập địa chỉ (tùy chọn)">
                </div>
                <div class="form-group">
                    <label for="role">Vai Trò</label>
                    <select id="role" name="role" class="form-control">
                        <option value="Admin">Quản trị viên</option>
                        <option value="Customer">Khách hàng</option>
                        <option value="Staff">Nhân viên</option>
                        <option value="Receptionist">Tiếp tân</option>
                        <option value="Manager">Quản lý</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="status">Trạng Thái</label>
                    <select id="status" name="status" class="form-control">
                        <option value="Active">Hoạt động</option>
                        <option value="Inactive">Không hoạt động</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Thêm Người Dùng</button>
            </form>
        </div>
    </div>
</div>
<script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
</body>
</html>