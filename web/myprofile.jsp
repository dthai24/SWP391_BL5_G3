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

    <div class="profile-container">
        <div class="center">
            <!-- Avatar (n?u có) -->
            <%-- <img src="<c:out value="${user.profilePictureURL}"/>" alt="User Avatar" class="avatar"> --%>
            <h2>Thông tin cá nhân</h2>
        </div>
        <div class="profile-info">
            <p><strong>Name:</strong> ${user.fullName}</p>
            <p><strong>Email:</strong> ${user.email}</p>
            <p><strong>Phone Number:</strong> ${user.phoneNumber}</p>
            <p><strong>Address:</strong> ${user.address}</p>

            <a href="editProfile.jsp" class="button button-edit">Change Information</a>
            <a href="changePassword.jsp" class="button button-change-password">Change password</a>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
