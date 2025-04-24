<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0">
    <title>Change Password</title>
    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">
    <link rel="stylesheet" type="text/css" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="assets/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <style>
        body {
            background: #f4f7fa;
            font-family: 'Arial', sans-serif;
        }

        .account-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .account-page {
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 450px;
        }

        .account-logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .account-logo h2 {
            font-size: 30px;
            color: #5e72e4; /* Màu chữ Quên Mật Khẩu */
            font-weight: 700;
            margin: 0;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            font-weight: 600;
            font-size: 14px;
            color: #333;
        }

        .form-control {
            border-radius: 25px;
            padding: 15px;
            font-size: 16px;
            border: 1px solid #ddd;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .form-control:focus {
            border-color: #5e72e4;
            box-shadow: 0 0 5px rgba(94, 114, 228, 0.4);
        }

        .account-btn {
            width: 100%;
            padding: 15px;
            border-radius: 25px;
            font-size: 16px;
            background-color: #5e72e4; /* Màu nền nút Reset Password */
            color: white;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .account-btn:hover {
            background-color: #4e61c2; /* Màu nền khi hover */
        }

        .register-link a {
            color: #5e72e4;
            font-size: 14px;
            text-decoration: none;
            font-weight: 600;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .error-message {
            color: red;
            font-size: 14px;
        }
    </style>
</head>

<body>
    <%@ include file="header.jsp" %>

    <div class="main-wrapper account-wrapper">
        <div class="account-page">
            <div class="account-center">
                <div class="account-box">
                    <form class="form-signin" action="forgotpassword" method="post">
                        <div class="account-logo">
                            <!-- Dòng chữ Quên Mật Khẩu -->
                            <h2>Quên Mật Khẩu</h2>
                        </div>

                        <div class="form-group">
                            <label for="email">Enter Your Email</label>
                            <div class="error-message">${requestScope.err}</div>
                            <input type="text" name="email" class="form-control" required>
                        </div>

                        <div class="form-group text-center">
                            <span class="text-danger" id="error-message"></span>
                        </div>

                        <div class="form-group text-center">
                            <button class="btn btn-primary account-btn" type="submit">Reset Password</button>
                        </div>

                        <div class="text-center register-link">
                            <a href="login.jsp">Back to Login</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
</body>

</html>
