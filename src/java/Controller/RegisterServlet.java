package Controller;

import DBContext.DBContext;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password"); // Sử dụng mật khẩu thường
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String role = "Customer"; // Vai trò mặc định

        try (Connection conn = new DBContext().getConnection()) {
            String sql = "INSERT INTO Users (Username, Password, FullName, Email, Role, Status, IsDeleted) VALUES (?, ?, ?, ?, ?, 'Active', 0)";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, password); // Lưu mật khẩu thường
            statement.setString(3, fullName);
            statement.setString(4, email);
            statement.setString(5, role);
            statement.executeUpdate();
            response.sendRedirect("login.jsp"); // Chuyển hướng đến trang đăng nhập
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=Đăng ký thất bại");
        }
    }
}