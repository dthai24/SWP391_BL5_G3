package Model;

import java.math.BigDecimal;
import java.util.Date;

public class BookingRoomInventoryCheck {
    private int checkID;
    private int bookingRoomID;
    private int itemID;
    private String checkType;
    private String itemStatus;
    private Integer quantityChecked;
    private BigDecimal chargeApplied;
    private String notes;
    private Integer checkedByUserID;
    private Date checkTimestamp;
    
    // For relationships
    private BookingRoom bookingRoom;
    private InventoryItem item;
    private User checkedByUser;
    
    // Constructors
    public BookingRoomInventoryCheck() {
    }

    public BookingRoomInventoryCheck(int checkID, int bookingRoomID, int itemID, String checkType,
                                    String itemStatus, Integer quantityChecked, BigDecimal chargeApplied,
                                    String notes, Integer checkedByUserID, Date checkTimestamp) {
        this.checkID = checkID;
        this.bookingRoomID = bookingRoomID;
        this.itemID = itemID;
        this.checkType = checkType;
        this.itemStatus = itemStatus;
        this.quantityChecked = quantityChecked;
        this.chargeApplied = chargeApplied;
        this.notes = notes;
        this.checkedByUserID = checkedByUserID;
        this.checkTimestamp = checkTimestamp;
    }
    
    // Getters and Setters
    public int getCheckID() {
        return checkID;
    }

    public void setCheckID(int checkID) {
        this.checkID = checkID;
    }

    public int getBookingRoomID() {
        return bookingRoomID;
    }

    public void setBookingRoomID(int bookingRoomID) {
        this.bookingRoomID = bookingRoomID;
    }

    public int getItemID() {
        return itemID;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public String getCheckType() {
        return checkType;
    }

    public void setCheckType(String checkType) {
        this.checkType = checkType;
    }

    public String getItemStatus() {
        return itemStatus;
    }

    public void setItemStatus(String itemStatus) {
        this.itemStatus = itemStatus;
    }

    public Integer getQuantityChecked() {
        return quantityChecked;
    }

    public void setQuantityChecked(Integer quantityChecked) {
        this.quantityChecked = quantityChecked;
    }

    public BigDecimal getChargeApplied() {
        return chargeApplied;
    }

    public void setChargeApplied(BigDecimal chargeApplied) {
        this.chargeApplied = chargeApplied;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Integer getCheckedByUserID() {
        return checkedByUserID;
    }

    public void setCheckedByUserID(Integer checkedByUserID) {
        this.checkedByUserID = checkedByUserID;
    }

    public Date getCheckTimestamp() {
        return checkTimestamp;
    }

    public void setCheckTimestamp(Date checkTimestamp) {
        this.checkTimestamp = checkTimestamp;
    }
    
    public BookingRoom getBookingRoom() {
        return bookingRoom;
    }

    public void setBookingRoom(BookingRoom bookingRoom) {
        this.bookingRoom = bookingRoom;
    }

    public InventoryItem getItem() {
        return item;
    }

    public void setItem(InventoryItem item) {
        this.item = item;
    }

    public User getCheckedByUser() {
        return checkedByUser;
    }

    public void setCheckedByUser(User checkedByUser) {
        this.checkedByUser = checkedByUser;
    }

    @Override
    public String toString() {
        return "BookingRoomInventoryCheck{" +
                "checkID=" + checkID +
                ", bookingRoomID=" + bookingRoomID +
                ", itemID=" + itemID +
                ", checkType='" + checkType + '\'' +
                ", itemStatus='" + itemStatus + '\'' +
                ", quantityChecked=" + quantityChecked +
                ", chargeApplied=" + chargeApplied +
                ", notes='" + notes + '\'' +
                ", checkedByUserID=" + checkedByUserID +
                ", checkTimestamp=" + checkTimestamp +
                '}';
    }
}