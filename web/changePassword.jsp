<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Profile</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f6f9;
            margin: 0;
            padding: 0;
        }

        .profile-container {
            max-width: 800px;
            margin: 50px auto;
            background: #fff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .profile-info h2 {
            margin-bottom: 30px;
            font-size: 28px;
            color: #333;
            border-bottom: 2px solid #007BFF;
            padding-bottom: 10px;
        }

        .profile-info p {
            font-size: 18px;
            margin: 10px 0;
            color: #555;
        }

        .profile-info p strong {
            color: #333;
        }

        .button {
            display: inline-block;
            padding: 12px 25px;
            margin: 15px 10px 0 0;
            text-decoration: none;
            color: #fff;
            border-radius: 8px;
            font-size: 16px;
            transition: background 0.3s ease;
        }

        .button-edit {
            background-color: #28a745;
        }

        .button-edit:hover {
            background-color: #218838;
        }

        .button-change-password {
            background-color: #007BFF;
        }

        .button-change-password:hover {
            background-color: #0056b3;
        }

        .avatar {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 20px;
        }

        .center {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

     <div class="container">
        <h2>Change Password</h2>

        <c:if test="${not empty errorMessage}">
            <p class="error-message">${errorMessage}</p>
        </c:if>

        <form action="changePassword" method="post">
            <label for="oldPassword">Current Password:</label>
            <input type="password" id="oldPassword" name="oldPassword" required>

            <label for="newPassword">New Password:</label>
            <input type="password" id="newPassword" name="newPassword" required>

            <button type="submit" class="button">Change Password</button>
        </form>

        <div class="footer">
            <p><a href="profile.jsp">Back to Profile</a></p>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>





