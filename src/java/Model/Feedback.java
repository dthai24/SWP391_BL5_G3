package Model;

import java.util.Date;

public class Feedback {
    private int feedbackID;
    private Integer bookingID;
    private int customerID;
    private Integer rating;
    private String comment;
    private Date submissionDate;
    private boolean isApproved;
    private String response;
    private Integer respondedByUserID;
    private Date responseDate;
    private boolean isDeleted;
    
    // For relationships
    private Booking booking;
    private User customer;
    private User respondedByUser;
    
    // Constructors
    public Feedback() {
    }

    public Feedback(int feedbackID, Integer bookingID, int customerID, Integer rating,
                   String comment, Date submissionDate, boolean isApproved, String response,
                   Integer respondedByUserID, Date responseDate, boolean isDeleted) {
        this.feedbackID = feedbackID;
        this.bookingID = bookingID;
        this.customerID = customerID;
        this.rating = rating;
        this.comment = comment;
        this.submissionDate = submissionDate;
        this.isApproved = isApproved;
        this.response = response;
        this.respondedByUserID = respondedByUserID;
        this.responseDate = responseDate;
        this.isDeleted = isDeleted;
    }
    
    // Getters and Setters
    public int getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(int feedbackID) {
        this.feedbackID = feedbackID;
    }

    public Integer getBookingID() {
        return bookingID;
    }

    public void setBookingID(Integer bookingID) {
        this.bookingID = bookingID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getSubmissionDate() {
        return submissionDate;
    }

    public void setSubmissionDate(Date submissionDate) {
        this.submissionDate = submissionDate;
    }

    public boolean getIsApproved() {
        return isApproved;
    }

    public void setIsApproved(boolean isApproved) {
        this.isApproved = isApproved;
    }

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }

    public Integer getRespondedByUserID() {
        return respondedByUserID;
    }

    public void setRespondedByUserID(Integer respondedByUserID) {
        this.respondedByUserID = respondedByUserID;
    }

    public Date getResponseDate() {
        return responseDate;
    }

    public void setResponseDate(Date responseDate) {
        this.responseDate = responseDate;
    }

    public boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }
    
    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public User getCustomer() {
        return customer;
    }

    public void setCustomer(User customer) {
        this.customer = customer;
    }

    public User getRespondedByUser() {
        return respondedByUser;
    }

    public void setRespondedByUser(User respondedByUser) {
        this.respondedByUser = respondedByUser;
    }

    @Override
    public String toString() {
        return "Feedback{" +
                "feedbackID=" + feedbackID +
                ", bookingID=" + bookingID +
                ", customerID=" + customerID +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", submissionDate=" + submissionDate +
                ", isApproved=" + isApproved +
                ", response='" + response + '\'' +
                ", respondedByUserID=" + respondedByUserID +
                ", responseDate=" + responseDate +
                ", isDeleted=" + isDeleted +
                '}';
    }
}