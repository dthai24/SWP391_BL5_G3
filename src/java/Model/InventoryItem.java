package Model;

import java.math.BigDecimal;

public class InventoryItem {
    private int itemID;
    private String itemName;
    private String description;
    private BigDecimal defaultCharge;
    private boolean isDeleted;
    
    // Constructors
    public InventoryItem() {
    }

    public InventoryItem(int itemID, String itemName, String description, 
                         BigDecimal defaultCharge, boolean isDeleted) {
        this.itemID = itemID;
        this.itemName = itemName;
        this.description = description;
        this.defaultCharge = defaultCharge;
        this.isDeleted = isDeleted;
    }
    
    // Getters and Setters
    public int getItemID() {
        return itemID;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getDefaultCharge() {
        return defaultCharge;
    }

    public void setDefaultCharge(BigDecimal defaultCharge) {
        this.defaultCharge = defaultCharge;
    }

    public boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    @Override
    public String toString() {
        return "InventoryItem{" +
                "itemID=" + itemID +
                ", itemName='" + itemName + '\'' +
                ", description='" + description + '\'' +
                ", defaultCharge=" + defaultCharge +
                ", isDeleted=" + isDeleted +
                '}';
    }
}