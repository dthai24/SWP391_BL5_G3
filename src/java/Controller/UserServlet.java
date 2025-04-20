package Controller;

import Dal.UserDAO;
import Model.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * UserServlet - Handles user-related operations like listing, adding, editing,
 * deleting, and viewing details of users.
 */
@WebServlet(name = "UserServlet", urlPatterns = {"/user"})
public class UserServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO(); // Initialize DAO for database operations
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            listUsers(request, response);
        } else if ("detail".equals(action)) {
            getUserDetail(request, response);
        } else if ("edit".equals(action)) {
            getUserEdit(request, response);
        } else if ("add".equals(action)) {
            getUserAdd(request, response);
        } else if ("delete".equals(action)) {
            deleteUser(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addUser(request, response);
        } else if ("edit".equals(action)) {
            editUser(request, response);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<User> users = userDAO.listAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("View/User/list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while listing users.");
            request.getRequestDispatcher("View/Error.jsp").forward(request, response);
        }
    }

    private void getUserAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.getRequestDispatcher("View/User/add.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while displaying the add user page.");
            listUsers(request, response);
        }
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy dữ liệu từ form
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String address = request.getParameter("address");
            String role = request.getParameter("role");
            String status = request.getParameter("status");

            // Validate dữ liệu
            List<String> errors = validateUserInputs(
                    username,
                    password,
                    fullName,
                    email,
                    phoneNumber,
                    address,
                    role,
                    status,
                    null,
                    true
            );

            if (!errors.isEmpty()) {
                // Nếu có lỗi, quay lại trang add.jsp với thông báo lỗi
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("View/User/add.jsp").forward(request, response);
                return;
            }

            // Băm mật khẩu trước khi lưu
            String hashedPassword = hashPassword(password);

            // Tạo đối tượng User
            User user = new User();
            user.setUsername(username);
            user.setPasswordHash(hashedPassword); // Lưu mật khẩu băm
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhoneNumber(phoneNumber);
            user.setAddress(address);
            user.setRole(role);
            user.setStatus(status);
            user.setRegistrationDate(new Date());

            // Thêm user vào cơ sở dữ liệu
            boolean isAdded = userDAO.addUser(user);

            if (isAdded) {
                // Nếu thêm thành công, chuyển hướng về danh sách với thông báo thành công
                response.sendRedirect(request.getContextPath() + "/user?action=list&success=User added successfully");
            } else {
                // Nếu thêm thất bại, quay lại trang add.jsp với thông báo lỗi
                request.setAttribute("error", "Failed to add user.");
                request.getRequestDispatcher("View/User/add.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Xử lý lỗi chung
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("View/User/add.jsp").forward(request, response);
        }
    }
// Hàm băm mật khẩu

