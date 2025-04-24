package Model;

public class Customer {
    private int customerID;
    private User user; // Reference to User

    // Constructors
    public Customer() {
    }

    public Customer(int customerID, User user) {
        this.customerID = customerID;
        this.user = user;
    }

    // Getters and Setters
    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "Customer{" +
                "customerID=" + customerID +
                ", user=" + user +
                '}';
    }
}