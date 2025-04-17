package Controller;

import DBContext.DBContext;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = new DBContext().getConnection()) {
            String sql = "SELECT * FROM Users WHERE Username = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();

            // Kiểm tra xem người dùng có tồn tại và so sánh mật khẩu
            if (resultSet.next() && password.equals(resultSet.getString("Password"))) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", resultSet.getString("Role"));
                response.sendRedirect("homepage.jsp"); // Chuyển hướng đến trang homepage
            } else {
                response.sendRedirect("login.jsp?error=Tài khoản hoặc mật khẩu không đúng");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Đăng nhập thất bại");
        }
    }
}