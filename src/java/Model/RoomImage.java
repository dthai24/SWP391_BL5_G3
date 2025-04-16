package Model;

import java.util.Date;

public class RoomImage {
    private int imageID;
    private int roomCategoryID;
    private String imageUrl;
    private boolean isMain;
    private Date uploadedAt;
    
    // For relationships
    private RoomCategory category;
    
    // Constructors
    public RoomImage() {
    }

    public RoomImage(int imageID, int roomCategoryID, String imageUrl, boolean isMain, Date uploadedAt) {
        this.imageID = imageID;
        this.roomCategoryID = roomCategoryID;
        this.imageUrl = imageUrl;
        this.isMain = isMain;
        this.uploadedAt = uploadedAt;
    }
    
    // Getters and Setters
    public int getImageID() {
        return imageID;
    }

    public void setImageID(int imageID) {
        this.imageID = imageID;
    }

    public int getRoomCategoryID() {
        return roomCategoryID;
    }

    public void setRoomCategoryID(int roomCategoryID) {
        this.roomCategoryID = roomCategoryID;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean getIsMain() {
        return isMain;
    }

    public void setIsMain(boolean isMain) {
        this.isMain = isMain;
    }

    public Date getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Date uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
    
    public RoomCategory getCategory() {
        return category;
    }

    public void setCategory(RoomCategory category) {
        this.category = category;
    }

    @Override
    public String toString() {
        return "RoomImage{" +
                "imageID=" + imageID +
                ", roomCategoryID=" + roomCategoryID +
                ", imageUrl='" + imageUrl + '\'' +
                ", isMain=" + isMain +
                ", uploadedAt=" + uploadedAt +
                '}';
    }
}