/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package LoginController;

import Dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Random;
import Model.Email;
import Model.User;

@WebServlet("/forgotpassword")
public class ForgotPassword extends HttpServlet {

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
            out.println("<title>Servlet ForgotPassword</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ForgotPassword at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
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
    String emailr = request.getParameter("email");
    String code = getRandom();  // Tạo mã OTP ngẫu nhiên
    Email email = new Email();

    UserDAO customerDAO = new UserDAO();
    User user = customerDAO.getUserByEmail(emailr);
    // check email tồn tại hay ko
    
    if (user != null) {
        // Gửi email với mã OTP
        boolean emailSent = email.sendMess(emailr, "Password Recovery", "Your OTP code is: " + code);
        if (emailSent) {
            request.setAttribute("emailr", emailr);
            request.setAttribute("code", code);  // Có thể hiển thị OTP trên giao diện để kiểm tra
            request.getRequestDispatcher("pincode.jsp").forward(request, response);
        } else {
            request.setAttribute("err", "Error sending OTP email. Please try again.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    } else {
        String err = "Email does not exist!";
        request.setAttribute("err", err);
        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }

    }

    public String getRandom() {
        Random random = new Random();

        // Tạo chuỗi số ngẫu nhiên
        StringBuilder randomNumbers = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            randomNumbers.append(random.nextInt(10));
        }
        return randomNumbers.toString();
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
