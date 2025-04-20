<%@ page import="Model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa Người Dùng</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
</head>
<body>
<%
    User user = (User) request.getAttribute("userDetail");
    if (user == null) {
%>
    <div class="alert alert-danger text-center mt-5">
        Người dùng không tồn tại hoặc không hợp lệ!
    </div>
<%
        return;
    }
%>
<div class="container mt-5">
    <div class="card shadow-lg">
        <div class="card-header bg-warning text-white d-flex justify-content-between align-items-center">
            <h3>Sửa Người Dùng</h3>
            <!-- Nút Hủy để trở về trang danh sách -->
            <a href="<%= request.getContextPath() %>/user?action=list" class="btn btn-light btn-sm">
                <i class="fa fa-arrow-left"></i> Hủy
            </a>
        </div>
        <div class="card-body">
            <form action="user" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="userID" value="<%= user.getUserID() %>">
                <div class="form-group">
                    <label>Tên Người Dùng</label>
                    <input type="text" name="username" class="form-control" 
                           value="<%= user.getUsername() != null ? user.getUsername() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Họ Tên</label>
                    <input type="text" name="fullName" class="form-control" 
                           value="<%= user.getFullName() != null ? user.getFullName() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" 
                           value="<%= user.getEmail() != null ? user.getEmail() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Số Điện Thoại</label>
                    <input type="text" name="phoneNumber" class="form-control" 
                           value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>">
                </div>
                <div class="form-group">
                    <label>Địa Chỉ</label>
                    <input type="text" name="address" class="form-control" 
                           value="<%= user.getAddress() != null ? user.getAddress() : "" %>">
                </div>
                <div class="form-group">
                    <label>Vai Trò</label>
                    <select name="role" class="form-control">
                        <option value="Admin" <%= "Admin".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
                        <option value="Customer" <%= "Customer".equals(user.getRole()) ? "selected" : "" %>>Customer</option>
                        <option value="Staff" <%= "Staff".equals(user.getRole()) ? "selected" : "" %>>Staff</option>
                        <option value="Receptionist" <%= "Receptionist".equals(user.getRole()) ? "selected" : "" %>>Receptionist</option>
                        <option value="Manager" <%= "Manager".equals(user.getRole()) ? "selected" : "" %>>Manager</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Trạng Thái</label>
                    <select name="status" class="form-control">
                        <option value="Active" <%= "Active".equals(user.getStatus()) ? "selected" : "" %>>Active</option>
                        <option value="Inactive" <%= "Inactive".equals(user.getStatus()) ? "selected" : "" %>>Inactive</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Lưu</button>
                <a href="<%= request.getContextPath() %>/user?action=list" class="btn btn-secondary">Hủy</a>
            </form>
        </div>
    </div>
</div>
<script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
</body>
</html>