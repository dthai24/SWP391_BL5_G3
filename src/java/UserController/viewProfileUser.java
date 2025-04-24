/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package UserController;

import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet(name="viewProfileUser", urlPatterns={"/viewProfileUser"})
public class viewProfileUser extends HttpServlet {
   private UserProfileService userProfileService;
  

    @Override
    public void init() throws ServletException {
        userProfileService = new UserProfileService(); // Khởi tạo UserProfileService
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Giả sử người dùng đã đăng ký và đang lưu thông tin trong session
        User user = (User) request.getSession().getAttribute("user");  // Lấy thông tin người dùng từ session

        if (user != null) {
            // Lấy thông tin người dùng từ service
            User userInfo = userProfileService.getUserInfo(user.getUserID());
            request.setAttribute("user", userInfo);  // Đặt thông tin vào request để hiển thị trong JSP
            request.getRequestDispatcher("/myprofile.jsp").forward(request, response);  // Forward đến myprofile.jsp
        } else {
            response.sendRedirect("login.jsp");  // Nếu không có thông tin người dùng, chuyển đến trang login
        }
    }

}
