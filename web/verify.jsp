<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Xác minh tài khoản</title>
    <link rel="stylesheet" href="css/style.css"> <!-- hoặc css chính của trang -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <style>
        .verify-container {
            margin: 100px auto;
            padding: 30px;
            max-width: 400px;
            background-color: #f7f7f7;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="verify-container">
    <h2>Xác minh tài khoản</h2>
    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
        <p style="color: red;"><%= error %></p>
    <% } %>
    <form action="verify" method="post">
        <label for="otp">Nhập mã OTP đã gửi đến email:</label><br>
        <input type="text" id="otp" name="otp" required style="margin: 10px 0; padding: 6px;"><br>
        <button type="submit" class="btn btn-primary">Xác minh</button>
    </form>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
