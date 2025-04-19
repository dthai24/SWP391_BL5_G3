package Dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Model.User;
import DBContext.DBContext;

public class UserDAO {

    private Connection connection;

    // Constructor to initialize the connection using DBContext
    public UserDAO() {
        try {
            this.connection = new DBContext().getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Add a new user
    public boolean addUser(User user) {
        String sql = "INSERT INTO Users (username, passwordHash, fullName, email, phoneNumber, address, role, profilePictureURL, status, registrationDate, isDeleted) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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

    // Edit an existing user
    public boolean editUser(User user) {
        String sql = "UPDATE Users SET username = ?, passwordHash = ?, fullName = ?, email = ?, phoneNumber = ?, address = ?, role = ?, profilePictureURL = ?, status = ?, registrationDate = ? " +
                     "WHERE userID = ?";
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

    // Search, filter, and sort users
    public List<User> searchUsers(String keyword, String role, String sortBy, String sortDirection) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE isDeleted = 0";

        // Add search criteria
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (username LIKE ? OR fullName LIKE ? OR email LIKE ?)";
        }

        // Add filter by role
        if (role != null && !role.trim().isEmpty()) {
            sql += " AND role = ?";
        }

        // Add sorting
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            sql += " ORDER BY " + sortBy;

            // Add sorting direction
            if (sortDirection != null && sortDirection.equalsIgnoreCase("desc")) {
                sql += " DESC";
            } else {
                sql += " ASC";
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            int paramIndex = 1;

            // Set parameters for search criteria
            if (keyword != null && !keyword.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + keyword + "%");
                statement.setString(paramIndex++, "%" + keyword + "%");
                statement.setString(paramIndex++, "%" + keyword + "%");
            }

            // Set parameter for role filter
            if (role != null && !role.trim().isEmpty()) {
                statement.setString(paramIndex++, role);
            }

            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                users.add(mapResultSetToUser(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Pagination: List users with pagination
    public List<User> listUsersWithPagination(int page, int pageSize) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE isDeleted = 0 ORDER BY userID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, (page - 1) * pageSize);
            statement.setInt(2, pageSize);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                users.add(mapResultSetToUser(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
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

    // Main method to test new features
    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();

        // Testing pagination
        System.out.println("=== Testing Pagination ===");
        List<User> paginatedUsers = userDAO.listUsersWithPagination(1, 3);
        for (User user : paginatedUsers) {
            System.out.println(user);
        }

        // Testing profile picture update
        System.out.println("\n=== Testing Profile Picture Update ===");
        boolean updated = userDAO.updateProfilePicture(1, "http://example.com/profile.jpg");
        System.out.println("Update Successful: " + updated);
    }
}