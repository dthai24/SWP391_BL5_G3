package Controller;

import DBContext.DBContext;
import Dal.UserDAO;
import Model.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(username, password);

        if (user != null) {
            if ("Active".equals(user.getStatus()) && !user.getIsDeleted()) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                // Kiểm tra nhân viên
                boolean isEmployee = false;
                try {
                    Connection conn = new DBContext().getConnection();
                    PreparedStatement ps = conn.prepareStatement("SELECT 1 FROM Employees WHERE EmployeeID = ?");
                    ps.setInt(1, user.getUserID());
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) isEmployee = true;
                    rs.close(); ps.close(); conn.close();
                } catch(Exception ex) { isEmployee = false; }
                session.setAttribute("isEmployee", isEmployee);
                response.sendRedirect("homepage.jsp");
            } else {
                request.setAttribute("error", "Tài khoản bị khóa hoặc đã bị xóa.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}