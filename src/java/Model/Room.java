package Model;

import java.math.BigDecimal;
import java.util.Date;

public class Room {

    private int roomID;
    private String roomNumber;
    private int categoryID;
    private String vacancyStatus;
    private String description;
    private BigDecimal priceOverride;
    private Date createdAt;
    private Date updatedAt;
    private boolean isDeleted;

    // For relationships
    private RoomCategory category;

    // Constructors
    public Room() {
    }

    public Room(int roomID, String roomNumber, int categoryID, String vacancyStatus,
            String description, BigDecimal priceOverride, Date createdAt,
            Date updatedAt, boolean isDeleted) {
        this.roomID = roomID;
        this.roomNumber = roomNumber;
        this.categoryID = categoryID;
        this.vacancyStatus = vacancyStatus;
        this.description = description;
        this.priceOverride = priceOverride;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.isDeleted = isDeleted;
    }

    // Getters and Setters
    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getVacancyStatus() {
        return vacancyStatus;
    }

    public void setVacancyStatus(String vacancyStatus) {
        this.vacancyStatus = vacancyStatus;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPriceOverride() {
        return priceOverride;
    }

    public void setPriceOverride(BigDecimal priceOverride) {
        this.priceOverride = priceOverride;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
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

    public RoomCategory getCategory() {
        return category;
    }

    public void setCategory(RoomCategory category) {
        this.category = category;
    }

    private String categoryName; // For display purposes

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    @Override
    public String toString() {
        return "Room{"
                + "roomID=" + roomID
                + ", roomNumber='" + roomNumber + '\''
                + ", categoryID=" + categoryID
                + ", vacancyStatus='" + vacancyStatus + '\''
                + ", description='" + description + '\''
                + ", priceOverride=" + priceOverride
                + ", createdAt=" + createdAt
                + ", updatedAt=" + updatedAt
                + ", isDeleted=" + isDeleted
                + '}';
    }
}
