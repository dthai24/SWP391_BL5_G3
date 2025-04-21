package Dal;

import DBContext.DBContext;
import Model.RoomCategory;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RoomCategoryDAO {
    private Connection connection;

    public RoomCategoryDAO() {
        try {
            this.connection = new DBContext().getConnection();
            if (this.connection == null) {
                throw new RuntimeException("Database connection is null. Please check your DBContext configuration and database connectivity.");
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize database connection in RoomCategoryDAO: " + e.getMessage(), e);
        }
    }

    public RoomCategory getRoomCategoryById(int categoryID) {
        String sql = "SELECT * FROM RoomCategories WHERE CategoryID = ? AND IsDeleted = 0";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, categoryID);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                return new RoomCategory(
                    rs.getInt("CategoryID"),
                    rs.getString("CategoryName"),
                    rs.getString("Description"),
                    rs.getBigDecimal("BasePricePerNight"),
                    rs.getBoolean("IsDeleted")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
