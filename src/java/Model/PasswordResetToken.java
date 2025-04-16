package Model;

import java.util.Date;

public class PasswordResetToken {
    private int tokenID;
    private int userID;
    private String tokenValue;
    private Date expiryDate;
    private boolean isUsed;
    private Date createdAt;
    
    // For relationships
    private User user;
    
    // Constructors
    public PasswordResetToken() {
    }

    public PasswordResetToken(int tokenID, int userID, String tokenValue, Date expiryDate,
                             boolean isUsed, Date createdAt) {
        this.tokenID = tokenID;
        this.userID = userID;
        this.tokenValue = tokenValue;
        this.expiryDate = expiryDate;
        this.isUsed = isUsed;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getTokenID() {
        return tokenID;
    }

    public void setTokenID(int tokenID) {
        this.tokenID = tokenID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getTokenValue() {
        return tokenValue;
    }

    public void setTokenValue(String tokenValue) {
        this.tokenValue = tokenValue;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public boolean getIsUsed() {
        return isUsed;
    }

    public void setIsUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "PasswordResetToken{" +
                "tokenID=" + tokenID +
                ", userID=" + userID +
                ", tokenValue='" + tokenValue + '\'' +
                ", expiryDate=" + expiryDate +
                ", isUsed=" + isUsed +
                ", createdAt=" + createdAt +
                '}';
    }
}