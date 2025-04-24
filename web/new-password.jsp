<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0">
    <title>Đặt lại mật khẩu</title>
    <link rel="stylesheet" type="text/css" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="assets/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
</head>
<body>
    <div class="main-wrapper account-wrapper">
        <div class="account-page">
            <div class="account-center">
                <div class="account-box">
                    <form class="form-signin" action="changepassword" method="POST">
                        <div class="account-logo text-center">
                            <a href="index_1.jsp"><img src="assets/img/logo-dark.png" alt=""></a>
                        </div>
                        <h3 class="text-center">Nhập mật khẩu mới</h3>

                        <!-- Hiển thị lỗi nếu có -->
                        <% if (request.getAttribute("err") != null) { %>
                            <div class="alert alert-danger text-center">
                                <%= request.getAttribute("err") %>
                            </div>
                        <% } %>

                        <div class="form-group">
                            <label for="newPassword">Mật khẩu mới</label>
                            <input type="password" name="newPassword" class="form-control" placeholder="Nhập mật khẩu mới" required/>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Xác nhận mật khẩu</label>
                            <input type="password" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu" required/>
                        </div>

                        <input type="hidden" name="email" value="${requestScope.emailr}"/>

                        <div class="form-group text-center">
                            <button class="btn btn-primary account-btn" type="submit">Xác nhận</button>
                        </div>

                        <div class="text-center register-link">
                            <a href="login.jsp">Quay lại đăng nhập</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="assets/js/jquery-3.2.1.min.js"></script>
    <script src="assets/js/popper.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
    <script src="assets/js/app.js"></script>
</body>
</html>