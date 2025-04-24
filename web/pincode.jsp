    
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nhập Mã PIN</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                background-color: #f9f9f9;
            }
            .container {
                text-align: center;
                border: 1px solid #ccc;
                border-radius: 8px;
                padding: 20px;
                background-color: white;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                width: 300px; /* Độ rộng của khung */
            }
            .input-group {
                display: flex;
                justify-content: center;
                margin: 10px 10px;
            }
            .input-group input {
                width: 40px;
                height: 40px;
                text-align: center;
                font-size: 18px;
                margin: 0 5px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            input:focus {
                border-color: #66afe9;
                outline: none;
            }
            button {
            margin-top: 20px; /* Tạo khoảng cách với nút xác nhận */
            padding: 10px 20px; /* Thêm khoảng cách bên trong nút */
            border: none;
            border-radius: 4px;
            background-color: #007bff;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }
            button:hover {
            background-color: #0056b3; /* Thay đổi màu khi hover */
        }
        h5 {
            margin-top: 10px; /* Tạo khoảng cách cho thông báo lỗi */
            color: red;
        }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Enter Verification Code</h2>
            <h4>Your verification code is sent via to email</h4>
            <h4>${requestScope.emailr}</h4>
            <form action="check-pin" method="POST">
                <div class="input-group">
                    <input type="text" name="pin1" maxlength="1" oninput="moveFocus(this)">
                    <input type="text" name="pin2" maxlength="1" oninput="moveFocus(this)">
                    <input type="text" name="pin3" maxlength="1" oninput="moveFocus(this)">
                    <input type="text" name="pin4" maxlength="1" oninput="moveFocus(this)">
                    <input type="text" name="pin5" maxlength="1" oninput="moveFocus(this)">
                    <input type="text" name="pin6" maxlength="1" oninput="moveFocus(this)">
                </div>
                <input hidden type="text" name="codeInput" id="pinDisplay" />
                <input hidden type="text" name="emailr" value="${requestScope.emailr}"/>
                <input hidden type="text" name="code"  value="${requestScope.code}"/>
                <h5 style="color: red">${requestScope.err}</h5>
                <button type="submit">Xác nhận</button>
            </form>
        </div>

        <script>
            let pin = '';
            function moveFocus(input) {
                input.value = input.value.replace(/[^0-9]/g, '');
                updatePin();
                if (input.value.length >= input.maxLength) {
                    const nextInput = input.nextElementSibling;
                    if (nextInput) {
                        nextInput.focus();
                    }
                } else if (input.value.length === 0) {
                    const previousInput = input.previousElementSibling;
                    if (previousInput) {
                        previousInput.focus();
                    }
                }
            }

            document.querySelectorAll('.input-group input').forEach(input => {
                input.addEventListener('keydown', function (event) {
                    if (event.key >= '0' && event.key <= '9') {
                        if (this.value.length > 0) {
                            this.value = event.key;
                        }
                    }
                });
            });
            function updatePin() {
                pin = ''; // Reset biến pin
                document.querySelectorAll('.input-group input').forEach(input => {
                    pin += input.value; // Gộp giá trị của các ô input
                });
                document.getElementById('pinDisplay').textContent = `Mã PIN: ${pin}`; // Hiển thị mã PIN
            }

            document.querySelectorAll('.input-group input').forEach(input => {
                input.addEventListener('keydown', function (event) {
                    if (event.key >= '0' && event.key <= '9') {
                        if (this.value.length > 0) {
                            this.value = event.key; // Thay thế giá trị hiện tại bằng số mới
                        }
                        updatePin(); // Cập nhật mã PIN
                    }
                });
            });
        </script>
    </body>
</html>