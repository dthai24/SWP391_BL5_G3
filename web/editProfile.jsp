
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ch?nh s?a thông tin cá nhân</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7fa;
            color: #333;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            margin-top: 30px;
            font-size: 28px;
            color: #333;
        }

        .form-container {
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
            padding: 30px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .form-section {
            margin-bottom: 20px;
        }

        .form-section label {
            font-weight: 600;
            font-size: 16px;
            color: #555;
            display: block;
            margin-bottom: 8px;
        }

        .form-section input {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fafafa;
            margin-bottom: 10px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .form-section input:focus {
            border-color: #5e72e4;
            box-shadow: 0 0 5px rgba(94, 114, 228, 0.4);
        }

        .button {
            display: inline-block;
            padding: 12px 24px;
            background-color: #28a745;
            color: white;
            border-radius: 5px;
            text-align: center;
            font-size: 16px;
            width: 100%;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        .button-edit:hover {
            background-color: #218838;
        }

        .error-message {
            color: red;
            font-size: 14px;
            text-align: center;
            margin-bottom: 20px;
        }

        .form-section input:disabled {
            background-color: #f0f0f0;
        }
    </style>
</head>
<body>

    <!-- Header -->
    <%@ include file="header.jsp" %>

    <h2>Ch?nh s?a thông tin cá nhân</h2>

    <!-- Hi?n th? thông báo l?i n?u có -->
    <c:if test="${not empty errorMessage}">
        <p class="error-message">${errorMessage}</p>
    </c:if>

    <!-- Form ch?nh s?a thông tin cá nhân -->
    <div class="form-container">
        <form action="editProfile" method="post">
            <div class="form-section">
                <label for="fullName">Full Name:</label>
                <input type="text" id="fullName" name="fullName" value="${user.fullName}" required><br>

                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="${user.email}" required><br>

                <label for="phoneNumber">Phone:</label>
                <input type="text" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}" required><br>

                <label for="address">Address:</label>
                <input type="text" id="address" name="address" value="${user.address}" required><br>

                <button type="submit" class="button button-edit">Update</button>
            </div>
        </form>
    </div>

    <!-- Footer -->
    <%@ include file="footer.jsp" %>

</body>
</html>
