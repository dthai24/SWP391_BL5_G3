import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import Model.User; // Nhập khẩu lớp User
import Dal.UserDAO; // Nhập khẩu lớp UserDAO
import java.io.File;
import java.io.IOException;

@WebServlet("/updateProfile")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User ) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy thông tin từ form
        String fullName = request.getParameter("fullName");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        Part filePart = request.getPart("profileImage");

        // Cập nhật thông tin người dùng
        user.setFullName(fullName);
        user.setPhoneNumber(phoneNumber);
        user.setAddress(address);
        
        if (password != null && !password.isEmpty()) {
            // Mã hóa mật khẩu nếu cần
            user.setPasswordHash(password); // Giả sử bạn đã mã hóa mật khẩu
        }

        // Xử lý tải lên ảnh đại diện nếu có
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            // Lưu file vào thư mục mong muốn
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + fileName);
            // Cập nhật đường dẫn ảnh trong đối tượng user
            user.setProfilePictureURL("uploads/" + fileName);
        }

        // Cập nhật thông tin người dùng vào cơ sở dữ liệu
        UserDAO userDAO = new UserDAO();
        boolean isUpdated = userDAO.editUser (user);
        
        if (isUpdated) {
            request.setAttribute("message", "Cập nhật thông tin thành công!");
        } else {
            request.setAttribute("message", "Cập nhật thông tin thất bại!");
        }

        request.getRequestDispatcher("myprofile.jsp").forward(request, response);
    }
}