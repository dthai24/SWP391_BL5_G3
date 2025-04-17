<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="css/style.css"> 
</head>
<body>
    <div class="login-container">
        <h2>Đăng Nhập</h2>
        <c:if test="${not empty param.error}">
            <div class="error">${param.error}</div>
        </c:if>
        <form action="login" method="post">
            <label for="username">Tên Đăng Nhập:</label>
            <input type="text" id="username" name="username" required>
            <label for="password">Mật Khẩu:</label>
            <input type="password" id="password" name="password" required>
            <button type="submit">Đăng Nhập</button>
        </form>

        <p>Chưa có tài khoản? <a href="register.jsp">Đăng Ký ngay</a></p> 
    </div>
</body>
</html>