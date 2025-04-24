package Model;

public class Employee {
    private int employeeID;
    private String employeeRole;
    private User user; // Reference to User

    // Constructors
    public Employee() {
    }

    public Employee(int employeeID, String employeeRole, User user) {
        this.employeeID = employeeID;
        this.employeeRole = employeeRole;
        this.user = user;
    }

    // Getters and Setters
    public int getEmployeeID() {
        return employeeID;
    }

    public void setEmployeeID(int employeeID) {
        this.employeeID = employeeID;
    }

    public String getEmployeeRole() {
        return employeeRole;
    }

    public void setEmployeeRole(String employeeRole) {
        this.employeeRole = employeeRole;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "employeeID=" + employeeID +
                ", employeeRole='" + employeeRole + '\'' +
                ", user=" + user +
                '}';
    }
}