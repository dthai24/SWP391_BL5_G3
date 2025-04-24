/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package LoginController;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet(name="CheckPin", urlPatterns={"/check-pin"})
public class CheckPin extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet CheckPin</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CheckPin at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
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
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String pin1 = request.getParameter("pin1");
        String pin2 = request.getParameter("pin2");
        String pin3 = request.getParameter("pin3");
        String pin4 = request.getParameter("pin4");
        String pin5 = request.getParameter("pin5");
        String pin6 = request.getParameter("pin6");

        // Ghép các ký tự lại thành một chuỗi
        String pin = pin1 + pin2 + pin3 + pin4 + pin5 + pin6;   
        String coderr = request.getParameter("code");
        String emailr = request.getParameter("emailr");
        try {
        int pinInput = Integer.parseInt(pin);
        int code = Integer.parseInt(coderr);
        request.setAttribute("emailr", emailr);
        if(pin.equals(coderr)){
           System.out.println("Correct Pin");
          request.getRequestDispatcher("new-password.jsp").forward(request, response);  
        }else{
            String err = "Error pin input";
            request.setAttribute("code", code);
            request.setAttribute("err", err);
            request.getRequestDispatcher("pincode.jsp").forward(request, response);
        }       
        } catch (Exception e) {
            e.printStackTrace();
            String err = "Xảy ra lỗi xác minh";
            request.setAttribute("err", err);
            request.getRequestDispatcher("pincode.jsp").forward(request, response);
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
