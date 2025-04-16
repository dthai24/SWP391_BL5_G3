package Model;

import java.math.BigDecimal;
import java.util.Date;

public class BookingService {
    private int bookingServiceID;
    private int bookingID;
    private int serviceID;
    private int quantity;
    private BigDecimal priceAtBooking;
    private Date serviceDate;
    
    // For relationships
    private Booking booking;
    private Service service;
    
    // Constructors
    public BookingService() {
    }

    public BookingService(int bookingServiceID, int bookingID, int serviceID, int quantity,
                         BigDecimal priceAtBooking, Date serviceDate) {
        this.bookingServiceID = bookingServiceID;
        this.bookingID = bookingID;
        this.serviceID = serviceID;
        this.quantity = quantity;
        this.priceAtBooking = priceAtBooking;
        this.serviceDate = serviceDate;
    }
    
    // Getters and Setters
    public int getBookingServiceID() {
        return bookingServiceID;
    }

    public void setBookingServiceID(int bookingServiceID) {
        this.bookingServiceID = bookingServiceID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPriceAtBooking() {
        return priceAtBooking;
    }

    public void setPriceAtBooking(BigDecimal priceAtBooking) {
        this.priceAtBooking = priceAtBooking;
    }

    public Date getServiceDate() {
        return serviceDate;
    }

    public void setServiceDate(Date serviceDate) {
        this.serviceDate = serviceDate;
    }
    
    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    @Override
    public String toString() {
        return "BookingService{" +
                "bookingServiceID=" + bookingServiceID +
                ", bookingID=" + bookingID +
                ", serviceID=" + serviceID +
                ", quantity=" + quantity +
                ", priceAtBooking=" + priceAtBooking +
                ", serviceDate=" + serviceDate +
                '}';
    }
}