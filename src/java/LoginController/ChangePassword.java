/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package LoginController;

import util.ValidFunction;
import Dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import Model.User;


public class ChangePassword extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ChangePassword</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangePassword at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");
    String email = request.getParameter("email");
    ValidFunction valid = new ValidFunction();

    try {
        if (newPassword.equals(confirmPassword)) {
            // Cập nhật mật khẩu mới cho người dùng trong cơ sở dữ liệu
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserByEmail(email);

            if (user != null) {
                user.setPasswordHash(newPassword);  // Không băm, lưu mật khẩu trực tiếp
                boolean result = userDAO.updateCustomerbyId(user); 
                System.out.println("user: "+user.toString());
                System.out.println("result: "+result);
                if (result) {
                    response.sendRedirect("login.jsp");
                } else {
                    request.setAttribute("err", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
                    request.getRequestDispatcher("new-password.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("err", "Email không tồn tại.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("err", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("new-password.jsp").forward(request, response);
        }
    } catch (Exception ex) {
        ex.printStackTrace();
    }
}

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
