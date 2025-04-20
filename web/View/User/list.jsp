<%@ page import="java.util.List" %>
<%@ page import="Model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Người Dùng</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    </head>
    <body>
        <%
            List<User> users = (List<User>) request.getAttribute("users");
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy"); // Format for registration date
        %>
        <div class="container mt-5">
            <!-- Hiển thị thông báo nếu có -->
            <% String success = request.getParameter("success");
               String error = request.getParameter("error");
               if (success != null) { %>
            <div class="alert alert-success"><%= success %></div>
            <% } else if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
            <% } %>

            <div class="card shadow-lg">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h3 class="mb-0">Danh Sách Người Dùng</h3>
                    <div>
                        <!-- Link đến add.jsp -->
                        <a href="<%= request.getContextPath() %>/user?action=add" class="btn btn-light btn-sm">
                            <i class="fa fa-plus"></i> Thêm Người Dùng
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <table class="table table-hover table-bordered">
                        <thead>
                            <tr>
                                <th>Avatar</th>
                                <th>ID</th>
                                <th>Tên Người Dùng</th>
                                <th>Email</th>
                                <th>Số Điện Thoại</th>
                                <th>Địa Chỉ</th>
                                <th>Vai Trò</th>
                                <th>Trạng Thái</th>
                                <th>Ngày Đăng Ký</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (users != null && !users.isEmpty()) {
                        for (User user : users) { %>
                            <tr>
                                <td>
                                    <img src="<%= user.getProfilePictureURL() != null ? user.getProfilePictureURL() : "https://via.placeholder.com/50" %>" 
                                         alt="Avatar" class="img-fluid rounded-circle" style="width: 50px; height: 50px;">
                                </td>
                                <td><%= user.getUserID() %></td>
                                <td><%= user.getUsername() %></td>
                                <td><%= user.getEmail() %></td>
                                <td><%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "N/A" %></td>
                                <td><%= user.getAddress() != null ? user.getAddress() : "N/A" %></td>
                                <td><%= user.getRole() %></td>
                                <td>
                                    <% if ("Active".equals(user.getStatus())) { %>
                                    <span class="badge badge-success">Hoạt động</span>
                                    <% } else { %>
                                    <span class="badge badge-danger">Không hoạt động</span>
                                    <% } %>
                                </td>
                                <td><%= user.getRegistrationDate() != null ? dateFormat.format(user.getRegistrationDate()) : "N/A" %></td>
                                <td>
                                    <!-- Link đến detail.jsp -->
                                    <a href="<%= request.getContextPath() %>/user?action=detail&userID=<%= user.getUserID() %>" class="btn btn-info btn-sm">
                                        Chi Tiết
                                    </a>
                                    <!-- Link đến edit.jsp -->
                                    <a href="<%= request.getContextPath() %>/user?action=edit&userID=<%= user.getUserID() %>" class="btn btn-warning btn-sm">
                                        <i class="fa fa-pencil-alt"></i> Sửa
                                    </a>
                                    <!-- Xóa người dùng -->
                                    <a href="<%= request.getContextPath() %>/user?action=delete&userID=<%= user.getUserID() %>" 
                                       class="btn btn-danger btn-sm" 
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này không?');">
                                        <i class="fa fa-trash"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                            <% }
                    } else { %>
                            <tr>
                                <td colspan="10" class="text-center">Không có người dùng nào.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
    </body>
</html>