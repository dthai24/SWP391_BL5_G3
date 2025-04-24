/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package UserController;

import Dal.UserDAO;
import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet(name="ChangePasswordServlet", urlPatterns={"/changePassword"})
public class ChangePasswordServlet extends HttpServlet {
   
   private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO(); // Khởi tạo đối tượng UserDAO để thao tác với cơ sở dữ liệu
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy thông tin người dùng từ session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            // Nhận mật khẩu cũ và mật khẩu mới từ form
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");

            // Kiểm tra mật khẩu cũ
            if (oldPassword != null && !oldPassword.isEmpty() && user.getPasswordHash().equals(oldPassword)) {
                // Cập nhật mật khẩu mới vào cơ sở dữ liệu
                user.setPasswordHash(newPassword);
                boolean isUpdated = userDAO.updateUser(user);

                if (isUpdated) {
                    session.setAttribute("user", user); // Cập nhật thông tin người dùng trong session
                    response.sendRedirect("myprofile.jsp"); // Quay lại trang profile sau khi cập nhật mật khẩu thành công
                } else {
                    request.setAttribute("errorMessage", "Cập nhật mật khẩu thất bại.");
                    request.getRequestDispatcher("changePassword.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Mật khẩu cũ không đúng.");
                request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("/login.jsp");
        }
    }
}