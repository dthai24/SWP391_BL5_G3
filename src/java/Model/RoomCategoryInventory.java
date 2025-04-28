package Model;

public class RoomCategoryInventory {
    private int roomCategoryInventoryID;
    private int categoryID;
    private int itemID;
    private int defaultQuantity;
    
    // For relationships
    private RoomCategory category;
    private InventoryItem item;
    
    // Constructors
    public RoomCategoryInventory() {
    }

    public RoomCategoryInventory(int roomCategoryInventoryID, int categoryID, int itemID, int defaultQuantity, RoomCategory category, InventoryItem item) {
        this.roomCategoryInventoryID = roomCategoryInventoryID;
        this.categoryID = categoryID;
        this.itemID = itemID;
        this.defaultQuantity = defaultQuantity;
        this.category = category;
        this.item = item;
    }
    
    // Getters and Setters
    public int getRoomCategoryInventoryID() {
        return roomCategoryInventoryID;
    }

    public void setRoomCategoryInventoryID(int roomCategoryInventoryID) {
        this.roomCategoryInventoryID = roomCategoryInventoryID;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public int getItemID() {
        return itemID;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public int getDefaultQuantity() {
        return defaultQuantity;
    }

    public void setDefaultQuantity(int defaultQuantity) {
        this.defaultQuantity = defaultQuantity;
    }
    
    public RoomCategory getCategory() {
        return category;
    }

    public void setCategory(RoomCategory category) {
        this.category = category;
    }

    public InventoryItem getItem() {
        return item;
    }

    public void setItem(InventoryItem item) {
        this.item = item;
    }

    @Override
    public String toString() {
        return "RoomCategoryInventory{" +
                "roomCategoryInventoryID=" + roomCategoryInventoryID +
                ", categoryID=" + categoryID +
                ", itemID=" + itemID +
                ", defaultQuantity=" + defaultQuantity +
                '}';
    }
}