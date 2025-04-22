package Dal;

import DBContext.DBContext;
import Model.Booking;
import Model.BookingRoom;
import Model.BookingService;
import Model.Room;
import Model.Service;
import Model.User;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class BookingDAO {

    private Connection connection;

    // Constructor to initialize the connection using DBContext
    public BookingDAO() {
        try {
            this.connection = new DBContext().getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Lists all bookings with pagination and optional status filter
     * 
     * @param statusFilter Filter by booking status (optional)
     * @param isDeleted Filter by deletion status (0 = not deleted)
     * @param page Current page (1-based)
     * @param pageSize Number of records per page
     * @return List of bookings with their customer information
     */
    public List<Booking> listBookings(String statusFilter, int isDeleted, int page, int pageSize) {
        List<Booking> bookings = new ArrayList<>();
        
        // Calculate pagination offset
        int offset = (page - 1) * pageSize;
        
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT b.*, u.UserID, u.FullName, u.Email, u.PhoneNumber ")
               .append("FROM Bookings b ")
               .append("JOIN Users u ON b.CustomerID = u.UserID ")
               .append("WHERE b.IsDeleted = ? ");
            
            //status filter
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                sql.append("AND b.Status = ? ");
            }
            
            //order by and pagination
            sql.append("ORDER BY b.BookingDate DESC ")
               .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
            
            ps = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            ps.setInt(paramIndex++, isDeleted);
            
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                ps.setString(paramIndex++, statusFilter);
            }
            
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, pageSize);
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Booking booking = mapBookingFromResultSet(rs);
                
                User customer = new User();
                customer.setUserID(rs.getInt("UserID"));
                customer.setFullName(rs.getString("FullName"));
                customer.setEmail(rs.getString("Email"));
                customer.setPhoneNumber(rs.getString("PhoneNumber"));
                booking.setCustomer(customer);
                
                bookings.add(booking);
            }
        } catch (Exception e) {
            System.err.println("Error in BookingDAO.listBookings: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, rs);
        }
        
        return bookings;
    }
    
    /**
     * Gets the total count of bookings with optional status filter
     * 
     * @param statusFilter Filter by booking status (optional)
     * @param isDeleted Filter by deletion status (0 = not deleted)
     * @return Total count of bookings matching criteria
     */
    public int getBookingCount(String statusFilter, int isDeleted) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(*) as total FROM Bookings WHERE IsDeleted = ? ");
            
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                sql.append("AND Status = ? ");
            }
            
            ps = connection.prepareStatement(sql.toString());
            ps.setInt(1, isDeleted);
            
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                ps.setString(2, statusFilter);
            }
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (Exception e) {
            System.err.println("Error in BookingDAO.getBookingCount: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, rs);
        }
        
        return count;
    }
    
    /**
     * Gets a booking by its ID
     * 
     * @param bookingId The booking ID
     * @return Booking object with associated customer information if found, null otherwise
     */
    public Booking getBookingById(int bookingId) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Booking booking = null;
        
        try {
            String sql = "SELECT b.*, u.UserID, u.FullName, u.Email, u.PhoneNumber, u.Address "
                       + "FROM Bookings b "
                       + "JOIN Users u ON b.CustomerID = u.UserID "
                       + "WHERE b.BookingID = ? AND b.IsDeleted = 0";
            
            ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingId);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                booking = mapBookingFromResultSet(rs);
                
                User customer = new User();
                customer.setUserID(rs.getInt("UserID"));
                customer.setFullName(rs.getString("FullName"));
                customer.setEmail(rs.getString("Email"));
                customer.setPhoneNumber(rs.getString("PhoneNumber"));
                customer.setAddress(rs.getString("Address"));
                booking.setCustomer(customer);
            }
        } catch (Exception e) {
            System.err.println("Error in BookingDAO.getBookingById: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, rs);
        }
        
        return booking;
    }
    
    /**
     * Adds a new booking
     * 
     * @param booking The booking to add
     * @return ID of the newly created booking, or -1 if failed
     */
    public int addBooking(Booking booking) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        int newBookingId = -1;
        
        try {
            String sql = "INSERT INTO Bookings (CustomerID, CheckInDate, CheckOutDate, "
                       + "NumberOfGuests, Notes, TotalPrice, Status, BookingDate, UpdatedAt, IsDeleted) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, booking.getCustomerID());
            ps.setDate(2, new java.sql.Date(booking.getCheckInDate().getTime()));
            ps.setDate(3, new java.sql.Date(booking.getCheckOutDate().getTime()));
            ps.setInt(4, booking.getNumberOfGuests());
            ps.setString(5, booking.getNotes());
            ps.setBigDecimal(6, booking.getTotalPrice());
            ps.setString(7, booking.getStatus());
            ps.setTimestamp(8, new Timestamp(booking.getBookingDate().getTime()));
            ps.setTimestamp(9, new Timestamp(booking.getUpdatedAt().getTime()));
            ps.setBoolean(10, booking.getIsDeleted());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    newBookingId = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.err.println("Error in BookingDAO.addBooking: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, rs);
        }
        
        return newBookingId;
    }
    
    /**
     * Updates an existing booking
     * 
     * @param booking The booking to update
     * @return true if successful, false otherwise
     */
    public boolean editBooking(Booking booking) {
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            String sql = "UPDATE Bookings SET "
                       + "CustomerID = ?, "
                       + "CheckInDate = ?, "
                       + "CheckOutDate = ?, "
                       + "NumberOfGuests = ?, "
                       + "Notes = ?, "
                       + "Status = ?, "
                       + "UpdatedAt = ? "
                       + "WHERE BookingID = ? AND IsDeleted = 0";
            
            ps = connection.prepareStatement(sql);
            ps.setInt(1, booking.getCustomerID());
            ps.setDate(2, new java.sql.Date(booking.getCheckInDate().getTime()));
            ps.setDate(3, new java.sql.Date(booking.getCheckOutDate().getTime()));
            ps.setInt(4, booking.getNumberOfGuests());
            ps.setString(5, booking.getNotes());
            ps.setString(6, booking.getStatus());
            ps.setTimestamp(7, new Timestamp(booking.getUpdatedAt().getTime()));
            ps.setInt(8, booking.getBookingID());
            
            int affectedRows = ps.executeUpdate();
            success = (affectedRows > 0);
        } catch (Exception e) {
            System.err.println("Error in BookingDAO.editBooking: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, null);
        }
        
        return success;
    }
    
    /**
     * Soft deletes a booking by marking it as deleted
     * 
     * @param bookingId The ID of the booking to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteBooking(int bookingId) {
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            // Soft delete - just mark as deleted
            String sql = "UPDATE Bookings SET IsDeleted = 1, UpdatedAt = ? WHERE BookingID = ?";
            
            ps = connection.prepareStatement(sql);
            ps.setTimestamp(1, new Timestamp(new Date().getTime()));
            ps.setInt(2, bookingId);
            
            int affectedRows = ps.executeUpdate();
            success = (affectedRows > 0);
        } catch (Exception e) {
            System.err.println("Error in BookingDAO.deleteBooking: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, null);
        }
        
        return success;
    }
    
    /**
     * Gets a list of rooms assigned to a booking
     * 
     * @param bookingId The ID of the booking
     * @return List of BookingRoom objects with their associated Room objects
     */
    public List<BookingRoom> getRoomsForBooking(int bookingId) {
        List<BookingRoom> bookingRooms = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT br.*, r.RoomNumber, r.VacancyStatus, r.CategoryID, rc.CategoryName " +
                        "FROM BookingRooms br " +
                        "JOIN Rooms r ON br.RoomID = r.RoomID " +
                        "JOIN RoomCategories rc ON r.CategoryID = rc.CategoryID " +
                        "WHERE br.BookingID = ?";
            
            ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingId);
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                BookingRoom bookingRoom = new BookingRoom();
                bookingRoom.setBookingRoomID(rs.getInt("BookingRoomID"));
                bookingRoom.setBookingID(rs.getInt("BookingID"));
                bookingRoom.setRoomID(rs.getInt("RoomID"));
                bookingRoom.setPriceAtBooking(rs.getBigDecimal("PriceAtBooking"));
                
                // Create and set the Room object
                Room room = new Room();
                room.setRoomID(rs.getInt("RoomID"));
                room.setRoomNumber(rs.getString("RoomNumber"));
                room.setVacancyStatus(rs.getString("VacancyStatus"));
                room.setCategoryID(rs.getInt("CategoryID"));
                bookingRoom.setRoom(room);
                
                // Store category name - we'll add this field to BookingRoom.java
                bookingRoom.setCategoryName(rs.getString("CategoryName"));
                
                bookingRooms.add(bookingRoom);
            }
        } catch (Exception e) {
            System.err.println("Error in BookingDAO.getRoomsForBooking: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, rs);
        }
        
        return bookingRooms;
    }
    
    /**
     * Gets a list of services assigned to a booking
     * 
     * @param bookingId The ID of the booking
     * @return List of BookingService objects with their associated Service objects
     */
    public List<BookingService> getServicesForBooking(int bookingId) {
        List<BookingService> bookingServices = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT bs.*, s.* " +
                        "FROM BookingServices bs " +
                        "JOIN Services s ON bs.ServiceID = s.ServiceID " +
                        "WHERE bs.BookingID = ?";
            
            ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingId);
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                // Create BookingService object
                BookingService bookingService = new BookingService();
                bookingService.setBookingServiceID(rs.getInt("BookingServiceID"));
                bookingService.setBookingID(rs.getInt("BookingID"));
                bookingService.setServiceID(rs.getInt("ServiceID"));
                bookingService.setQuantity(rs.getInt("Quantity"));
                bookingService.setPriceAtBooking(rs.getBigDecimal("PriceAtBooking"));
                bookingService.setServiceDate(rs.getTimestamp("ServiceDate"));
                
                // Create and set the Service object
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
                
                // Set the relationship
                bookingService.setService(service);
                
                bookingServices.add(bookingService);
            }
        } catch (Exception e) {
            System.err.println("Error in BookingDAO.getServicesForBooking: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, rs);
        }
        
        return bookingServices;
    }
    
    /**
     * Adds a room to a booking
     * 
     * @param bookingId The booking ID
     * @param roomId The room ID
     * @param priceAtBooking The price at the time of booking
     * @return true if successful, false otherwise
     */
    public boolean addRoomToBooking(int bookingId, int roomId, BigDecimal priceAtBooking) {
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            // First check if this room is already assigned to this booking
            String checkSql = "SELECT COUNT(*) AS roomCount FROM BookingRooms WHERE BookingID = ? AND RoomID = ?";
            try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
                checkPs.setInt(1, bookingId);
                checkPs.setInt(2, roomId);
                try (ResultSet checkRs = checkPs.executeQuery()) {
                    if (checkRs.next() && checkRs.getInt("roomCount") > 0) {
                        // Room already assigned to this booking
                        return false;
                    }
                }
            }
            
            // Add room to booking
            String sql = "INSERT INTO BookingRooms (BookingID, RoomID, PriceAtBooking) VALUES (?, ?, ?)";
            
            ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setInt(2, roomId);
            ps.setBigDecimal(3, priceAtBooking);
            
            int affectedRows = ps.executeUpdate();
            success = (affectedRows > 0);
            
            if (success) {
                // Optionally update the room's vacancy status to 'Occupied'
                // This depends on your business logic
                updateRoomStatus(roomId, "Occupied");
            }
        } catch (Exception e) {
            System.err.println("Error in BookingDAO.addRoomToBooking: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, null);
        }
        
        return success;
    }
    
    /**
     * Removes a room from a booking
     * 
     * @param bookingRoomId The booking-room relationship ID
     * @return true if successful, false otherwise
     */
    public boolean removeRoomFromBooking(int bookingRoomId) {
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            // Get the room ID first to update its status later
            int roomId = -1;
            String getRoomIdSql = "SELECT RoomID FROM BookingRooms WHERE BookingRoomID = ?";
            try (PreparedStatement getRoomIdPs = connection.prepareStatement(getRoomIdSql)) {
                getRoomIdPs.setInt(1, bookingRoomId);
                try (ResultSet rs = getRoomIdPs.executeQuery()) {
                    if (rs.next()) {
                        roomId = rs.getInt("RoomID");
                    }
                }
            }
            
            // Remove room from booking
            String sql = "DELETE FROM BookingRooms WHERE BookingRoomID = ?";
            
            ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingRoomId);
            
            int affectedRows = ps.executeUpdate();
            success = (affectedRows > 0);
            
            if (success && roomId != -1) {
                // Update the room's vacancy status back to 'Vacant'
                updateRoomStatus(roomId, "Vacant");
            }
        } catch (Exception e) {
            System.err.println("Error in BookingDAO.removeRoomFromBooking: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, null);
        }
        
        return success;
    }
    
    /**
     * Adds a service to a booking
     * 
     * @param bookingId The booking ID
     * @param serviceId The service ID
     * @param quantity The quantity of the service
     * @param priceAtBooking The price at the time of booking
     * @param serviceDate The date the service is to be provided
     * @return true if successful, false otherwise
     */
    public boolean addServiceToBooking(int bookingId, int serviceId, int quantity, 
                                      BigDecimal priceAtBooking, Date serviceDate) {
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            String sql = "INSERT INTO BookingServices "
                       + "(BookingID, ServiceID, Quantity, PriceAtBooking, ServiceDate) "
                       + "VALUES (?, ?, ?, ?, ?)";
            
            ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setInt(2, serviceId);
            ps.setInt(3, quantity);
            ps.setBigDecimal(4, priceAtBooking);
            ps.setTimestamp(5, new Timestamp(serviceDate.getTime()));
            
            int affectedRows = ps.executeUpdate();
            success = (affectedRows > 0);
        } catch (Exception e) {
            System.err.println("Error in BookingDAO.addServiceToBooking: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, null);
        }
        
        return success;
    }
    
    /**
     * Removes a service from a booking
     * 
     * @param bookingServiceId The booking-service relationship ID
     * @return true if successful, false otherwise
     */
    public boolean removeServiceFromBooking(int bookingServiceId) {
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            String sql = "DELETE FROM BookingServices WHERE BookingServiceID = ?";
            
            ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingServiceId);
            
            int affectedRows = ps.executeUpdate();
            success = (affectedRows > 0);
        } catch (Exception e) {
            System.err.println("Error in BookingDAO.removeServiceFromBooking: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, null);
        }
        
        return success;
    }
    
    /**
     * Recalculates the total price of a booking based on assigned rooms and services
     * 
     * @param bookingId The booking ID
     * @return true if successful, false otherwise
     */
    public boolean recalculateBookingTotal(int bookingId) {
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            // Calculate total from rooms
            BigDecimal roomTotal = BigDecimal.ZERO;
            String roomsSql = "SELECT COALESCE(SUM(PriceAtBooking), 0) AS roomTotal " +
                             "FROM BookingRooms WHERE BookingID = ?";
            
            try (PreparedStatement roomsPs = connection.prepareStatement(roomsSql)) {
                roomsPs.setInt(1, bookingId);
                try (ResultSet rsRooms = roomsPs.executeQuery()) {
                    if (rsRooms.next()) {
                        roomTotal = rsRooms.getBigDecimal("roomTotal");
                    }
                }
            }
            
            // Calculate total from services
            BigDecimal serviceTotal = BigDecimal.ZERO;
            String servicesSql = "SELECT COALESCE(SUM(PriceAtBooking * Quantity), 0) AS serviceTotal " +
                                "FROM BookingServices WHERE BookingID = ?";
            
            try (PreparedStatement servicesPs = connection.prepareStatement(servicesSql)) {
                servicesPs.setInt(1, bookingId);
                try (ResultSet rsServices = servicesPs.executeQuery()) {
                    if (rsServices.next()) {
                        serviceTotal = rsServices.getBigDecimal("serviceTotal");
                    }
                }
            }
            
            // Calculate duration in days
            int durationDays = 1; // Default to 1 day
            String durationSql = "SELECT DATEDIFF(day, CheckInDate, CheckOutDate) AS durationDays " +
                               "FROM Bookings WHERE BookingID = ?";
            
            try (PreparedStatement durationPs = connection.prepareStatement(durationSql)) {
                durationPs.setInt(1, bookingId);
                try (ResultSet rsDuration = durationPs.executeQuery()) {
                    if (rsDuration.next()) {
                        durationDays = rsDuration.getInt("durationDays");
                        if (durationDays < 1) durationDays = 1; // Minimum 1 day
                    }
                }
            }
            
            // Calculate grand total
            // Rooms are charged per night (duration)
            BigDecimal grandTotal = roomTotal.multiply(new BigDecimal(durationDays)).add(serviceTotal);
            
            // Update the total price in the booking
            String updateSql = "UPDATE Bookings SET TotalPrice = ?, UpdatedAt = ? WHERE BookingID = ?";
            
            ps = connection.prepareStatement(updateSql);
            ps.setBigDecimal(1, grandTotal);
            ps.setTimestamp(2, new Timestamp(new Date().getTime()));
            ps.setInt(3, bookingId);
            
            int affectedRows = ps.executeUpdate();
            success = (affectedRows > 0);
        } catch (Exception e) {
            System.err.println("Error in BookingDAO.recalculateBookingTotal: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, null);
        }
        
        return success;
    }
    
    /**
     * Maps a ResultSet row to a Booking object
     * 
     * @param rs The ResultSet containing booking data
     * @return A populated Booking object
     * @throws SQLException If a database access error occurs
     */
    private Booking mapBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingID(rs.getInt("BookingID"));
        booking.setCustomerID(rs.getInt("CustomerID"));
        booking.setCheckInDate(rs.getDate("CheckInDate"));
        booking.setCheckOutDate(rs.getDate("CheckOutDate"));
        booking.setNumberOfGuests(rs.getInt("NumberOfGuests"));
        booking.setNotes(rs.getString("Notes"));
        booking.setTotalPrice(rs.getBigDecimal("TotalPrice"));
        booking.setStatus(rs.getString("Status"));
        booking.setBookingDate(rs.getTimestamp("BookingDate"));
        booking.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        booking.setIsDeleted(rs.getBoolean("IsDeleted"));
        return booking;
    }
    
    /**
     * Updates the vacancy status of a room
     * 
     * @param roomId The ID of the room
     * @param status The new vacancy status ('Vacant' or 'Occupied')
     * @throws SQLException If a database access error occurs
     */
    private void updateRoomStatus(int roomId, String status) throws SQLException {
        String sql = "UPDATE Rooms SET VacancyStatus = ? WHERE RoomID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, roomId);
            ps.executeUpdate();
        }
    }
    
    /**
     * Get the base price for a room category (helper method for the BookingManagementServlet)
     * 
     * @param categoryId The room category ID
     * @return The base price per night for that category
     */
    public BigDecimal getRoomCategoryBasePrice(int categoryId) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        BigDecimal basePrice = BigDecimal.ZERO;
        
        try {
            String sql = "SELECT BasePricePerNight FROM RoomCategories WHERE CategoryID = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, categoryId);
            
            rs = ps.executeQuery();
            if (rs.next()) {
                basePrice = rs.getBigDecimal("BasePricePerNight");
            }
        } catch (SQLException e) {
            System.err.println("Error getting room category base price: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(ps, rs);
        }
        
        return basePrice;
    }
    
    /**
     * Closes database resources (PreparedStatement, ResultSet)
     * 
     * @param ps The PreparedStatement to close
     * @param rs The ResultSet to close
     */
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