// Hàm băm mật khẩu
    private String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes());
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }

    private void getUserEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String userIDParam = request.getParameter("userID");
            if (userIDParam == null || !userIDParam.matches("\\d+")) {
                request.setAttribute("error", "Invalid user ID.");
                listUsers(request, response);
                return;
            }

            int userID = Integer.parseInt(userIDParam);
            User user = userDAO.getUserById(userID);

            if (user != null) {
                request.setAttribute("userDetail", user);
                request.getRequestDispatcher("View/User/edit.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "User does not exist.");
                listUsers(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while retrieving user details.");
            listUsers(request, response);
        }
    }

    private void editUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String userIDParam = request.getParameter("userID");
            if (userIDParam == null || !userIDParam.matches("\\d+")) {
                request.setAttribute("error", "Invalid user ID.");
                listUsers(request, response);
                return;
            }

            int userID = Integer.parseInt(userIDParam);
            String username = request.getParameter("username");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String address = request.getParameter("address");
            String role = request.getParameter("role");
            String status = request.getParameter("status");
            String profilePictureURL = request.getParameter("profilePictureURL");

            List<String> errors = validateUserInputs(username, null, fullName, email, phoneNumber, address, role, status, profilePictureURL, false);

            if (!errors.isEmpty()) {
                User userWithErrors = new User();
                userWithErrors.setUserID(userID);
                userWithErrors.setUsername(username);
                userWithErrors.setFullName(fullName);
                userWithErrors.setEmail(email);
                userWithErrors.setPhoneNumber(phoneNumber);
                userWithErrors.setAddress(address);
                userWithErrors.setRole(role);
                userWithErrors.setStatus(status);
                userWithErrors.setProfilePictureURL(profilePictureURL);

                request.setAttribute("errors", errors);
                request.setAttribute("userDetail", userWithErrors);
                request.getRequestDispatcher("View/User/edit.jsp").forward(request, response);
                return;
            }

            User user = userDAO.getUserById(userID);
            if (user != null) {
                user.setUsername(username);
                user.setFullName(fullName);
                user.setEmail(email);
                user.setPhoneNumber(phoneNumber);
                user.setAddress(address);
                user.setRole(role);
                user.setStatus(status);
                user.setProfilePictureURL(profilePictureURL);

                boolean isUpdated = userDAO.editUser(user);
                if (isUpdated) {
                    response.sendRedirect(request.getContextPath() + "/user?action=list&success=User updated successfully");
                } else {
                    request.setAttribute("error", "Failed to update user.");
                    request.setAttribute("userDetail", user);
                    request.getRequestDispatcher("View/User/edit.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "User does not exist.");
                listUsers(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while updating the user.");
            listUsers(request, response);
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userID = Integer.parseInt(request.getParameter("userID"));
            boolean isDeleted = userDAO.deleteUser(userID);
            response.sendRedirect(request.getContextPath() + "/user?action=list&success="
                    + (isDeleted ? "User deleted successfully" : "Failed to delete user"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user?action=list&error=An error occurred while deleting the user");
        }
    }

    private void getUserDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userID = Integer.parseInt(request.getParameter("userID"));
            User user = userDAO.getUserById(userID);
            if (user != null) {
                request.setAttribute("userDetail", user);
                request.getRequestDispatcher("View/User/detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "User does not exist.");
                listUsers(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while fetching user details.");
            listUsers(request, response);
        }
    }

    private List<String> validateUserInputs(String username, String password, String fullName, String email, String phoneNumber, String address, String role, String status, String profilePictureURL, boolean isAdd) {
        List<String> errors = new ArrayList<>();

        if (username == null || username.trim().isEmpty() || username.length() < 3) {
            errors.add("Username must be at least 3 characters long and not empty.");
        }

        if (isAdd && (password == null || password.trim().isEmpty() || password.length() < 6 || !Pattern.compile("\\d").matcher(password).find())) {
            errors.add("Password must be at least 6 characters long, not empty, and contain at least one digit.");
        }

        if (fullName == null || fullName.trim().isEmpty() || fullName.length() < 3) {
            errors.add("Full name must be at least 3 characters long and not empty.");
        }

        if (email == null || email.trim().isEmpty() || !Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$").matcher(email).matches()) {
            errors.add("Invalid or empty email.");
        }

        if (phoneNumber != null && !phoneNumber.trim().isEmpty() && !Pattern.compile("^\\+?[0-9]{10,15}$").matcher(phoneNumber).matches()) {
            errors.add("Invalid phone number.");
        }

        if (address != null && address.trim().isEmpty()) {
            errors.add("Address must not be empty if provided.");
        }

        if (profilePictureURL != null && !profilePictureURL.trim().isEmpty() && profilePictureURL.length() > 20000000) {
            errors.add("Profile picture URL must be smaller than 20MB.");
        }

        if (!"Active".equals(status) && !"Inactive".equals(status)) {
            errors.add("Status must be 'Active' or 'Inactive'.");
        }

        if (!List.of("Admin", "Customer", "Manager", "Staff", "Receptionist").contains(role)) {
            errors.add("Role must be one of: Admin, Customer, Manager, Staff, Receptionist.");
        }

        return errors;
    }

    @Override
    public String getServletInfo() {
        return "Handles user CRUD operations.";
    }
}
