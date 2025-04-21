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

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPhoneNumber(phone);
        newUser.setAddress(address);
        newUser.setRole("Customer");
        newUser.setProfilePictureURL(null);
        newUser.setStatus("Active");
        newUser.setRegistrationDate(new java.util.Date());
        newUser.setIsDeleted(false);

        UserDAO dao = new UserDAO();
        if (dao.checkExist(username, email)) {
            request.setAttribute("error", "Username hoặc email đã tồn tại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (dao.register(newUser)) {
            response.sendRedirect("login.jsp");
        } else {
            request.setAttribute("error", "Đăng ký thất bại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}