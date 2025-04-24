package Dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Model.User;
import DBContext.DBContext;
import Model.Customer;
import Model.Employee;
import java.time.Instant;

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
        String sql = "INSERT INTO Users (Username, Password, FullName, Email, PhoneNumber, Address, ProfilePictureURL, Status, RegistrationDate, IsDeleted) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, user.getUsername());
            statement.setString(2, user.getPassword());
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


    // Tìm kiếm, lọc, sắp xếp, và phân trang người dùng
    public List<User> searchAndListUsers(String keyword, String sortBy, String sortDirection, int page, int pageSize) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE isDeleted = 0";

        // Thêm điều kiện tìm kiếm
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (username LIKE ? OR fullName LIKE ? OR email LIKE ?)";
        }

      
        // Thêm sắp xếp
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            sql += " ORDER BY " + sortBy;

            if ("desc".equalsIgnoreCase(sortDirection)) {
                sql += " DESC";
            } else {
                sql += " ASC";
            }
        } else {
            sql += " ORDER BY userID ASC";
        }

        // Phân trang
        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            int paramIndex = 1;

            // Gán tham số cho tìm kiếm
            if (keyword != null && !keyword.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + keyword + "%");
                statement.setString(paramIndex++, "%" + keyword + "%");
                statement.setString(paramIndex++, "%" + keyword + "%");
            }

            

            // Gán tham số cho phân trang
            statement.setInt(paramIndex++, (page - 1) * pageSize);
            statement.setInt(paramIndex++, pageSize);

            System.out.println("Executing SQL: " + sql); // Log SQL query
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                users.add(mapResultSetToUser(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public int countUsers(String keyword) {
        String sql = "SELECT COUNT(*) FROM Users WHERE isDeleted = 0";
        List<Object> params = new ArrayList<>();

        // Thêm điều kiện tìm kiếm
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (username LIKE ? OR fullName LIKE ? OR email LIKE ?)";
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
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
    private User mapResultSetToUser(ResultSet resultSet) throws SQLException {
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
        return user;
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
    }


    public List<User> searchUsers(String searchTerm, String sortBy, String sortDirection) {
        return searchAndListUsers(searchTerm, sortBy, sortDirection, 1, Integer.MAX_VALUE);
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
