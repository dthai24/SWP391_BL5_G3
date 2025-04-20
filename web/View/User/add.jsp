<%@ page import="java.util.Map" %>
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
<%
    Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
%>
<div class="container mt-5">
    <div class="card shadow-lg">
        <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
            <h3>Thêm Người Dùng</h3>
            <!-- Nút quay lại danh sách -->
            <a href="<%= request.getContextPath() %>/user?action=list" class="btn btn-light btn-sm">Quay lại</a>
        </div>
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/user" method="post">
                <input type="hidden" name="action" value="add">

                <!-- Tên Người Dùng -->
                <div class="form-group">
                    <label>Tên Người Dùng</label>
                    <input type="text" name="username" class="form-control <%= (errors != null && errors.containsKey("username")) ? "is-invalid" : "" %>" 
                           value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>" required>
                    <% if (errors != null && errors.containsKey("username")) { %>
                        <div class="invalid-feedback"><%= errors.get("username") %></div>
                    <% } %>
                </div>

                <!-- Mật Khẩu -->
                <div class="form-group">
                    <label>Mật Khẩu</label>
                    <input type="password" name="password" class="form-control <%= (errors != null && errors.containsKey("password")) ? "is-invalid" : "" %>" 
                           required>
                    <% if (errors != null && errors.containsKey("password")) { %>
                        <div class="invalid-feedback"><%= errors.get("password") %></div>
                    <% } %>
                </div>

                <!-- Họ Tên -->
                <div class="form-group">
                    <label>Họ Tên</label>
                    <input type="text" name="fullName" class="form-control <%= (errors != null && errors.containsKey("fullName")) ? "is-invalid" : "" %>" 
                           value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>" required>
                    <% if (errors != null && errors.containsKey("fullName")) { %>
                        <div class="invalid-feedback"><%= errors.get("fullName") %></div>
                    <% } %>
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control <%= (errors != null && errors.containsKey("email")) ? "is-invalid" : "" %>" 
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" required>
                    <% if (errors != null && errors.containsKey("email")) { %>
                        <div class="invalid-feedback"><%= errors.get("email") %></div>
                    <% } %>
                </div>

                <!-- Số Điện Thoại -->
                <div class="form-group">
                    <label>Số Điện Thoại</label>
                    <input type="text" name="phoneNumber" class="form-control <%= (errors != null && errors.containsKey("phoneNumber")) ? "is-invalid" : "" %>" 
                           value="<%= request.getParameter("phoneNumber") != null ? request.getParameter("phoneNumber") : "" %>">
                    <% if (errors != null && errors.containsKey("phoneNumber")) { %>
                        <div class="invalid-feedback"><%= errors.get("phoneNumber") %></div>
                    <% } %>
                </div>

                <!-- Địa Chỉ -->
                <div class="form-group">
                    <label>Địa Chỉ</label>
                    <input type="text" name="address" class="form-control <%= (errors != null && errors.containsKey("address")) ? "is-invalid" : "" %>" 
                           value="<%= request.getParameter("address") != null ? request.getParameter("address") : "" %>">
                    <% if (errors != null && errors.containsKey("address")) { %>
                        <div class="invalid-feedback"><%= errors.get("address") %></div>
                    <% } %>
                </div>

                <!-- URL Ảnh -->
                <div class="form-group">
                    <label>URL Ảnh Đại Diện</label>
                    <input type="text" name="profilePictureURL" class="form-control <%= (errors != null && errors.containsKey("profilePictureURL")) ? "is-invalid" : "" %>" 
                           placeholder="Nhập URL ảnh đại diện"
                           value="<%= request.getParameter("profilePictureURL") != null ? request.getParameter("profilePictureURL") : "" %>">
                    <% if (errors != null && errors.containsKey("profilePictureURL")) { %>
                        <div class="invalid-feedback"><%= errors.get("profilePictureURL") %></div>
                    <% } %>
                </div>

                <!-- Vai Trò -->
                <div class="form-group">
                    <label>Vai Trò</label>
                    <select name="role" class="form-control <%= (errors != null && errors.containsKey("role")) ? "is-invalid" : "" %>">
                        <option value="Admin" <%= "Admin".equals(request.getParameter("role")) ? "selected" : "" %>>Admin</option>
                        <option value="Customer" <%= "Customer".equals(request.getParameter("role")) ? "selected" : "" %>>Customer</option>
                        <option value="Staff" <%= "Staff".equals(request.getParameter("role")) ? "selected" : "" %>>Staff</option>
                        <option value="Receptionist" <%= "Receptionist".equals(request.getParameter("role")) ? "selected" : "" %>>Receptionist</option>
                        <option value="Manager" <%= "Manager".equals(request.getParameter("role")) ? "selected" : "" %>>Manager</option>
                    </select>
                    <% if (errors != null && errors.containsKey("role")) { %>
                        <div class="invalid-feedback"><%= errors.get("role") %></div>
                    <% } %>
                </div>

                <!-- Trạng Thái -->
                <div class="form-group">
                    <label>Trạng Thái</label>
                    <select name="status" class="form-control <%= (errors != null && errors.containsKey("status")) ? "is-invalid" : "" %>">
                        <option value="Active" <%= "Active".equals(request.getParameter("status")) ? "selected" : "" %>>Active</option>
                        <option value="Inactive" <%= "Inactive".equals(request.getParameter("status")) ? "selected" : "" %>>Inactive</option>
                    </select>
                    <% if (errors != null && errors.containsKey("status")) { %>
                        <div class="invalid-feedback"><%= errors.get("status") %></div>
                    <% } %>
                </div>

                <button type="submit" class="btn btn-primary">Thêm Người Dùng</button>
            </form>
        </div>
    </div>
</div>
<script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
</body>
</html>