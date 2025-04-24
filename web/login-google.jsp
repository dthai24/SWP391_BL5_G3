<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.User" %>
<!DOCTYPE html>
<html lang="zxx">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài khoản chưa có trong hệ thống</title>
    <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="css/font-awesome.min.css" type="text/css">
    <link rel="stylesheet" href="css/style.css" type="text/css">
    <style>
        .btn-custom {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-align: center;
            font-size: 16px;
            width: 100%;
            border-radius: 5px;
            border: none;
            cursor: pointer;
        }

        .btn-custom:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container d-flex justify-content-center align-items-center vh-100">
        <div class="card shadow-lg p-4" style="max-width: 400px; width: 100%;">
            <div class="card-body">
                <div class="text-center mb-4">
                    <h3>Tài khoản chưa có trong hệ thống</h3>
                    <p>Rất tiếc, tài khoản <%= request.getAttribute("email") %> chưa được đăng ký trong hệ thống của chúng tôi.</p>
                    <p>Bạn có muốn đăng ký một tài khoản mới không?</p>
                    <form action="register.jsp" method="get">
                        <button type="submit" class="btn-custom">Đăng ký ngay</button>
                    </form>
                    <br>
                    <p>Hoặc bạn có thể <a href="login.jsp">quay lại trang đăng nhập</a> nếu không muốn đăng ký.</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
