import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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