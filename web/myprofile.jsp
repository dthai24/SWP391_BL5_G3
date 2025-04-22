<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .profile-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            margin: 10px 0 5px;
            font-weight: bold;
            color: #555;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="file"] {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-bottom: 15px;
            font-size: 16px;
        }

        button {
            padding: 10px;
            background-color: #5cb85c;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #4cae4c;
        }

        .message {
            text-align: center;
            margin-top: 20px;
        }

        .message p {
            color: green;
        }

        a {
            text-align: center;
            display: block;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <h2>Thông tin cá nhân</h2>

        <%
            User user = (User  ) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <form action="updateProfile" method="post" enctype="multipart/form-data">
            <div>
                <label for="fullName">Họ và tên:</label>
                <input type="text" id="fullName" name="fullName" value="<%= user.getFullName() %>" required>
            </div>

            <div>
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required readonly>
            </div>

            <div>
                <label for="password">Mật khẩu mới:</label>
                <input type="password" id="password" name="password" placeholder="Nhập mật khẩu mới (nếu muốn thay đổi)">
            </div>

            <div>
                <label for="profileImage">Ảnh đại diện:</label>
                <input type="file" id="profileImage" name="profileImage" accept="image/*">
            </div>

            <button type="submit">Cập nhật thông tin</button>
        </form>

        <div class="message">
            <%
                String message = (String) request.getAttribute("message");
                if (message != null) {
                    out.println("<p>" + message + "</p>");
                }
            %>
        </div>

        <a href="homepage.jsp">Trở về trang chủ</a>
    </div>
</body>
</html>