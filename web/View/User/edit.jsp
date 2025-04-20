<%@ page import="java.util.Map" %>
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
    Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
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
            <form action="<%= request.getContextPath() %>/user" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="userID" value="<%= user.getUserID() %>">

                <!-- Tên Người Dùng -->
                <div class="form-group">
                    <label>Tên Người Dùng</label>
                    <input type="text" name="username" class="form-control <%= (errors != null && errors.containsKey("username")) ? "is-invalid" : "" %>" 
                           value="<%= user.getUsername() != null ? user.getUsername() : "" %>" required>
                    <% if (errors != null && errors.containsKey("username")) { %>
                        <div class="invalid-feedback"><%= errors.get("username") %></div>
                    <% } %>
                </div>

                <!-- Họ Tên -->
                <div class="form-group">
                    <label>Họ Tên</label>
                    <input type="text" name="fullName" class="form-control <%= (errors != null && errors.containsKey("fullName")) ? "is-invalid" : "" %>" 
                           value="<%= user.getFullName() != null ? user.getFullName() : "" %>" required>
                    <% if (errors != null && errors.containsKey("fullName")) { %>
                        <div class="invalid-feedback"><%= errors.get("fullName") %></div>
                    <% } %>
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control <%= (errors != null && errors.containsKey("email")) ? "is-invalid" : "" %>" 
                           value="<%= user.getEmail() != null ? user.getEmail() : "" %>" required>
                    <% if (errors != null && errors.containsKey("email")) { %>
                        <div class="invalid-feedback"><%= errors.get("email") %></div>
                    <% } %>
                </div>

                <!-- Số Điện Thoại -->
                <div class="form-group">
                    <label>Số Điện Thoại</label>
                    <input type="text" name="phoneNumber" class="form-control <%= (errors != null && errors.containsKey("phoneNumber")) ? "is-invalid" : "" %>" 
                           value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>">
                    <% if (errors != null && errors.containsKey("phoneNumber")) { %>
                        <div class="invalid-feedback"><%= errors.get("phoneNumber") %></div>
                    <% } %>
                </div>

                <!-- Địa Chỉ -->
                <div class="form-group">
                    <label>Địa Chỉ</label>
                    <input type="text" name="address" class="form-control <%= (errors != null && errors.containsKey("address")) ? "is-invalid" : "" %>" 
                           value="<%= user.getAddress() != null ? user.getAddress() : "" %>">
                    <% if (errors != null && errors.containsKey("address")) { %>
                        <div class="invalid-feedback"><%= errors.get("address") %></div>
                    <% } %>
                </div>

                <!-- URL Ảnh -->
                <div class="form-group">
                    <label>URL Ảnh Đại Diện</label>
                    <input type="text" name="profilePictureURL" class="form-control <%= (errors != null && errors.containsKey("profilePictureURL")) ? "is-invalid" : "" %>" 
                           placeholder="Nhập URL ảnh đại diện"
                           value="<%= user.getProfilePictureURL() != null ? user.getProfilePictureURL() : "" %>">
                    <% if (errors != null && errors.containsKey("profilePictureURL")) { %>
                        <div class="invalid-feedback"><%= errors.get("profilePictureURL") %></div>
                    <% } %>
                </div>

                <!-- Vai Trò -->
                <div class="form-group">
                    <label>Vai Trò</label>
                    <select name="role" class="form-control <%= (errors != null && errors.containsKey("role")) ? "is-invalid" : "" %>">
                        <option value="Admin" <%= "Admin".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
                        <option value="Customer" <%= "Customer".equals(user.getRole()) ? "selected" : "" %>>Customer</option>
                        <option value="Staff" <%= "Staff".equals(user.getRole()) ? "selected" : "" %>>Staff</option>
                        <option value="Receptionist" <%= "Receptionist".equals(user.getRole()) ? "selected" : "" %>>Receptionist</option>
                        <option value="Manager" <%= "Manager".equals(user.getRole()) ? "selected" : "" %>>Manager</option>
                    </select>
                    <% if (errors != null && errors.containsKey("role")) { %>
                        <div class="invalid-feedback"><%= errors.get("role") %></div>
                    <% } %>
                </div>

                <!-- Trạng Thái -->
                <div class="form-group">
                    <label>Trạng Thái</label>
                    <select name="status" class="form-control <%= (errors != null && errors.containsKey("status")) ? "is-invalid" : "" %>">
                        <option value="Active" <%= "Active".equals(user.getStatus()) ? "selected" : "" %>>Active</option>
                        <option value="Inactive" <%= "Inactive".equals(user.getStatus()) ? "selected" : "" %>>Inactive</option>
                    </select>
                    <% if (errors != null && errors.containsKey("status")) { %>
                        <div class="invalid-feedback"><%= errors.get("status") %></div>
                    <% } %>
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