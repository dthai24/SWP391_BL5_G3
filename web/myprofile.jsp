<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="description" content="Sona Template">
    <meta name="keywords" content="Sona, unica, creative, html">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>ROSE MOTEL</title>

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">

    <!-- Css Styles -->
    <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="css/font-awesome.min.css" type="text/css">
    <link rel="stylesheet" href="css/elegant-icons.css" type="text/css">
    <link rel="stylesheet" href="css/flaticon.css" type="text/css">
    <link rel="stylesheet" href="css/owl.carousel.min.css" type="text/css">
    <link rel="stylesheet" href="css/nice-select.css" type="text/css">
    <link rel="stylesheet" href="css/jquery-ui.min.css" type="text/css">
    <link rel="stylesheet" href="css/magnific-popup.css" type="text/css">
    <link rel="stylesheet" href="css/slicknav.min.css" type="text/css">
    <link rel="stylesheet" href="css/myprofile.css" type="text/css"> <!-- Thêm CSS riêng -->

</head>

<body>
    <div class="container">
        <div class="menu">
            <button onclick="showProfile()">My Profile</button>
            <button onclick="showBookingHistory()">Booking History</button>
        </div>
        <div class="content">
            <div class="profile-info active">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKI5TAOsqD7FtzJjsuO-eH0OxinunQMrWjug&s" alt="Avatar" class="avatar"> <!-- Ảnh đại diện từ mạng -->
                <div class="info">
                    <label>Họ tên:</label>
                    <input type="text" value="Nguyễn Văn A" />
                </div>
                <div class="info">
                    <label>Email:</label>
                    <input type="text" value="johndoe@example.com" />
                </div>
                <div class="info">
                    <label>Số điện thoại:</label>
                    <input type="text" value="0123456789" />
                </div>
                <button class="edit-button" onclick="toggleEdit()">Edit</button>
            </div>
            <div class="booking-history">
                <table>
                    <tr>
                        <th>Mã Đặt Phòng</th>
                        <th>Ngày Đặt</th>
                        <th>Trạng Thái</th>
                        <th class="action-header" style="display: none;">Hành Động</th> <!-- Cột Hành Động ẩn -->
                    </tr>
                    <tr>
                        <td>12345</td>
                        <td>01/01/2023</td>
                        <td>Đã Xác Nhận</td>
                        <td class="action-cell" style="display: none;"><button class="cancel-button">Hủy</button></td> <!-- Nút Hủy ẩn -->
                    </tr>
                    <tr>
                        <td>67890</td>
                        <td>02/01/2023</td>
                        <td>Đang Chờ</td>
                        <td class="action-cell" style="display: none;"><button class="cancel-button">Hủy</button></td> <!-- Nút Hủy ẩn -->
                    </tr>
                    <!-- Thêm các hàng khác nếu cần -->
                </table>
                <button class="edit-button" onclick="toggleBookingEdit()">Edit</button> <!-- Nút Edit cho Booking History -->
            </div>
        </div>
    </div>

    <script src="js/jquery-3.3.1 .min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/myprofile.js"></script>
</body>

</html>