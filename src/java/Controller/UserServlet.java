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
import java.util.HashMap;
import java.util.Map;

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
            // Nhận các tham số từ request
            String keyword = request.getParameter("searchKeyword");
            String role = request.getParameter("filterRole");
            String sortBy = request.getParameter("sortField");
            String sortDirection = request.getParameter("sortDir");
            String pageParam = request.getParameter("page");
            int page = (pageParam != null && pageParam.matches("\\d+")) ? Integer.parseInt(pageParam) : 1;
            int pageSize = 5; // Số lượng người dùng mỗi trang

            // Đếm tổng số người dùng
            int totalUsers = userDAO.countUsers(keyword, role);

            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

            // Kiểm tra nếu không có người dùng nào
            if (totalUsers == 0) {
                request.setAttribute("users", null); // Không có người dùng
                request.setAttribute("currentPage", 1);
                request.setAttribute("totalPages", 0);
                request.setAttribute("searchKeyword", keyword);
                request.setAttribute("filterRole", role);
                request.setAttribute("sortField", sortBy);
                request.setAttribute("sortDir", sortDirection);
                request.setAttribute("error", "Không tìm thấy người dùng nào với điều kiện lọc hiện tại.");
                request.getRequestDispatcher("View/User/list.jsp").forward(request, response);
                return;
            }

            // Lấy danh sách người dùng
            List<User> users = userDAO.searchAndListUsers(keyword, role, sortBy, sortDirection, page, pageSize);
            if (users == null) {
                throw new Exception("Danh sách người dùng trả về null.");
            }

            // Gửi dữ liệu đến JSP
            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("filterRole", role);
            request.setAttribute("sortField", sortBy);
            request.setAttribute("sortDir", sortDirection);

            // Forward đến list.jsp
            request.getRequestDispatcher("View/User/list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi xảy ra trong quá trình xử lý danh sách người dùng: " + e.getMessage());
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
            String profilePictureURL = request.getParameter("profilePictureURL");

            // Validate dữ liệu
            Map<String, String> errors = validateUserInputs(
                    username, password, fullName, email, phoneNumber, address, role, status, profilePictureURL,
                    true, null, null
            );

            if (!errors.isEmpty()) {
                // Nếu có lỗi, quay lại trang add.jsp với thông báo lỗi
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("View/User/add.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng User
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhoneNumber(phoneNumber);
            user.setAddress(address);
            user.setRole(role);
            user.setStatus(status);
            user.setProfilePictureURL(profilePictureURL); // Thiết lập URL ảnh đại diện
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

            // Lấy thông tin người dùng gốc từ cơ sở dữ liệu
            User originalUser = userDAO.getUserById(userID);
            if (originalUser == null) {
                request.setAttribute("error", "User does not exist.");
                listUsers(request, response);
                return;
            }

            // Validate dữ liệu
            Map<String, String> errors = validateUserInputs(
                    username, null, fullName, email, phoneNumber, address, role, status, profilePictureURL,
                    false, originalUser.getUsername(), originalUser.getEmail()
            );

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

            // Cập nhật thông tin người dùng
            originalUser.setUsername(username);
            originalUser.setFullName(fullName);
            originalUser.setEmail(email);
            originalUser.setPhoneNumber(phoneNumber);
            originalUser.setAddress(address);
            originalUser.setRole(role);
            originalUser.setStatus(status);
            originalUser.setProfilePictureURL(profilePictureURL);

            boolean isUpdated = userDAO.editUser(originalUser);
            if (isUpdated) {
                response.sendRedirect(request.getContextPath() + "/user?action=list&success=User updated successfully");
            } else {
                request.setAttribute("error", "Failed to update user.");
                request.setAttribute("userDetail", originalUser);
                request.getRequestDispatcher("View/User/edit.jsp").forward(request, response);
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

    private Map<String, String> validateUserInputs(String username, String password, String fullName,
            String email, String phoneNumber, String address,
            String role, String status, String profilePictureURL,
            boolean isAdd, String originalUsername, String originalEmail) {
        Map<String, String> errors = new HashMap<>();

        if (username == null || username.trim().isEmpty() || username.length() < 3) {
            errors.put("username", "Tên người dùng phải có ít nhất 3 ký tự và không được để trống.");
        } else if (!username.equals(originalUsername) && userDAO.isUsernameTaken(username)) {
            errors.put("username", "Tên người dùng đã tồn tại. Vui lòng chọn tên khác.");
        }

        if (isAdd && (password == null || password.trim().isEmpty() || password.length() < 6 || !Pattern.compile("\\d").matcher(password).find())) {
            errors.put("password", "Mật khẩu phải có ít nhất 6 ký tự và chứa ít nhất 1 chữ số.");
        }

        if (fullName == null || fullName.trim().isEmpty() || fullName.length() < 3) {
            errors.put("fullName", "Họ tên phải có ít nhất 3 ký tự và không được để trống.");
        }

        if (email == null || email.trim().isEmpty() || !Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$").matcher(email).matches()) {
            errors.put("email", "Email không hợp lệ hoặc để trống.");
        } else if (!email.equals(originalEmail) && userDAO.isEmailTaken(email)) {
            // Chỉ kiểm tra trùng lặp nếu email đã thay đổi
            errors.put("email", "Email đã tồn tại. Vui lòng nhập email khác.");
        }

        if (phoneNumber != null) {
            if (phoneNumber.trim().isEmpty()) {
                errors.put("phoneNumber", "Số điện thoại không được để trống hoặc chỉ chứa khoảng trắng.");
            } else if (!Pattern.compile("^[0-9]{10,11}$").matcher(phoneNumber).matches()) {
                errors.put("phoneNumber", "Số điện thoại phải chứa 10 hoặc 11 chữ số.");
            } else if (!phoneNumber.equals(originalEmail) && userDAO.isPhoneNumberTaken(email)) {
                errors.put("phoneNumber", "Số điện thoại đã tồn tại. Vui lòng nhập số điện thoại khác.");
            }
        }

        if (address != null) {
            if (address.trim().isEmpty()) {
                errors.put("address", "Địa chỉ không được để trống hoặc chỉ chứa khoảng trắng.");
            }
        }

        if (!"Active".equals(status) && !"Inactive".equals(status)) {
            errors.put("status", "Trạng thái phải là 'Active' hoặc 'Inactive'.");
        }

        if (!List.of("Admin", "Customer", "Manager", "Staff", "Receptionist").contains(role)) {
            errors.put("role", "Vai trò không hợp lệ.");
        }

        if (profilePictureURL != null && !profilePictureURL.trim().isEmpty() && profilePictureURL.length() > 20000000) {
            errors.put("profilePictureURL", "URL ảnh đại diện phải nhỏ hơn 20MB.");
        }

        return errors;
    }

    @Override
    public String getServletInfo() {
        return "Handles user CRUD operations.";
    }
}
