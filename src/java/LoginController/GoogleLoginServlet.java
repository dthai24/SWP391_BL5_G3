package LoginController;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.http.client.ClientProtocolException;
import util.Iconstant;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import Model.User;
import Dal.UserDAO;
import java.net.URLEncoder;

@WebServlet(name = "GoogleLoginServlet", urlPatterns = {"/LoginGoogle"})
public class GoogleLoginServlet extends HttpServlet {

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage, String errorPage) throws ServletException, IOException {
        System.err.println(errorMessage);
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher(errorPage).forward(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        PrintWriter out = response.getWriter();

        if (code == null || code.isEmpty()) {
            handleError(request, response, "Không tìm thấy authorization code", "error.jsp");
            return;
        }

        try {
            System.out.println("CODE: " + code);
            System.out.println("CLIENT_ID = " + Iconstant.GOOGLE_CLIENT_ID);
            System.out.println("CLIENT_SECRET = " + Iconstant.GOOGLE_CLIENT_SECRET);
            // gửi authorizon để token
            //token: lưu trữ tài nguyên để k cần phải nhập thêm lần nữa
            // chứa thông tin của người dùng luôn bao gồm username các kiểu
            //

            String accessToken = getToken(code);
            if (accessToken == null) {
                handleError(request, response, "Lỗi lấy access token", "error.jsp");
                return;
            }
           // tạo user chứa token đó
           //check mail 
            User user = getUserInfo(accessToken);
            if (user == null || user.getEmail() == null) {
                handleError(request, response, "Lỗi lấy thông tin user", "error.jsp");
                return;
            }

            System.out.println("User Info: " + user);

            UserDAO customerDAO = new UserDAO();
            User existingCustomer = customerDAO.getUserByEmail(user.getEmail());
            String contextPath = request.getContextPath();

            if (existingCustomer != null) {
                request.getSession().setAttribute("user", existingCustomer);
                response.sendRedirect(contextPath + "/homepage.jsp");
            } else {
                request.setAttribute("email", user.getEmail()); // Truyền email của người dùng vào request
                request.getRequestDispatcher("login-google.jsp").forward(request, response);
            }
        } catch (Exception e) {
            handleError(request, response, "Lỗi hệ thống: " + e.getMessage(), "error.jsp");
        }
    }

    public static String getToken(String code) throws IOException {
//         System.out.println("=== Gửi request lấy access token từ Google ===");
//    System.out.println("client_id: " + Iconstant.GOOGLE_CLIENT_ID);
//    System.out.println("client_secret: " + Iconstant.GOOGLE_CLIENT_SECRET);
//    System.out.println("redirect_uri: " + Iconstant.GOOGLE_REDIRECT_URI);
//    System.out.println("code: " + code);
        String encodedCode = URLEncoder.encode(code, "UTF-8");
        String response = Request.Post(Iconstant.GOOGLE_LINK_GET_TOKEN)
                .bodyForm(Form.form()
                        .add("client_id", Iconstant.GOOGLE_CLIENT_ID)
                        .add("client_secret", Iconstant.GOOGLE_CLIENT_SECRET)
                        .add("redirect_uri", Iconstant.GOOGLE_REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", "authorization_code")
                        .build())
                .execute().returnContent().asString();

        System.out.println("Google Token Response: " + response);
      /// gửi token dưới dạng json 
      //chuyển thành object của user
        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        return jobj.has("access_token") ? jobj.get("access_token").getAsString() : null;

    }

    public static User getUserInfo(final String accessToken) throws IOException {
        String link = Iconstant.GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link)
                .execute()
                .returnContent()
                .asString();

        System.out.println("Google User Info Response: " + response);

        try {
            JsonObject json = new Gson().fromJson(response, JsonObject.class);
            User customer = new User();

            if (json.has("email")) {
                customer.setEmail(json.get("email").getAsString());
            }
            if (json.has("name")) {
                customer.setUsername(json.get("name").getAsString());
            }
            if (json.has("picture")) {
                customer.setProfilePictureURL(json.get("picture").getAsString());
            }

            return customer;
        } catch (Exception e) {
            System.err.println("Error parsing Google User Info: " + e.getMessage());
            return null;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
