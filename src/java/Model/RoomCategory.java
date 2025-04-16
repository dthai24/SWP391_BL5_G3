package Model;

import java.math.BigDecimal;
import java.util.List;

public class RoomCategory {
    private int categoryID;
    private String categoryName;
    private String description;
    private BigDecimal basePricePerNight;
    private boolean isDeleted;
    
    // For relationships
    private List<Room> rooms;
    private List<RoomImage> images;
    
    // Constructors
    public RoomCategory() {
    }

    public RoomCategory(int categoryID, String categoryName, String description, 
                        BigDecimal basePricePerNight, boolean isDeleted) {
        this.categoryID = categoryID;
        this.categoryName = categoryName;
        this.description = description;
        this.basePricePerNight = basePricePerNight;
        this.isDeleted = isDeleted;
    }
    
    // Getters and Setters
    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getBasePricePerNight() {
        return basePricePerNight;
    }

    public void setBasePricePerNight(BigDecimal basePricePerNight) {
        this.basePricePerNight = basePricePerNight;
    }

    public boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }
    
    public List<Room> getRooms() {
        return rooms;
    }

    public void setRooms(List<Room> rooms) {
        this.rooms = rooms;
    }

    public List<RoomImage> getImages() {
        return images;
    }

    public void setImages(List<RoomImage> images) {
        this.images = images;
    }

    @Override
    public String toString() {
        return "RoomCategory{" +
                "categoryID=" + categoryID +
                ", categoryName='" + categoryName + '\'' +
                ", description='" + description + '\'' +
                ", basePricePerNight=" + basePricePerNight +
                ", isDeleted=" + isDeleted +
                '}';
    }
}