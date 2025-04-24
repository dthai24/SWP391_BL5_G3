package Dal;

import DBContext.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import Model.User;
<<<<<<< Updated upstream
import DBContext.DBContext;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
=======
import Model.Customer;
import Model.Employee;

>>>>>>> Stashed changes
import java.time.Instant;
import util.ValidFunction;

public class UserDAO {

    private Connection connection;

    // Constructor to initialize the connection using DBContext
    public UserDAO() {
        try {
            DBContext db = new DBContext();
            connection = db.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

<<<<<<< Updated upstream
    // Add a new user
    public boolean addUser(User user) {
        String sql = "INSERT INTO Users (username, passwordHash, fullName, email, phoneNumber, address, role, profilePictureURL, status, registrationDate, isDeleted) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, user.getUsername());
            statement.setString(2, user.getPasswordHash());
            statement.setString(3, user.getFullName());
            statement.setString(4, user.getEmail());
            statement.setString(5, user.getPhoneNumber());
            statement.setString(6, user.getAddress());
            statement.setString(7, user.getRole());
            statement.setString(8, user.getProfilePictureURL());
            statement.setString(9, user.getStatus());
            statement.setDate(10, new java.sql.Date(user.getRegistrationDate().getTime()));
            statement.setBoolean(11, user.getIsDeleted());
            return statement.executeUpdate() > 0;
=======
    // Add a new customer
    public boolean addCustomer(Customer customer) {
        String userSql = "INSERT INTO Users (username, password, fullName, email, phoneNumber, address, profilePictureURL, status, isDeleted, registrationDate) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String customerSql = "INSERT INTO Customers (CustomerID) VALUES (?)";
        try (PreparedStatement userStatement = connection.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement customerStatement = connection.prepareStatement(customerSql)) {

            // Insert into Users table
            userStatement.setString(1, customer.getUser().getUsername());
            userStatement.setString(2, customer.getUser().getPassword());
            userStatement.setString(3, customer.getUser().getFullName());
            userStatement.setString(4, customer.getUser().getEmail());
            userStatement.setString(5, customer.getUser().getPhoneNumber());
            userStatement.setString(6, customer.getUser().getAddress());
            userStatement.setString(7, customer.getUser().getProfilePictureURL());
            userStatement.setString(8, customer.getUser().getStatus());
            userStatement.setBoolean(9, customer.getUser().getIsDeleted());
            userStatement.setDate(10, new java.sql.Date(System.currentTimeMillis())); // Ngày hiện tại

            if (userStatement.executeUpdate() > 0) {
                // Get the generated UserID
                ResultSet generatedKeys = userStatement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int userID = generatedKeys.getInt(1);

                    // Insert into Customers table
                    customerStatement.setInt(1, userID);
                    return customerStatement.executeUpdate() > 0;
                }
            }
>>>>>>> Stashed changes
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Add a new employee
    public boolean addEmployee(Employee employee) {
        String userSql = "INSERT INTO Users (username, password, fullName, email, phoneNumber, address, profilePictureURL, status, isDeleted, registrationDate) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String employeeSql = "INSERT INTO Employees (EmployeeID, EmployeeRole) VALUES (?, ?)";
        try (PreparedStatement userStatement = connection.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement employeeStatement = connection.prepareStatement(employeeSql)) {

            // Insert into Users table
            userStatement.setString(1, employee.getUser().getUsername());
            userStatement.setString(2, employee.getUser().getPassword());
            userStatement.setString(3, employee.getUser().getFullName());
            userStatement.setString(4, employee.getUser().getEmail());
            userStatement.setString(5, employee.getUser().getPhoneNumber());
            userStatement.setString(6, employee.getUser().getAddress());
            userStatement.setString(7, employee.getUser().getProfilePictureURL());
            userStatement.setString(8, employee.getUser().getStatus());
            userStatement.setBoolean(9, employee.getUser().getIsDeleted());
            userStatement.setDate(10, new java.sql.Date(System.currentTimeMillis())); // Ngày hiện tại

            if (userStatement.executeUpdate() > 0) {
                // Get the generated UserID
                ResultSet generatedKeys = userStatement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int userID = generatedKeys.getInt(1);

                    // Insert into Employees table
                    employeeStatement.setInt(1, userID);
                    employeeStatement.setString(2, employee.getEmployeeRole());
                    return employeeStatement.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean updateUser(User user) {
    String sql = "UPDATE Users SET fullName = ?, email = ?, phoneNumber = ?, address = ?, Password = ? WHERE userID = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, user.getFullName() != null ? user.getFullName() : "");
        ps.setString(2, user.getEmail() != null ? user.getEmail() : "");
        ps.setString(3, user.getPhoneNumber() != null ? user.getPhoneNumber() : "");
        ps.setString(4, user.getAddress() != null ? user.getAddress() : "");
        ps.setString(5, user.getPasswordHash() != null ? user.getPasswordHash() : "");
        ps.setInt(6, user.getUserID());
        int rowsUpdated = ps.executeUpdate();
        return rowsUpdated > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

<<<<<<< Updated upstream
//    public boolean updateUserProfile(User user) {
//    String sql = "UPDATE Users SET fullName = ?, email = ?, phone = ?, address = ? WHERE userID = ?";
//    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
//        stmt.setString(1, user.getFullName());
//        stmt.setString(2, user.getEmail());
//        stmt.setString(3, user.getPhoneNumber());
//        stmt.setString(4, user.getAddress());
//        stmt.setInt(5, user.getUserID());  // Giả sử bạn có phương thức getUserID để lấy ID người dùng
//
//        int rowsAffected = stmt.executeUpdate();
//        return rowsAffected > 0;  // Nếu cập nhật thành công, trả về true
//    } catch (SQLException e) {
//        e.printStackTrace();
//    }
//    return false;  // Nếu có lỗi hoặc không cập nhật được, trả về false
//}

   public boolean updateCustomerbyId(User user) {
    String sql = "UPDATE Users SET "
            + "username = ?, "
            + "password = ?, "
            + "fullName = ?, "
            + "email = ?, "
            + "phoneNumber = ?, "
            + "address = ?, "
            + "status = ?, "
            + "registrationDate = ?, "
            + "isDeleted = ? "
            + "WHERE userID = ?";

    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setString(1, user.getUsername());
        stmt.setString(2, user.getPasswordHash());  // Không cần băm mật khẩu
        stmt.setString(3, user.getFullName());
        stmt.setString(4, user.getEmail());
        stmt.setString(5, user.getPhoneNumber());
        stmt.setString(6, user.getAddress());
        stmt.setString(7, user.getStatus());
        stmt.setTimestamp(8, new Timestamp(user.getRegistrationDate().getTime()));
        stmt.setBoolean(9, user.getIsDeleted());
        stmt.setInt(10, user.getUserID());

        int result = stmt.executeUpdate();
        return result > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

public User getUserByEmail(String email) {
    String sql = "SELECT * FROM Users WHERE Email = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new User(
                       rs.getInt("UserID"),
                rs.getString("Username"),
                rs.getString("Password"),
                rs.getString("FullName"),
                rs.getString("Email"),
                rs.getString("PhoneNumber"),
                rs.getString("Address"),
                rs.getString("Role"),
                rs.getString("ProfilePictureURL"),
                rs.getString("Status"),
                rs.getDate("RegistrationDate"),
                rs.getBoolean("IsDeleted")
            );
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
public boolean checkOTP(String email, String otp) {
        String sql = "SELECT * FROM reset_token WHERE customerID = (SELECT customerID FROM Customer WHERE email = ?) AND token = ? AND expiry_date > ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            st.setString(2, otp);
            st.setTimestamp(3, new java.sql.Timestamp(System.currentTimeMillis()));  // So sánh với thời gian hiện tại
            ResultSet rs = st.executeQuery();
            return rs.next();  // Nếu có kết quả, OTP hợp lệ và chưa hết hạn
        } catch (SQLException e) {
=======
    public User login(String username, String password) {
        String sql = "SELECT * FROM Users WHERE Username = ? AND Password = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("UserID"),
                        rs.getString("Username"),
                        rs.getString("Password"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("PhoneNumber"),
                        rs.getString("Address"),
                        rs.getString("ProfilePictureURL"),
                        rs.getString("Status"),
                        rs.getDate("RegistrationDate"),
                        rs.getBoolean("IsDeleted")
                );
            }
        } catch (Exception e) {
>>>>>>> Stashed changes
            e.printStackTrace();
        }
        return false;
    }
    public User login(String username, String password) {
    String sql = "SELECT * FROM Users WHERE Username = ? AND Password = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, username);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new User(
                rs.getInt("UserID"),
                rs.getString("Username") != null ? rs.getString("Username") : "",
                rs.getString("Password") != null ? rs.getString("Password") : "",
                rs.getString("FullName") != null ? rs.getString("FullName") : "",
                rs.getString("Email") != null ? rs.getString("Email") : "",
                rs.getString("PhoneNumber") != null ? rs.getString("PhoneNumber") : "",
                rs.getString("Address") != null ? rs.getString("Address") : "",
                rs.getString("Role") != null ? rs.getString("Role") : "",
                rs.getString("ProfilePictureURL") != null ? rs.getString("ProfilePictureURL") : "",
                rs.getString("Status") != null ? rs.getString("Status") : "",
                rs.getDate("RegistrationDate"),
                rs.getBoolean("IsDeleted")
            );
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

    public boolean checkExist(String username, String email) {
        String sql = "SELECT 1 FROM Users WHERE Username = ? OR Email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            return ps.executeQuery().next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean register(User user) {
        String sql = "INSERT INTO Users (Username, Password, FullName, Email, PhoneNumber, Addres, ProfilePictureURL, Status, RegistrationDate, IsDeleted) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, user.getUsername());
            statement.setString(2, user.getPasswordHash());
            statement.setString(3, user.getFullName());
            statement.setString(4, user.getEmail());
            statement.setString(5, user.getPhoneNumber());
            statement.setString(6, user.getAddress());
            statement.setString(7, user.getProfilePictureURL());
            statement.setString(8, user.getStatus());
            statement.setDate(9, new java.sql.Date(user.getRegistrationDate().getTime()));
            statement.setBoolean(10, user.getIsDeleted());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

<<<<<<< Updated upstream
    // Edit an existing user
    public boolean editUser(User user) {
        String sql = "UPDATE Users SET username = ?, passwordHash = ?, fullName = ?, email = ?, phoneNumber = ?, address = ?, role = ?, profilePictureURL = ?, status = ?, registrationDate = ? "
                + "WHERE userID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, user.getUsername());
            statement.setString(2, user.getPasswordHash());
            statement.setString(3, user.getFullName());
            statement.setString(4, user.getEmail());
            statement.setString(5, user.getPhoneNumber());
            statement.setString(6, user.getAddress());
            statement.setString(7, user.getRole());
            statement.setString(8, user.getProfilePictureURL());
            statement.setString(9, user.getStatus());
            statement.setDate(10, new java.sql.Date(user.getRegistrationDate().getTime()));
            statement.setInt(11, user.getUserID());
=======
   // Edit an existing customer
    public boolean editCustomer(Customer customer) {
        String sql = "UPDATE Users SET username = ?, password = ?, fullName = ?, email = ?, phoneNumber = ?, address = ?, profilePictureURL = ?, status = ? "
                + "WHERE userID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            // Update the user information
            statement.setString(1, customer.getUser().getUsername());
            statement.setString(2, customer.getUser().getPassword());
            statement.setString(3, customer.getUser().getFullName());
            statement.setString(4, customer.getUser().getEmail());
            statement.setString(5, customer.getUser().getPhoneNumber());
            statement.setString(6, customer.getUser().getAddress());
            statement.setString(7, customer.getUser().getProfilePictureURL());
            statement.setString(8, customer.getUser().getStatus());
            statement.setInt(9, customer.getCustomerID()); // Use CustomerID as reference
>>>>>>> Stashed changes
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Edit an existing employee
    public boolean editEmployee(Employee employee) {
        String sqlUser = "UPDATE Users SET username = ?, password = ?, fullName = ?, email = ?, phoneNumber = ?, address = ?, profilePictureURL = ?, status = ? "
                + "WHERE userID = ?";
        String sqlEmployee = "UPDATE Employees SET EmployeeRole = ? WHERE EmployeeID = ?";
        try (PreparedStatement userStatement = connection.prepareStatement(sqlUser);
             PreparedStatement employeeStatement = connection.prepareStatement(sqlEmployee)) {

            // Update the user information
            userStatement.setString(1, employee.getUser().getUsername());
            userStatement.setString(2, employee.getUser().getPassword());
            userStatement.setString(3, employee.getUser().getFullName());
            userStatement.setString(4, employee.getUser().getEmail());
            userStatement.setString(5, employee.getUser().getPhoneNumber());
            userStatement.setString(6, employee.getUser().getAddress());
            userStatement.setString(7, employee.getUser().getProfilePictureURL());
            userStatement.setString(8, employee.getUser().getStatus());
            userStatement.setInt(9, employee.getEmployeeID()); // Use EmployeeID as reference

            // Update the employee-specific role
            employeeStatement.setString(1, employee.getEmployeeRole());
            employeeStatement.setInt(2, employee.getEmployeeID());

            // Execute both updates
            boolean userUpdated = userStatement.executeUpdate() > 0;
            boolean employeeUpdated = employeeStatement.executeUpdate() > 0;

            return userUpdated && employeeUpdated;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a customer (soft delete)
    public boolean deleteCustomer(int customerID) {
        String sql = "UPDATE Users SET isDeleted = 1 WHERE userID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, customerID); // CustomerID is the same as UserID
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete an employee (soft delete)
    public boolean deleteEmployee(int employeeID) {
        String sql = "UPDATE Users SET isDeleted = 1 WHERE userID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, employeeID); // EmployeeID is the same as UserID
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // List all customers (non-deleted)
    public List<Customer> listAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customers c INNER JOIN Users u ON c.CustomerID = u.UserID WHERE u.isDeleted = 0";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                customers.add(mapResultSetToCustomer(resultSet)); // Use mapResultSetToCustomer
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    // List all employees (non-deleted)
    public List<Employee> listAllEmployees() {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT * FROM Employees e INNER JOIN Users u ON e.EmployeeID = u.UserID WHERE u.isDeleted = 0";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                employees.add(mapResultSetToEmployee(resultSet)); // Use mapResultSetToEmployee
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return employees;
    }

    // Get customer by ID
    public Customer getCustomerById(int customerID) {
        String sql = "SELECT * FROM Customers c INNER JOIN Users u ON c.CustomerID = u.UserID WHERE c.CustomerID = ? AND u.isDeleted = 0";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, customerID);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return mapResultSetToCustomer(resultSet); // Use mapResultSetToCustomer
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get employee by ID
    public Employee getEmployeeById(int employeeID) {
        String sql = "SELECT * FROM Employees e INNER JOIN Users u ON e.EmployeeID = u.UserID WHERE e.EmployeeID = ? AND u.isDeleted = 0";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, employeeID);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return mapResultSetToEmployee(resultSet); // Use mapResultSetToEmployee
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


    // Update profile picture URL for a user
    public boolean updateProfilePicture(int userID, String profilePictureURL) {
        String sql = "UPDATE Users SET profilePictureURL = ? WHERE userID = ? AND isDeleted = 0";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, profilePictureURL);
            statement.setInt(2, userID);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isUsernameTaken(String username) {
        String query = "SELECT COUNT(*) FROM Users WHERE username = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, username);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // Trả về true nếu username đã tồn tại
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Trả về false nếu không có lỗi hoặc không tìm thấy
    }

    public boolean isEmailTaken(String email) {
        String query = "SELECT COUNT(*) FROM Users WHERE email = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, email);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // Trả về true nếu email đã tồn tại
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Trả về false nếu không có lỗi hoặc không tìm thấy
    }

<<<<<<< Updated upstream
    // Helper method to map ResultSet to User object
    private User mapResultSetToUser(ResultSet resultSet) throws SQLException {
       return new User(
    resultSet.getString("username"),
    resultSet.getString("passwordHash"),
    resultSet.getString("fullName"),
    resultSet.getString("email"),
    resultSet.getString("phoneNumber"),
    resultSet.getString("address"),
    resultSet.getString("role"),
    resultSet.getString("profilePictureURL"),
    resultSet.getString("status"),
    resultSet.getDate("registrationDate"),
    resultSet.getBoolean("isDeleted")
);
=======
    public boolean isPhoneNumberTaken(String phoneNumber) {
        String query = "SELECT COUNT(*) FROM Users WHERE phonenumber = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, phoneNumber);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // Trả về true nếu email đã tồn tại
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Trả về false nếu không có lỗi hoặc không tìm thấy
    }

    // Helper method to map ResultSet to Customer object
    private Customer mapResultSetToCustomer(ResultSet resultSet) throws SQLException {
        Customer customer = new Customer();
        customer.setCustomerID(resultSet.getInt("CustomerID")); // Map CustomerID
        User user = new User(
                resultSet.getInt("userID"),
                resultSet.getString("username"),
                resultSet.getString("password"),
                resultSet.getString("fullName"),
                resultSet.getString("email"),
                resultSet.getString("phoneNumber"),
                resultSet.getString("address"),
                resultSet.getString("profilePictureURL"),
                resultSet.getString("status"),
                resultSet.getDate("registrationDate"),
                resultSet.getBoolean("isDeleted")
        );
        customer.setUser(user); // Set associated User object
        return customer;
    }

    // Helper method to map ResultSet to Employee object
    private Employee mapResultSetToEmployee(ResultSet resultSet) throws SQLException {
        Employee employee = new Employee();
        employee.setEmployeeID(resultSet.getInt("EmployeeID")); // Map EmployeeID
        employee.setEmployeeRole(resultSet.getString("EmployeeRole")); // Map EmployeeRole
        User user = new User(
                resultSet.getInt("userID"),
                resultSet.getString("username"),
                resultSet.getString("password"),
                resultSet.getString("fullName"),
                resultSet.getString("email"),
                resultSet.getString("phoneNumber"),
                resultSet.getString("address"),
                resultSet.getString("profilePictureURL"),
                resultSet.getString("status"),
                resultSet.getDate("registrationDate"),
                resultSet.getBoolean("isDeleted")
        );
        employee.setUser(user); // Set associated User object
        return employee;
>>>>>>> Stashed changes
    }



    // Main method to test new features
    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        // Testing profile picture update
        System.out.println("\n=== Testing Profile Picture Update ===");
        boolean updated = userDAO.updateProfilePicture(5, "https://media.tenor.com/k_UsDt9xfWIAAAAM/i-will-eat-you-cat.gif");
        System.out.println("Update Successful: " + updated);
    }
}
