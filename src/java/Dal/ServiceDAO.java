package Dal;

import DBContext.DBContext;
import Model.Service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {
    
    private Connection connection;

    public ServiceDAO() {
        try {
            this.connection = new DBContext().getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    

    public Service getServiceById(int serviceId) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Service service = null;
        
        try {
            String sql = "SELECT * FROM Services WHERE ServiceID = ? AND IsDeleted = 0";
            
            ps = connection.prepareStatement(sql);
            ps.setInt(1, serviceId);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                service = new Service();
                service.setServiceID(rs.getInt("ServiceID"));
                service.setServiceName(rs.getString("ServiceName"));
                service.setDescription(rs.getString("Description"));
                service.setPrice(rs.getBigDecimal("Price"));
                service.setImageURL(rs.getString("ImageURL"));
                service.setIsAvailable(rs.getBoolean("IsAvailable"));
                service.setCreatedAt(rs.getTimestamp("CreatedAt"));
                service.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                service.setIsDeleted(rs.getBoolean("IsDeleted"));
            }
        } catch (Exception e) {
            System.err.println("Error in ServiceDAO.getServiceById: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, rs);
        }
        
        return service;
    }
    

    public List<Service> listAvailableServices() {
        List<Service> services = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT * FROM Services WHERE IsAvailable = 1 AND IsDeleted = 0 ORDER BY ServiceName";
            
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Service service = new Service();
                service.setServiceID(rs.getInt("ServiceID"));
                service.setServiceName(rs.getString("ServiceName"));
                service.setDescription(rs.getString("Description"));
                service.setPrice(rs.getBigDecimal("Price"));
                service.setImageURL(rs.getString("ImageURL"));
                service.setIsAvailable(rs.getBoolean("IsAvailable"));
                service.setCreatedAt(rs.getTimestamp("CreatedAt"));
                service.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                service.setIsDeleted(rs.getBoolean("IsDeleted"));
                
                services.add(service);
            }
        } catch (Exception e) {
            System.err.println("Error in ServiceDAO.listAvailableServices: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, rs);
        }
        
        return services;
    }
    

    private void closeResources(PreparedStatement ps, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("Error closing ResultSet: " + e.getMessage());
            }
        }
        
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }
    }
}