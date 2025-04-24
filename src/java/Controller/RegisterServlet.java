package Controller;

import DBContext.DBContext;
import Dal.UserDAO;
import Model.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Model.Email;
import jakarta.servlet.http.HttpSession;
import java.util.Date;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validate backend
        String error = null;
        if (!email.matches("^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            error = "Email không hợp lệ.";
        } else if (!phone.matches("\\d{9,11}")) {
            error = "Số điện thoại phải từ 10 đến 11 số.";
        } else if (address.length() < 5) {
            error = "Địa chỉ phải có ít nhất 5 ký tự.";
        } else if (!password.matches(".*[!@#$%^&*(),.?\":{}|<>].*")) {
            error = "Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt.";
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Nếu không có lỗi thì tiếp tục xử lý đăng ký
        UserDAO dao = new UserDAO();
        if (dao.checkExist(username, email)) {
            request.setAttribute("error", "Username hoặc email đã tồn tại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Khởi tạo đối tượng user
        User user = new User(0, username, password, email, phone, address, "status", "gender", "image", new Date(), true);

        // Đăng ký người dùng
        dao.register(user);

        // Gửi mã xác minh
        int otp = (int) (Math.random() * 900000) + 100000; // random 6 chữ số
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("email", email);

        String subject = "Xác minh tài khoản ROSE MOTEL";
        String content = "Xin chào " + fullName + ",<br><br>"
                + "Cảm ơn bạn đã đăng ký tài khoản tại ROSE MOTEL.<br>"
                + "Mã xác minh của bạn là: <b>" + otp + "</b><br><br>"
                + "Vui lòng nhập mã này vào hệ thống để hoàn tất xác minh.";

        Email mailSender = new Email();
        boolean sent = mailSender.sendMess(email, subject, content);

        if (sent) {
            response.sendRedirect("verify.jsp");
        } else {
            request.setAttribute("error", "Gửi email xác minh thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
