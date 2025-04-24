package Controller;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Dal.UserDAO;
import Model.Employee;

@WebServlet(name = "EmployeeServlet", urlPatterns = {"/employee"})
public class EmployeeServlet extends HttpServlet {

    // Handle GET requests
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO userDAO = new UserDAO();
        List<Employee> employees = userDAO.listAllEmployees();

        // Filter employees
        String filterRole = request.getParameter("filterRole");
        String filterStatus = request.getParameter("filterStatus");

        if (filterRole != null && !filterRole.isEmpty()) {
            employees.removeIf(e -> !filterStatus.equals(e.getEmployeeRole()));
        }

        
        if (filterStatus != null && !filterStatus.isEmpty()) {
            employees.removeIf(e -> !filterStatus.equals(e.getUser().getStatus()));
        }

        request.setAttribute("employees", employees);
        request.getRequestDispatcher("View/User/list-employee.jsp").forward(request, response);
    }

    // Handle POST requests for add, edit, and delete actions
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO userDAO = new UserDAO();
        String deleteEmployeeID = request.getParameter("deleteEmployeeID");

        // Handle delete action
        if (deleteEmployeeID != null && !deleteEmployeeID.isEmpty()) {
            try {
                int id = Integer.parseInt(deleteEmployeeID);
                userDAO.deleteEmployee(id);
            } catch (NumberFormatException e) {
                // Ignore invalid ID
            }
            response.sendRedirect("employee");
            return;
        }

        String employeeID = request.getParameter("employeeID");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String employeeRole = request.getParameter("employeeRole");
        String status = request.getParameter("status");
        String profilePictureURL = request.getParameter("profilePictureURL");
        boolean isUpdate = employeeID != null && !employeeID.isEmpty();

        // Validate inputs
        List<String> errors = new ArrayList<>();

        if (username == null || username.trim().isEmpty() || username.length() < 3) {
            errors.add("Tên người dùng phải có ít nhất 3 ký tự và không được để trống.");
        } else if (!isUpdate && userDAO.isUsernameTaken(username)) {
            request.setAttribute("errorMessage", "Tên người dùng đã tồn tại. Vui lòng chọn tên khác.");
            doGet(request, response);
            return;
        } else if (isUpdate) {
            Employee oldEmployee = userDAO.getEmployeeById(Integer.parseInt(employeeID));
            if (oldEmployee != null && !oldEmployee.getUser().getUsername().equals(username) && userDAO.isUsernameTaken(username)) {
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

        if (email == null || email.trim().isEmpty() || !Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$").matcher(email).matches()) {
            errors.add("Email không hợp lệ hoặc để trống.");
        } else if (!isUpdate && userDAO.isEmailTaken(email)) {
            request.setAttribute("errorMessage", "Email đã tồn tại. Vui lòng nhập email khác.");
            doGet(request, response);
            return;
        } else if (isUpdate) {
            Employee oldEmployee = userDAO.getEmployeeById(Integer.parseInt(employeeID));
            if (oldEmployee != null && !oldEmployee.getUser().getEmail().equals(email) && userDAO.isEmailTaken(email)) {
                request.setAttribute("errorMessage", "Email đã tồn tại. Vui lòng nhập email khác.");
                doGet(request, response);
                return;
            }
        }

        if (phoneNumber != null && !phoneNumber.trim().isEmpty()) {
            if (!Pattern.compile("^[0-9]{10,11}$").matcher(phoneNumber).matches()) {
                errors.add("Số điện thoại phải chứa 10 hoặc 11 chữ số.");
            } else if (!isUpdate && userDAO.isPhoneNumberTaken(phoneNumber)) {
                request.setAttribute("errorMessage", "Số điện thoại đã tồn tại. Vui lòng nhập số điện thoại khác.");
                doGet(request, response);
                return;
            } else if (isUpdate) {
                Employee oldEmployee = userDAO.getEmployeeById(Integer.parseInt(employeeID));
                if (oldEmployee != null && !phoneNumber.equals(oldEmployee.getUser().getPhoneNumber()) && userDAO.isPhoneNumberTaken(phoneNumber)) {
                    request.setAttribute("errorMessage", "Số điện thoại đã tồn tại. Vui lòng nhập số điện thoại khác.");
                    doGet(request, response);
                    return;
                }
            }
        }

        if (address != null && address.trim().isEmpty()) {
            errors.add("Địa chỉ không được để trống hoặc chỉ chứa khoảng trắng.");
        }

        if (!"Active".equals(status) && !"Inactive".equals(status)) {
            errors.add("Trạng thái phải là 'Active' hoặc 'Inactive'.");
        }

        if (employeeRole == null || employeeRole.trim().isEmpty()) {
            errors.add("Vai trò nhân viên không được để trống.");
        }

        // Nếu có lỗi, trả về giao diện với danh sách lỗi
        if (!errors.isEmpty()) {
            request.setAttribute("errorMessages", errors);
            doGet(request, response);
            return;
        }

        // Create or update employee
        Employee employee = isUpdate ? userDAO.getEmployeeById(Integer.parseInt(employeeID)) : new Employee();
        if (employee == null) {
            request.setAttribute("errorMessage", "Không tìm thấy nhân viên.");
            doGet(request, response);
            return;
        }

        employee.getUser().setUsername(username);
        if (!isUpdate || (password != null && !password.trim().isEmpty())) {
            employee.getUser().setPassword(password);
        }
        employee.getUser().setFullName(fullName);
        employee.getUser().setEmail(email);
        employee.getUser().setPhoneNumber(phoneNumber);
        employee.getUser().setAddress(address);
        employee.getUser().setStatus(status);
        employee.getUser().setProfilePictureURL(profilePictureURL);
        employee.setEmployeeRole(employeeRole);
        if (!isUpdate) {
            employee.getUser().setRegistrationDate(new Date()); // Chỉ cập nhật ngày đăng ký nếu là thêm mới
        }

        // Lưu thay đổi vào cơ sở dữ liệu
        boolean success;
        if (isUpdate) {
            success = userDAO.editEmployee(employee);
        } else {
            success = userDAO.addEmployee(employee);
        }

        // Xử lý thông báo thành công hoặc thất bại
        if (success) {
            request.setAttribute("successMessage", isUpdate ? "Cập nhật nhân viên thành công!" : "Thêm nhân viên thành công!");
        } else {
            request.setAttribute("errorMessage", isUpdate ? "Không thể cập nhật nhân viên." : "Không thể thêm nhân viên.");
        }

        // Quay lại danh sách nhân viên
        doGet(request, response);
    }
}