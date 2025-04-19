package Controller;

import Dal.UserDAO;
import Model.User;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

/**
 * UserServlet - Handles user-related operations like listing, adding, editing, deleting, and viewing details of users.
 */
@WebServlet(name = "UserServlet", urlPatterns = {"/user"})
@MultipartConfig // For handling file uploads (e.g., profile picture)
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
        } else if ("edit".equals(action)) {
            editUser(request, response);
        } else if ("delete".equals(action)) {
            deleteUser(request, response);
        } else if ("detail".equals(action)) {
            getUserDetail(request, response);
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
        List<User> users = userDAO.listAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("View/User/list.jsp").forward(request, response);
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            String status = request.getParameter("status");
            String imageUrl = request.getParameter("imageUrl");

            String profilePictureURL = null;
            Part filePart = request.getPart("profilePicture");

            // Check if user uploaded a file or provided a URL
            if (filePart != null && filePart.getSize() > 0) {
                profilePictureURL = handleFileUpload(filePart);
            } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                profilePictureURL = imageUrl; // Use the provided URL
            }

            User user = new User();
            user.setUsername(username);
            user.setPasswordHash(password);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setRole(role);
            user.setStatus(status);
            user.setProfilePictureURL(profilePictureURL);
            user.setRegistrationDate(new Date());

            boolean isAdded = userDAO.addUser(user);
            if (isAdded) {
                request.setAttribute("success", "Người dùng đã được thêm thành công.");
            } else {
                request.setAttribute("error", "Thêm người dùng thất bại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi thêm người dùng.");
        }
        listUsers(request, response);
    }

    private void editUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userID = Integer.parseInt(request.getParameter("userID"));
            String username = request.getParameter("username");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            String status = request.getParameter("status");
            String imageUrl = request.getParameter("imageUrl");

            String profilePictureURL = null;
            Part filePart = request.getPart("profilePicture");

            // Check if user uploaded a file or provided a URL
            if (filePart != null && filePart.getSize() > 0) {
                profilePictureURL = handleFileUpload(filePart);
            } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                profilePictureURL = imageUrl; // Use the provided URL
            }

            User user = userDAO.getUserById(userID);
            if (user != null) {
                user.setUsername(username);
                user.setFullName(fullName);
                user.setEmail(email);
                user.setRole(role);
                user.setStatus(status);
                if (profilePictureURL != null) {
                    user.setProfilePictureURL(profilePictureURL);
                }

                boolean isUpdated = userDAO.editUser(user);
                if (isUpdated) {
                    request.setAttribute("success", "Người dùng đã được cập nhật thành công.");
                } else {
                    request.setAttribute("error", "Cập nhật người dùng thất bại.");
                }
            } else {
                request.setAttribute("error", "Người dùng không tồn tại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật người dùng.");
        }
        listUsers(request, response);
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userID = Integer.parseInt(request.getParameter("userID"));
            boolean isDeleted = userDAO.deleteUser(userID);
            if (isDeleted) {
                request.setAttribute("success", "Người dùng đã được xóa thành công.");
            } else {
                request.setAttribute("error", "Xóa người dùng thất bại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi xóa người dùng.");
        }
        listUsers(request, response);
    }

    private void getUserDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userID = Integer.parseInt(request.getParameter("userID"));
        User user = userDAO.getUserById(userID);
        if (user != null) {
            request.setAttribute("userDetail", user);
        } else {
            request.setAttribute("error", "Người dùng không tồn tại.");
        }
        request.getRequestDispatcher("View/User/detail.jsp").forward(request, response);
    }

    private String handleFileUpload(Part filePart) throws IOException {
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + "uploads/" + fileName;
            filePart.write(uploadPath);
            return "uploads/" + fileName;
        }
        return null;
    }

    @Override
    public String getServletInfo() {
        return "Handles user CRUD operations.";
    }
}