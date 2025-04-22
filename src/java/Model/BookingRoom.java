package Model;

import java.math.BigDecimal;
import java.util.List;

public class BookingRoom {
    private int bookingRoomID;
    private int bookingID;
    private int roomID;
    private BigDecimal priceAtBooking;
    
    // For relationships
    private Booking booking;
    private Room room;
    private List<BookingRoomInventoryCheck> inventoryChecks;
    
    // For display purposes only - doesn't exist in Room object but needed for UI
    private String categoryName;
    
    // Constructors
    public BookingRoom() {
    }

    public BookingRoom(int bookingRoomID, int bookingID, int roomID, BigDecimal priceAtBooking) {
        this.bookingRoomID = bookingRoomID;
        this.bookingID = bookingID;
        this.roomID = roomID;
        this.priceAtBooking = priceAtBooking;
    }
    
    // Getters and Setters
    public int getBookingRoomID() {
        return bookingRoomID;
    }

    public void setBookingRoomID(int bookingRoomID) {
        this.bookingRoomID = bookingRoomID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public BigDecimal getPriceAtBooking() {
        return priceAtBooking;
    }

    public void setPriceAtBooking(BigDecimal priceAtBooking) {
        this.priceAtBooking = priceAtBooking;
    }
    
    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    public List<BookingRoomInventoryCheck> getInventoryChecks() {
        return inventoryChecks;
    }

    public void setInventoryChecks(List<BookingRoomInventoryCheck> inventoryChecks) {
        this.inventoryChecks = inventoryChecks;
    }
    
    // Helper methods to access room properties easily
    public String getRoomNumber() {
        return room != null ? room.getRoomNumber() : null;
    }
    
    public String getVacancyStatus() {
        return room != null ? room.getVacancyStatus() : null;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    @Override
    public String toString() {
        return "BookingRoom{" +
                "bookingRoomID=" + bookingRoomID +
                ", bookingID=" + bookingID +
                ", roomID=" + roomID +
                ", priceAtBooking=" + priceAtBooking +
                '}';
    }
}