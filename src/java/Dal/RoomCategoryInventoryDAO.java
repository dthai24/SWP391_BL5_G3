/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dal;

import DBContext.DBContext;
import java.sql.Connection;

/**
 *
 * @author ADMIN
 */
public class RoomCategoryInventoryDAO {
    private Connection connection;
    // Constructor to initialize the connection
    public RoomCategoryInventoryDAO() {
        try {
            DBContext db = new DBContext();
            connection = db.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
}
