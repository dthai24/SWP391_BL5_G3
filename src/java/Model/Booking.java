package Model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Booking {
    private int bookingID;
    private int customerID;
    private Date checkInDate;
    private Date checkOutDate;
    private int numberOfGuests;
    private String notes;
    private BigDecimal totalPrice;
    private String status;
    private Date bookingDate;
    private Date updatedAt;
    private boolean isDeleted;
    
    // For relationships
    private User customer;
    private List<BookingRoom> bookingRooms;
    private List<BookingService> bookingServices;
    private List<Payment> payments;
    
    // Constructors
    public Booking() {
    }

    public Booking(int bookingID, int customerID, Date checkInDate, Date checkOutDate,
                  int numberOfGuests, String notes, BigDecimal totalPrice, String status,
                  Date bookingDate, Date updatedAt, boolean isDeleted) {
        this.bookingID = bookingID;
        this.customerID = customerID;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.numberOfGuests = numberOfGuests;
        this.notes = notes;
        this.totalPrice = totalPrice;
        this.status = status;
        this.bookingDate = bookingDate;
        this.updatedAt = updatedAt;
        this.isDeleted = isDeleted;
    }
    
    // Getters and Setters
    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public Date getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(Date checkInDate) {
        this.checkInDate = checkInDate;
    }

    public Date getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(Date checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public int getNumberOfGuests() {
        return numberOfGuests;
    }

    public void setNumberOfGuests(int numberOfGuests) {
        this.numberOfGuests = numberOfGuests;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }
    
    public User getCustomer() {
        return customer;
    }

    public void setCustomer(User customer) {
        this.customer = customer;
    }

    public List<BookingRoom> getBookingRooms() {
        return bookingRooms;
    }

    public void setBookingRooms(List<BookingRoom> bookingRooms) {
        this.bookingRooms = bookingRooms;
    }

    public List<BookingService> getBookingServices() {
        return bookingServices;
    }

    public void setBookingServices(List<BookingService> bookingServices) {
        this.bookingServices = bookingServices;
    }

    public List<Payment> getPayments() {
        return payments;
    }

    public void setPayments(List<Payment> payments) {
        this.payments = payments;
    }

    @Override
    public String toString() {
        return "Booking{" +
                "bookingID=" + bookingID +
                ", customerID=" + customerID +
                ", checkInDate=" + checkInDate +
                ", checkOutDate=" + checkOutDate +
                ", numberOfGuests=" + numberOfGuests +
                ", notes='" + notes + '\'' +
                ", totalPrice=" + totalPrice +
                ", status='" + status + '\'' +
                ", bookingDate=" + bookingDate +
                ", updatedAt=" + updatedAt +
                ", isDeleted=" + isDeleted +
                '}';
    }
}