
package Controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Dummy authentication logic (replace with your own)
        if ("admin".equals(username) && "password".equals(password)) {
            // Redirect to a welcome page or dashboard
            response.sendRedirect("welcome.jsp");
        } else {
            // Redirect back to login with an error message
            response.sendRedirect("login.jsp?error=Invalid credentials");
        }
    }
}