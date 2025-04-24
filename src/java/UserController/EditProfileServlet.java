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
import java.io.File;


 
@WebServlet(name="EditProfileServlet", urlPatterns={"/editProfile"})
public class EditProfileServlet extends HttpServlet {
     private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO(); // Khởi tạo đối tượng UserDAO để thao tác với cơ sở dữ liệu
    }

   @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    HttpSession session = request.getSession();
    User user = (User) session.getAttribute("user");

    if (user != null) {
        // Fetch the full user object from the database using email or userID
        UserDAO userDAO = new UserDAO();
        User fullUser = userDAO.getUserByEmail(user.getEmail()); // Or use getUserById if userID is available

        if (fullUser != null) {
            // Update the fields with the form data
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String address = request.getParameter("address");

            fullUser.setFullName(fullName);
            fullUser.setEmail(email);
            fullUser.setPhoneNumber(phoneNumber);
            fullUser.setAddress(address);

            // Update the user in the database
            boolean isUpdated = userDAO.updateCustomerbyId(fullUser);

            if (isUpdated) {
                // Update the session with the updated user
                session.setAttribute("user", fullUser);
                request.getRequestDispatcher("myprofile.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Cập nhật thông tin thất bại.");
                request.getRequestDispatcher("editProfile.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    } else {
        response.sendRedirect("login.jsp");
    }
}
}