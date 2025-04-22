# SWP391_BL5_G3
Demo query phân biệt Customers và Employees

-- Lấy thông tin người dùng và xác định họ là nhân viên hay khách hàng
```
SELECT 
    u.UserID,
    u.Username,
    u.FullName,
    CASE 
        WHEN e.EmployeeID IS NOT NULL THEN 'Nhân viên' 
        WHEN c.CustomerID IS NOT NULL THEN 'Khách hàng'
        ELSE 'Không xác định' 
    END AS UserType,
    e.EmployeeRole
FROM Users u
LEFT JOIN Employees e ON u.UserID = e.EmployeeID
LEFT JOIN Customers c ON u.UserID = c.CustomerID
WHERE u.IsDeleted = 0
```

-- Demo UsersDAO

```
public List<UserDetails> getAllUsers() {
    List<UserDetails> users = new ArrayList<>();
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    try {
        conn = getConnection();
        String sql = "SELECT u.UserID, u.Username, u.FullName, u.Email " +
                     "FROM Users u WHERE u.IsDeleted = 0";
        
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
        
        while (rs.next()) {
            UserDetails user = new UserDetails();
            int userId = rs.getInt("UserID");
            user.setUserId(userId);
            user.setUsername(rs.getString("Username"));
            user.setFullName(rs.getString("FullName"));
            user.setEmail(rs.getString("Email"));
            
            // Kiểm tra người dùng là nhân viên hay khách hàng
            if (isEmployee(userId)) {
                user.setUserType("Nhân viên");
                user.setEmployeeRole(getEmployeeRole(userId));
            } else if (isCustomer(userId)) {
                user.setUserType("Khách hàng");
            }
            
            users.add(user);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        closeResources(conn, stmt, rs);
    }
    
    return users;
}

private boolean isEmployee(int userId) {
    // Kiểm tra trong bảng Employees
}

private boolean isCustomer(int userId) {
    // Kiểm tra trong bảng Customers
}

private String getEmployeeRole(int userId) {
    // Lấy vai trò nhân viên
}
```
