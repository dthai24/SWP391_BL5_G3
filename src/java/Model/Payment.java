package Model;

import java.math.BigDecimal;
import java.util.Date;

public class Payment {
    private int paymentID;
    private int bookingID;
    private BigDecimal amount;
    private String paymentMethod;
    private String paymentStatus;
    private String transactionID;
    private Date paymentDate;
    private Integer processedByUserID;
    
    // For relationships
    private Booking booking;
    private User processedByUser;
    
    // Constructors
    public Payment() {
    }

    public Payment(int paymentID, int bookingID, BigDecimal amount, String paymentMethod,
                  String paymentStatus, String transactionID, Date paymentDate,
                  Integer processedByUserID) {
        this.paymentID = paymentID;
        this.bookingID = bookingID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.transactionID = transactionID;
        this.paymentDate = paymentDate;
        this.processedByUserID = processedByUserID;
    }
    
    // Getters and Setters
    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getTransactionID() {
        return transactionID;
    }

    public void setTransactionID(String transactionID) {
        this.transactionID = transactionID;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public Integer getProcessedByUserID() {
        return processedByUserID;
    }

    public void setProcessedByUserID(Integer processedByUserID) {
        this.processedByUserID = processedByUserID;
    }
    
    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public User getProcessedByUser() {
        return processedByUser;
    }

    public void setProcessedByUser(User processedByUser) {
        this.processedByUser = processedByUser;
    }

    @Override
    public String toString() {
        return "Payment{" +
                "paymentID=" + paymentID +
                ", bookingID=" + bookingID +
                ", amount=" + amount +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", transactionID='" + transactionID + '\'' +
                ", paymentDate=" + paymentDate +
                ", processedByUserID=" + processedByUserID +
                '}';
    }
}