<%@ page import="Model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Người Dùng</title>
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
        <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
            <h3>Chi Tiết Người Dùng</h3>
            <!-- Nút Back -->
            <a href="<%= request.getContextPath() %>/user?action=list" class="btn btn-light btn-sm">
                <i class="fa fa-arrow-left"></i> Trở Về
            </a>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4 text-center">
                    <img src="<%= user.getProfilePictureURL() != null && !user.getProfilePictureURL().trim().isEmpty() 
                                   ? user.getProfilePictureURL() 
                                   : "https://i.pinimg.com/236x/5e/e0/82/5ee082781b8c41406a2a50a0f32d6aa6.jpg" %>" 
                         alt="Avatar" class="img-fluid rounded-circle mb-3" style="width: 150px; height: 150px;">
                </div>
                <div class="col-md-8">
                    <p><strong>Tên Người Dùng:</strong> <%= user.getUsername() != null ? user.getUsername() : "N/A" %></p>
                    <p><strong>Họ Tên:</strong> <%= user.getFullName() != null ? user.getFullName() : "N/A" %></p>
                    <p><strong>Email:</strong> <%= user.getEmail() != null ? user.getEmail() : "N/A" %></p>
                    <p><strong>Số Điện Thoại:</strong> <%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "N/A" %></p>
                    <p><strong>Địa Chỉ:</strong> <%= user.getAddress() != null ? user.getAddress() : "N/A" %></p>
                    <p><strong>Vai Trò:</strong> <%= user.getRole() != null ? user.getRole() : "N/A" %></p>
                    <p><strong>Trạng Thái:</strong> <%= user.getStatus() != null ? user.getStatus() : "N/A" %></p>
                    <p><strong>Ngày Đăng Ký:</strong> <%= user.getRegistrationDate() != null ? user.getRegistrationDate() : "N/A" %></p>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
</body>
</html>