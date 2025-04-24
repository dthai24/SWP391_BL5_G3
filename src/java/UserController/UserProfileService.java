/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package UserController;

import Dal.UserDAO;
import Model.User;
public class UserProfileService {
    private UserDAO userDAO;

    public UserProfileService() {
        userDAO = new UserDAO();  // Khởi tạo đối tượng UserDAO
    }

    public User getUserInfo(int userId) {
        // Lấy thông tin người dùng theo ID
        return userDAO.getUserById(userId);
    }
}
