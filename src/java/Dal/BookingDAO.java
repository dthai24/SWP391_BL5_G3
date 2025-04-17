package Dal;

import DBContext.DBContext;
import Model.*;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class BookingDAO {
    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    
    // Get all bookings with pagination and filtering
    public List<Booking> getAllBookings(int page, int pageSize, String searchTerm, String status) {
        List<Booking> bookings = new ArrayList<>();
        try {
            conn = new DBContext().getConnection();
            
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT b.*, u.FullName AS CustomerName FROM Bookings b ");
            sql.append("INNER JOIN Users u ON b.CustomerID = u.UserID ");
            sql.append("WHERE b.IsDeleted = 0 ");
            
            // Add filters if provided
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                sql.append("AND (u.FullName LIKE ? OR b.BookingID LIKE ?) ");
            }
            
            if (status != null && !status.trim().isEmpty()) {
                sql.append("AND b.Status = ? ");
            }
            
            sql.append("ORDER BY b.BookingDate DESC ");
            sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
            
            ps = conn.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchTerm + "%");
                ps.setString(paramIndex++, "%" + searchTerm + "%");
            }
            
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Booking booking = mapBooking(rs);
                booking.setCustomer(new User());
                booking.getCustomer().setFullName(rs.getString("CustomerName"));
                bookings.add(booking);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return bookings;
    }
    
    // Get total number of bookings (for pagination)
    public int getTotalBookings(String searchTerm, String status) {
        int count = 0;
        try {
            conn = new DBContext().getConnection();
            
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(*) FROM Bookings b ");
            sql.append("INNER JOIN Users u ON b.CustomerID = u.UserID ");
            sql.append("WHERE b.IsDeleted = 0 ");
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                sql.append("AND (u.FullName LIKE ? OR b.BookingID LIKE ?) ");
            }
            
            if (status != null && !status.trim().isEmpty()) {
                sql.append("AND b.Status = ? ");
            }
            
            ps = conn.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchTerm + "%");
                ps.setString(paramIndex++, "%" + searchTerm + "%");
            }
            
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex, status);
            }
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }
    
    // Get a booking by ID with all related data
    public Booking getBookingById(int bookingId) {
        Booking booking = null;
        try {
            conn = new DBContext().getConnection();
            String sql = "SELECT b.*, u.* FROM Bookings b " +
                         "INNER JOIN Users u ON b.CustomerID = u.UserID " +
                         "WHERE b.BookingID = ? AND b.IsDeleted = 0";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                booking = mapBooking(rs);
                
                User customer = new User();
                customer.setUserID(rs.getInt("UserID"));
                customer.setFullName(rs.getString("FullName"));
                customer.setEmail(rs.getString("Email"));
                customer.setPhoneNumber(rs.getString("PhoneNumber"));
                booking.setCustomer(customer);
                
                // Get booking rooms
                booking.setBookingRooms(getBookingRoomsByBookingId(bookingId));
                
                // Get booking services
                booking.setBookingServices(getBookingServicesByBookingId(bookingId));
                
                // Get payments
                booking.setPayments(getPaymentsByBookingId(bookingId));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return booking;
    }
    
    // Create a new booking
    public boolean createBooking(Booking booking, List<Integer> roomIds, List<BookingService> services) {
        boolean success = false;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Insert booking
            String sql = "INSERT INTO Bookings (CustomerID, CheckInDate, CheckOutDate, " +
                         "NumberOfGuests, Notes, TotalPrice, Status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, booking.getCustomerID());
            ps.setDate(2, new java.sql.Date(booking.getCheckInDate().getTime()));
            ps.setDate(3, new java.sql.Date(booking.getCheckOutDate().getTime()));
            ps.setInt(4, booking.getNumberOfGuests());
            ps.setString(5, booking.getNotes());
            ps.setBigDecimal(6, booking.getTotalPrice());
            ps.setString(7, booking.getStatus());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                // Get generated booking ID
                rs = ps.getGeneratedKeys();
                int bookingId = 0;
                if (rs.next()) {
                    bookingId = rs.getInt(1);
                    booking.setBookingID(bookingId);
                }
                
                // Insert booking rooms
                for (Integer roomId : roomIds) {
                    // Get room price from either the room's price override or its category base price
                    BigDecimal roomPrice = getRoomPriceById(roomId);
                    
                    String roomSql = "INSERT INTO BookingRooms (BookingID, RoomID, PriceAtBooking) VALUES (?, ?, ?)";
                    PreparedStatement roomPs = conn.prepareStatement(roomSql);
                    roomPs.setInt(1, bookingId);
                    roomPs.setInt(2, roomId);
                    roomPs.setBigDecimal(3, roomPrice);
                    roomPs.executeUpdate();
                    roomPs.close();
                    
                    // Update room status to Occupied
                    updateRoomStatus(roomId, "Occupied");
                }
                
                // Insert booking services if any
                if (services != null && !services.isEmpty()) {
                    for (BookingService service : services) {
                        String serviceSql = "INSERT INTO BookingServices (BookingID, ServiceID, Quantity, PriceAtBooking) " +
                                           "VALUES (?, ?, ?, ?)";
                        PreparedStatement servicePs = conn.prepareStatement(serviceSql);
                        servicePs.setInt(1, bookingId);
                        servicePs.setInt(2, service.getServiceID());
                        servicePs.setInt(3, service.getQuantity());
                        servicePs.setBigDecimal(4, service.getPriceAtBooking());
                        servicePs.executeUpdate();
                        servicePs.close();
                    }
                }
                
                conn.commit();
                success = true;
            }
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources();
        }
        return success;
    }
    
    // Update booking status
    public boolean updateBookingStatus(int bookingId, String newStatus) {
        boolean success = false;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);
            
            String sql = "UPDATE Bookings SET Status = ?, UpdatedAt = GETDATE() WHERE BookingID = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, bookingId);
            
            int rowsAffected = ps.executeUpdate();
            
            // If status is Cancelled or Completed, update room status to Vacant
            if (rowsAffected > 0 && (newStatus.equals("Cancelled") || newStatus.equals("Completed"))) {
                String roomSql = "SELECT RoomID FROM BookingRooms WHERE BookingID = ?";
                PreparedStatement roomPs = conn.prepareStatement(roomSql);
                roomPs.setInt(1, bookingId);
                ResultSet roomRs = roomPs.executeQuery();
                
                while (roomRs.next()) {
                    int roomId = roomRs.getInt("RoomID");
                    updateRoomStatus(roomId, "Vacant");
                }
                
                roomRs.close();
                roomPs.close();
            }
            
            conn.commit();
            success = rowsAffected > 0;
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources();
        }
        return success;
    }
    
    // Update existing booking
    public boolean updateBooking(Booking booking, List<Integer> newRoomIds) {
        boolean success = false;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);
            
            // Update booking details
            String sql = "UPDATE Bookings SET CustomerID = ?, CheckInDate = ?, CheckOutDate = ?, " +
                         "NumberOfGuests = ?, Notes = ?, TotalPrice = ?, Status = ?, UpdatedAt = GETDATE() " +
                         "WHERE BookingID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, booking.getCustomerID());
            ps.setDate(2, new java.sql.Date(booking.getCheckInDate().getTime()));
            ps.setDate(3, new java.sql.Date(booking.getCheckOutDate().getTime()));
            ps.setInt(4, booking.getNumberOfGuests());
            ps.setString(5, booking.getNotes());
            ps.setBigDecimal(6, booking.getTotalPrice());
            ps.setString(7, booking.getStatus());
            ps.setInt(8, booking.getBookingID());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                // Get current room IDs
                List<Integer> currentRoomIds = new ArrayList<>();
                String currentRoomsSql = "SELECT RoomID FROM BookingRooms WHERE BookingID = ?";
                PreparedStatement currentRoomsPs = conn.prepareStatement(currentRoomsSql);
                currentRoomsPs.setInt(1, booking.getBookingID());
                ResultSet currentRoomsRs = currentRoomsPs.executeQuery();
                
                while (currentRoomsRs.next()) {
                    currentRoomIds.add(currentRoomsRs.getInt("RoomID"));
                }
                
                currentRoomsRs.close();
                currentRoomsPs.close();
                
                // Rooms to remove
                List<Integer> roomsToRemove = new ArrayList<>(currentRoomIds);
                roomsToRemove.removeAll(newRoomIds);
                
                // Rooms to add
                List<Integer> roomsToAdd = new ArrayList<>(newRoomIds);
                roomsToAdd.removeAll(currentRoomIds);
                
                // Remove rooms
                for (Integer roomId : roomsToRemove) {
                    String removeRoomSql = "DELETE FROM BookingRooms WHERE BookingID = ? AND RoomID = ?";
                    PreparedStatement removeRoomPs = conn.prepareStatement(removeRoomSql);
                    removeRoomPs.setInt(1, booking.getBookingID());
                    removeRoomPs.setInt(2, roomId);
                    removeRoomPs.executeUpdate();
                    removeRoomPs.close();
                    
                    // Update room status to Vacant
                    updateRoomStatus(roomId, "Vacant");
                }
                
                // Add new rooms
                for (Integer roomId : roomsToAdd) {
                    BigDecimal roomPrice = getRoomPriceById(roomId);
                    
                    String addRoomSql = "INSERT INTO BookingRooms (BookingID, RoomID, PriceAtBooking) VALUES (?, ?, ?)";
                    PreparedStatement addRoomPs = conn.prepareStatement(addRoomSql);
                    addRoomPs.setInt(1, booking.getBookingID());
                    addRoomPs.setInt(2, roomId);
                    addRoomPs.setBigDecimal(3, roomPrice);
                    addRoomPs.executeUpdate();
                    addRoomPs.close();
                    
                    // Update room status to Occupied
                    updateRoomStatus(roomId, "Occupied");
                }
                
                conn.commit();
                success = true;
            }
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources();
        }
        return success;
    }
    
    // Delete booking (soft delete)
    public boolean deleteBooking(int bookingId) {
        boolean success = false;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);
            
            // Get room IDs associated with this booking
            List<Integer> roomIds = new ArrayList<>();
            String roomSql = "SELECT RoomID FROM BookingRooms WHERE BookingID = ?";
            PreparedStatement roomPs = conn.prepareStatement(roomSql);
            roomPs.setInt(1, bookingId);
            ResultSet roomRs = roomPs.executeQuery();
            
            while (roomRs.next()) {
                roomIds.add(roomRs.getInt("RoomID"));
            }
            
            roomRs.close();
            roomPs.close();
            
            // Soft delete the booking
            String sql = "UPDATE Bookings SET IsDeleted = 1, UpdatedAt = GETDATE() WHERE BookingID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                // Update room statuses to Vacant
                for (Integer roomId : roomIds) {
                    updateRoomStatus(roomId, "Vacant");
                }
                
                conn.commit();
                success = true;
            }
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources();
        }
        return success;
    }
    
    // Helper methods
    private List<BookingRoom> getBookingRoomsByBookingId(int bookingId) {
        List<BookingRoom> bookingRooms = new ArrayList<>();
        try {
            String sql = "SELECT br.*, r.RoomNumber, r.CategoryID, rc.CategoryName, rc.BasePricePerNight " +
                         "FROM BookingRooms br " +
                         "INNER JOIN Rooms r ON br.RoomID = r.RoomID " +
                         "INNER JOIN RoomCategories rc ON r.CategoryID = rc.CategoryID " +
                         "WHERE br.BookingID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                BookingRoom bookingRoom = new BookingRoom();
                bookingRoom.setBookingRoomID(rs.getInt("BookingRoomID"));
                bookingRoom.setBookingID(rs.getInt("BookingID"));
                bookingRoom.setRoomID(rs.getInt("RoomID"));
                bookingRoom.setPriceAtBooking(rs.getBigDecimal("PriceAtBooking"));
                
                Room room = new Room();
                room.setRoomID(rs.getInt("RoomID"));
                room.setRoomNumber(rs.getString("RoomNumber"));
                room.setCategoryID(rs.getInt("CategoryID"));
                
                RoomCategory category = new RoomCategory();
                category.setCategoryID(rs.getInt("CategoryID"));
                category.setCategoryName(rs.getString("CategoryName"));
                category.setBasePricePerNight(rs.getBigDecimal("BasePricePerNight"));
                
                room.setCategory(category);
                bookingRoom.setRoom(room);
                
                bookingRooms.add(bookingRoom);
            }
            
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookingRooms;
    }
    
    private List<BookingService> getBookingServicesByBookingId(int bookingId) {
        List<BookingService> bookingServices = new ArrayList<>();
        try {
            String sql = "SELECT bs.*, s.ServiceName, s.Price " +
                         "FROM BookingServices bs " +
                         "INNER JOIN Services s ON bs.ServiceID = s.ServiceID " +
                         "WHERE bs.BookingID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                BookingService bookingService = new BookingService();
                bookingService.setBookingServiceID(rs.getInt("BookingServiceID"));
                bookingService.setBookingID(rs.getInt("BookingID"));
                bookingService.setServiceID(rs.getInt("ServiceID"));
                bookingService.setQuantity(rs.getInt("Quantity"));
                bookingService.setPriceAtBooking(rs.getBigDecimal("PriceAtBooking"));
                bookingService.setServiceDate(rs.getTimestamp("ServiceDate"));
                
                Service service = new Service();
                service.setServiceID(rs.getInt("ServiceID"));
                service.setServiceName(rs.getString("ServiceName"));
                service.setPrice(rs.getBigDecimal("Price"));
                
                bookingService.setService(service);
                
                bookingServices.add(bookingService);
            }
            
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookingServices;
    }
    
    private List<Payment> getPaymentsByBookingId(int bookingId) {
        List<Payment> payments = new ArrayList<>();
        try {
            String sql = "SELECT p.*, u.FullName as ProcessedByName " +
                         "FROM Payments p " +
                         "LEFT JOIN Users u ON p.ProcessedByUserID = u.UserID " +
                         "WHERE p.BookingID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentID(rs.getInt("PaymentID"));
                payment.setBookingID(rs.getInt("BookingID"));
                payment.setAmount(rs.getBigDecimal("Amount"));
                payment.setPaymentMethod(rs.getString("PaymentMethod"));
                payment.setPaymentStatus(rs.getString("PaymentStatus"));
                payment.setTransactionID(rs.getString("TransactionID"));
                payment.setPaymentDate(rs.getTimestamp("PaymentDate"));
                
                if (rs.getObject("ProcessedByUserID") != null) {
                    payment.setProcessedByUserID(rs.getInt("ProcessedByUserID"));
                    
                    User processedBy = new User();
                    processedBy.setUserID(rs.getInt("ProcessedByUserID"));
                    processedBy.setFullName(rs.getString("ProcessedByName"));
                    payment.setProcessedBy(processedBy);
                }
                
                payments.add(payment);
            }
            
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return payments;
    }
    
    private BigDecimal getRoomPriceById(int roomId) {
        BigDecimal price = BigDecimal.ZERO;
        try {
            String sql = "SELECT r.PriceOverride, rc.BasePricePerNight " +
                         "FROM Rooms r " +
                         "INNER JOIN RoomCategories rc ON r.CategoryID = rc.CategoryID " +
                         "WHERE r.RoomID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                BigDecimal priceOverride = rs.getBigDecimal("PriceOverride");
                if (priceOverride != null) {
                    price = priceOverride;
                } else {
                    price = rs.getBigDecimal("BasePricePerNight");
                }
            }
            
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return price;
    }
    
    private void updateRoomStatus(int roomId, String status) {
        try {
            String sql = "UPDATE Rooms SET VacancyStatus = ?, UpdatedAt = GETDATE() WHERE RoomID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, roomId);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private Booking mapBooking(ResultSet rs) throws SQLException {
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
    
    private void closeResources() {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}