package Controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Dal.UserDAO;
import Model.Customer;
import Model.User;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/customer"})
public class CustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO userDAO = new UserDAO();
        List<Customer> customers = userDAO.listAllCustomers();
        
        // Filter customer
        String filterStatus = request.getParameter("filterStatus");
        if (filterStatus != null && !filterStatus.isEmpty()) {
            customers.removeIf(e -> !filterStatus.equals(e.getUser().getStatus()));
        }


        request.setAttribute("customers", customers);
        request.getRequestDispatcher("View/User/list-customer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO userDAO = new UserDAO();
        String deleteCustomerID = request.getParameter("deleteCustomerID");

        // Handle delete action
        if (deleteCustomerID != null && !deleteCustomerID.isEmpty()) {
            try {
                int id = Integer.parseInt(deleteCustomerID);
                userDAO.deleteCustomer(id);
            } catch (NumberFormatException e) {
                // Ignore invalid ID
            }
            response.sendRedirect("customer");
            return;
        }

        // Handle add or edit actions
        String customerID = request.getParameter("customerID");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String avatar = request.getParameter("profilePictureURL");
        String status = request.getParameter("status"); // Only used for edit
        boolean isUpdate = customerID != null && !customerID.isEmpty();

        // Validate inputs
        List<String> errors = new ArrayList<>();

        if (username == null || username.trim().isEmpty() || username.length() < 3) {
            errors.add("Tên người dùng phải có ít nhất 3 ký tự và không được để trống.");
        } else {
            boolean isTaken = false;

            if (!isUpdate) {
                // Check if username already exists for a new customer
                isTaken = userDAO.isUsernameTaken(username);
            } else {
                // Check if username is being updated and already exists
                Customer oldCustomer = userDAO.getCustomerById(Integer.parseInt(customerID));
                if (oldCustomer != null && !oldCustomer.getUser().getUsername().equals(username)) {
                    isTaken = userDAO.isUsernameTaken(username);
                }
            }

            if (isTaken) {
                request.setAttribute("errorMessage", "Tên người dùng đã tồn tại. Vui lòng chọn tên khác.");
                doGet(request, response);
                return;
            }
        }

        if (!isUpdate && (password == null || password.trim().isEmpty() || password.length() < 6 || !Pattern.compile("\\d").matcher(password).find())) {
            errors.add("Mật khẩu phải có ít nhất 6 ký tự và chứa ít nhất 1 chữ số.");
        }

        if (fullName == null || fullName.trim().isEmpty() || fullName.length() < 3) {
            errors.add("Họ tên phải có ít nhất 3 ký tự và không được để trống.");
        }

        // Validate email
        if (email == null || email.trim().isEmpty() || !Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$").matcher(email).matches()) {
            errors.add("Email không hợp lệ hoặc để trống.");
        } else {
            boolean isTaken = false;

            if (!isUpdate) {
                // Check if email already exists for a new customer
                isTaken = userDAO.isEmailTaken(email);
            } else {
                // Check if email is being updated and already exists
                Customer oldCustomer = userDAO.getCustomerById(Integer.parseInt(customerID));
                if (oldCustomer != null && !oldCustomer.getUser().getEmail().equals(email)) {
                    isTaken = userDAO.isEmailTaken(email);
                }
            }

            if (isTaken) {
                request.setAttribute("errorMessage", "Email đã tồn tại. Vui lòng nhập email khác.");
                doGet(request, response);
                return;
            }
        }

        // Validate phone number
        if (phoneNumber != null && !phoneNumber.trim().isEmpty() && !Pattern.compile("^[0-9]{10,11}$").matcher(phoneNumber).matches()) {
            errors.add("Số điện thoại phải chứa 10 hoặc 11 chữ số và không được để trống.");
        } else {
            boolean isTaken = false;

            if (!isUpdate) {
                // Check if phone number already exists for a new customer
                if (phoneNumber != null && !phoneNumber.trim().isEmpty()) {
                    isTaken = userDAO.isPhoneNumberTaken(phoneNumber);
                }
            } else {
                // Check if phone number is being updated and already exists
                Customer oldCustomer = userDAO.getCustomerById(Integer.parseInt(customerID));
                if (oldCustomer != null) {
                    String oldPhoneNumber = oldCustomer.getUser().getPhoneNumber();
                    if (phoneNumber != null && !phoneNumber.equals(oldPhoneNumber)) {
                        isTaken = userDAO.isPhoneNumberTaken(phoneNumber);
                    }
                }
            }

            if (isTaken) {
                request.setAttribute("errorMessage", "Số điện thoại đã tồn tại. Vui lòng nhập số điện thoại khác.");
                doGet(request, response);
                return;
            }
        }

        // Validate address
        if (address != null && address.trim().isEmpty()) {
            errors.add("Địa chỉ không được để trống hoặc chỉ chứa khoảng trắng.");
        }

        // Validate avatar
        if (avatar != null && avatar.trim().isEmpty()) {
            errors.add("Địa chỉ không được để trống hoặc chỉ chứa khoảng trắng.");
        }
        
        // Nếu có lỗi, trả về giao diện với danh sách lỗi
        if (!errors.isEmpty()) {
            request.setAttribute("errorMessages", errors);
            doGet(request, response);
            return;
        }

        // Create or update customer
        Customer customer = isUpdate ? userDAO.getCustomerById(Integer.parseInt(customerID)) : new Customer();
        if (customer == null) {
            request.setAttribute("errorMessage", "Không tìm thấy khách hàng.");
            doGet(request, response);
            return;
        }

        // Map data to customer and user objects
        User user = isUpdate ? customer.getUser() : new User();
        user.setUsername(username);

        if (!isUpdate || (password != null && !password.trim().isEmpty())) {
            user.setPassword(password);
        }

        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNumber(phoneNumber);
        user.setAddress(address);
        user.setProfilePictureURL(avatar);

        // Only update status if editing
        if (isUpdate && status != null) {
            user.setStatus(status);
        }

        customer.setUser(user); // Ensure customer links to the correct user

        if (isUpdate) {
            userDAO.editCustomer(customer);
        } else {
            userDAO.addCustomer(customer);
        }

        doGet(request, response);
    }
}