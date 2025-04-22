package Controller;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Dal.UserDAO;
import Model.User;

@WebServlet(name = "UserServlet", urlPatterns = {"/user"})
public class UserServlet extends HttpServlet {
    private UserDAO userDAO;

    // Initialize DAO
    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    // Handle GET requests
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdParam = request.getParameter("edit");
        User editUser = null;

        // Fetch user details for editing, if an ID is provided
        if (userIdParam != null) {
            try {
                int userId = Integer.parseInt(userIdParam);
                editUser = userDAO.getUserById(userId);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID người dùng không hợp lệ.");
            }
        }

        // Filter users by role and status
        String filterRole = request.getParameter("filterRole");
        String filterStatus = request.getParameter("filterStatus");
        List<User> users = userDAO.listAllUsers();

        if (filterRole != null && !filterRole.isEmpty()) {
            users.removeIf(u -> !filterRole.equals(u.getRole()));
        }

        if (filterStatus != null && !filterStatus.isEmpty()) {
            users.removeIf(u -> !filterStatus.equals(u.getStatus()));
        }

        // Set attributes and forward to JSP
        request.setAttribute("users", users);
        request.setAttribute("editUser", editUser);
        request.getRequestDispatcher("View/User/list.jsp").forward(request, response);
    }

    // Handle POST requests for add, edit, and delete actions
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String deleteUserIdParam = request.getParameter("deleteUserID");

        // Handle delete action
        if (deleteUserIdParam != null && !deleteUserIdParam.isEmpty()) {
            handleDeleteUser(request, response, deleteUserIdParam);
            return;
        }

        // Add or Edit user
        if ("add".equals(action)) {
            handleAddUser(request, response);
        } else if ("edit".equals(action)) {
            handleEditUser(request, response);
        } else {
            response.sendRedirect("user");
        }
    }

    // Handle Add User
    private void handleAddUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = extractUserFromRequest(request);
        Map<String, String> errors = validateUserInputs(user, false, null);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            doGet(request, response);
            return;
        }

        boolean success = userDAO.addUser(user);
        if (success) {
            request.setAttribute("successMessage", "Thêm người dùng thành công!");
        } else {
            request.setAttribute("errorMessage", "Không thể thêm người dùng.");
        }
        doGet(request, response);
    }

    // Handle Edit User
    private void handleEditUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdParam = request.getParameter("userID");
        if (userIdParam == null || userIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "ID người dùng không hợp lệ.");
            doGet(request, response);
            return;
        }

        try {
            int userID = Integer.parseInt(userIdParam);
            User user = userDAO.getUserById(userID);

            if (user == null) {
                request.setAttribute("errorMessage", "Không tìm thấy người dùng.");
                doGet(request, response);
                return;
            }

            // Update user with new data from request
            updateUserFromRequest(request, user);
            Map<String, String> errors = validateUserInputs(user, true, userID);

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                doGet(request, response);
                return;
            }

            boolean success = userDAO.editUser(user);
            if (success) {
                request.setAttribute("successMessage", "Chỉnh sửa người dùng thành công!");
            } else {
                request.setAttribute("errorMessage", "Không thể chỉnh sửa người dùng.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID người dùng không hợp lệ.");
        }
        doGet(request, response);
    }

    // Handle Delete User
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response, String deleteUserIdParam)
            throws IOException {
        try {
            int deleteUserId = Integer.parseInt(deleteUserIdParam);
            boolean success = userDAO.deleteUser(deleteUserId);

            if (success) {
                request.setAttribute("successMessage", "Xóa người dùng thành công!");
            } else {
                request.setAttribute("errorMessage", "Không thể xóa người dùng.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID người dùng không hợp lệ.");
        }
        response.sendRedirect("user");
    }

    // Extract user data from request
    private User extractUserFromRequest(HttpServletRequest request) {
        User user = new User();
        user.setUsername(request.getParameter("username"));
        user.setPassword(request.getParameter("password"));
        user.setFullName(request.getParameter("fullName"));
        user.setEmail(request.getParameter("email"));
        user.setPhoneNumber(request.getParameter("phoneNumber"));
        user.setAddress(request.getParameter("address"));
        user.setRole(request.getParameter("role"));
        user.setStatus(request.getParameter("status"));
        user.setProfilePictureURL(request.getParameter("profilePictureURL"));
        user.setRegistrationDate(new Date());
        user.setIsDeleted(false);
        return user;
    }

    // Update user with new data from request
    private void updateUserFromRequest(HttpServletRequest request, User user) {
    user.setUsername(request.getParameter("username"));
    String password = request.getParameter("password");
    if (password != null && !password.trim().isEmpty()) {
        user.setPassword(password);
    }
    user.setFullName(request.getParameter("fullName"));
    user.setEmail(request.getParameter("email"));
    user.setPhoneNumber(request.getParameter("phoneNumber"));
    user.setAddress(request.getParameter("address"));
    user.setRole(request.getParameter("role"));
    user.setStatus(request.getParameter("status"));
    user.setProfilePictureURL(request.getParameter("profilePictureURL"));
    
    user.setRegistrationDate(user.getRegistrationDate());
}

    // Validate user inputs
    private Map<String, String> validateUserInputs(User user, boolean isUpdate, Integer userIdParam) {
        Map<String, String> errors = new HashMap<>();

        if (user.getUsername() == null || user.getUsername().trim().isEmpty() || user.getUsername().length() < 3) {
            errors.put("username", "Tên người dùng phải có ít nhất 3 ký tự và không được để trống.");
        } else if (!isUpdate || (isUpdate && userIdParam != null && !userDAO.getUserById(userIdParam).getUsername().equals(user.getUsername()))) {
            if (userDAO.isUsernameTaken(user.getUsername())) {
                errors.put("username", "Tên người dùng đã tồn tại. Vui lòng chọn tên khác.");
            }
        }

        if (!isUpdate && (user.getPassword() == null || user.getPassword().trim().isEmpty() || user.getPassword().length() < 6 || !Pattern.compile("\\d").matcher(user.getPassword()).find())) {
            errors.put("password", "Mật khẩu phải có ít nhất 6 ký tự và chứa ít nhất 1 chữ số.");
        }

        if (user.getFullName() == null || user.getFullName().trim().isEmpty() || user.getFullName().length() < 3) {
            errors.put("fullName", "Họ tên phải có ít nhất 3 ký tự và không được để trống.");
        }

        if (user.getEmail() == null || user.getEmail().trim().isEmpty() || !Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$").matcher(user.getEmail()).matches()) {
            errors.put("email", "Email không hợp lệ hoặc để trống.");
        } else if (!isUpdate || (isUpdate && userIdParam != null && !userDAO.getUserById(userIdParam).getEmail().equals(user.getEmail()))) {
            if (userDAO.isEmailTaken(user.getEmail())) {
                errors.put("email", "Email đã tồn tại. Vui lòng nhập email khác.");
            }
        }

        if (user.getPhoneNumber() != null) {
            if (user.getPhoneNumber().trim().isEmpty()) {
                errors.put("phoneNumber", "Số điện thoại không được để trống hoặc chỉ chứa khoảng trắng.");
            } else if (!Pattern.compile("^[0-9]{10,11}$").matcher(user.getPhoneNumber()).matches()) {
                errors.put("phoneNumber", "Số điện thoại phải chứa 10 hoặc 11 chữ số.");
            } else if (!isUpdate || (isUpdate && userIdParam != null && !userDAO.getUserById(userIdParam).getPhoneNumber().equals(user.getPhoneNumber()))) {
                if (userDAO.isPhoneNumberTaken(user.getPhoneNumber())) {
                    errors.put("phoneNumber", "Số điện thoại đã tồn tại. Vui lòng nhập số điện thoại khác.");
                }
            }
        }

        if (user.getAddress() != null && user.getAddress().trim().isEmpty()) {
            errors.put("address", "Địa chỉ không được để trống hoặc chỉ chứa khoảng trắng.");
        }

        if (!"Active".equals(user.getStatus()) && !"Inactive".equals(user.getStatus())) {
            errors.put("status", "Trạng thái phải là 'Active' hoặc 'Inactive'.");
        }

        if (!List.of("Admin", "Customer", "Manager", "Staff", "Receptionist").contains(user.getRole())) {
            errors.put("role", "Vai trò không hợp lệ.");
        }

        return errors;
    }
}