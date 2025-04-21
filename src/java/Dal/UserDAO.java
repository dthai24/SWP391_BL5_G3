package Dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Model.User;
import DBContext.DBContext;
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
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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
                    rs.getString("Role"),
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
        String sql = "INSERT INTO Users (Username, Password, FullName, Email, PhoneNumber, Address, Role, ProfilePictureURL, Status, RegistrationDate, IsDeleted) "
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

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
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a user (soft delete)
    public boolean deleteUser(int userID) {
        String sql = "UPDATE Users SET isDeleted = 1 WHERE userID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userID);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // List all users (non-deleted)
    public List<User> listAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE isDeleted = 0";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                users.add(mapResultSetToUser(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Get user by ID
    public User getUserById(int userID) {
        String sql = "SELECT * FROM Users WHERE userID = ? AND isDeleted = 0";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userID);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return mapResultSetToUser(resultSet);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tìm kiếm, lọc, sắp xếp, và phân trang người dùng
    public List<User> searchAndListUsers(String keyword, String role, String sortBy, String sortDirection, int page, int pageSize) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE isDeleted = 0";

        // Thêm điều kiện tìm kiếm
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (username LIKE ? OR fullName LIKE ? OR email LIKE ?)";
        }

        // Thêm lọc theo vai trò
        if (role != null && !role.trim().isEmpty()) {
            sql += " AND role = ?";
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

            // Gán tham số cho vai trò
            if (role != null && !role.trim().isEmpty()) {
                statement.setString(paramIndex++, role);
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

    public int countUsers(String keyword, String role) {
        String sql = "SELECT COUNT(*) FROM Users WHERE isDeleted = 0";
        List<Object> params = new ArrayList<>();

        // Thêm điều kiện tìm kiếm
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (username LIKE ? OR fullName LIKE ? OR email LIKE ?)";
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        // Thêm điều kiện lọc vai trò
        if (role != null && !role.trim().isEmpty()) {
            sql += " AND role = ?";
            params.add(role);
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

    // Helper method to map ResultSet to User object
    private User mapResultSetToUser(ResultSet resultSet) throws SQLException {
        return new User(
                resultSet.getInt("userID"),
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
    }

    public List<User> searchUsers(String searchTerm, String role, String sortBy, String sortDirection) {
        return searchAndListUsers(searchTerm, role, sortBy, sortDirection, 1, Integer.MAX_VALUE);
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
