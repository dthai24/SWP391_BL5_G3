<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Google Login Error</title>
</head>
<body>
    <h2>Đã xảy ra lỗi khi đăng nhập bằng Google</h2>
    <p style="color: red;"><%= request.getAttribute("errorMessage") %></p>
    <a href="login.jsp">Quay lại trang chủ</a>
</body>
</html>