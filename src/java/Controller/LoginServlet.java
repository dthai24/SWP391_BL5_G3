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
            String sql = "SELECT Password FROM Users WHERE Username = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                String dbPassword = resultSet.getString("Password");
                if (password.equals(dbPassword)) {
                    // Đăng nhập thành công
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username); // Lưu username vào session
                    response.sendRedirect("homepage.jsp"); // Chuyển hướng đến trang chủ
                } else {
                    // Sai mật khẩu
                    request.setAttribute("error", "Mật khẩu không đúng");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                // Không tìm thấy tài khoản
                request.setAttribute("error", "Tài khoản không tồn tại");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đăng nhập thất bại do lỗi hệ thống");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}