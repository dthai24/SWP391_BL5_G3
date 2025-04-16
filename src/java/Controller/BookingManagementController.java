package Controller;

import Dal.BookingDAO;
import Dal.RoomDAO;
import Dal.UserDAO;
import Dal.ServiceDAO;
import Model.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BookingManagement", urlPatterns = {"/staff/booking/*"})
public class BookingManagementController extends HttpServlet {
    
    private BookingDAO bookingDAO;
    private RoomDAO roomDAO;
    private UserDAO userDAO;
    private ServiceDAO serviceDAO;
    
    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        roomDAO = new RoomDAO();
        userDAO = new UserDAO();
        serviceDAO = new ServiceDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the path after /staff/booking/
        String pathInfo = request.getPathInfo();
        
        // Check for user authentication and authorization
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Only allow staff roles to access this controller
        String role = loggedInUser.getRole();
        if (!role.equals("Staff") && !role.equals("Manager") && !role.equals("Receptionist") && !role.equals("Admin")) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return;
        }
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Booking list page
            listBookings(request, response);
        } else if (pathInfo.equals("/create")) {
            // Create booking form
            showCreateForm(request, response);
        } else if (pathInfo.equals("/edit") && request.getParameter("id") != null) {
            // Edit booking form
            showEditForm(request, response);
        } else if (pathInfo.equals("/view") && request.getParameter("id") != null) {
            // View booking details
            viewBookingDetails(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        // Check for user authentication and authorization
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Only allow staff roles to access this controller
        String role = loggedInUser.getRole();
        if (!role.equals("Staff") && !role.equals("Manager") && !role.equals("Receptionist") && !role.equals("Admin")) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return;
        }
        
        if (pathInfo.equals("/create")) {
            // Handle create booking submission
            createBooking(request, response);
        } else if (pathInfo.equals("/edit")) {
            // Handle edit booking submission
            updateBooking(request, response);
        } else if (pathInfo.equals("/delete")) {
            // Handle booking deletion
            deleteBooking(request, response);
        } else if (pathInfo.equals("/change-status")) {
            // Handle booking status change
            changeBookingStatus(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void listBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get search parameters
        String searchTerm = request.getParameter("search");
        String status = request.getParameter("status");
        
        // Pagination parameters
        int page = 1;
        int pageSize = 10; // Records per page
        
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                // If not a valid number, default to page 1
                page = 1;
            }
        }
        
        // Get bookings for the current page
        List<Booking> bookings = bookingDAO.getAllBookings(page, pageSize, searchTerm, status);
        
        // Get total bookings count for pagination
        int totalBookings = bookingDAO.getTotalBookings(searchTerm, status);
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
        
        // Set attributes for the JSP
        request.setAttribute("bookings", bookings);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("status", status);
        
        // Get all available statuses for filter dropdown
        List<String> statusOptions = Arrays.asList("Pending", "Confirmed", "Cancelled", "Completed");
        request.setAttribute("statusOptions", statusOptions);
        
        // Forward to the bookings list JSP
        request.getRequestDispatcher("/WEB-INF/views/staff/booking/list.jsp")
               .forward(request, response);
    }
    
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get all available rooms that are vacant
        List<Room> availableRooms = roomDAO.getAvailableRooms();
        
        // Get all customers for customer selection
        List<User> customers = userDAO.getCustomers();
        
        // Get all available services
        List<Service> services = serviceDAO.getAvailableServices();
        
        // Set attributes for JSP
        request.setAttribute("availableRooms", availableRooms);
        request.setAttribute("customers", customers);
        request.setAttribute("services", services);
        
        // Set default dates (today and tomorrow)
        Calendar calendar = Calendar.getInstance();
        Date today = calendar.getTime();
        
        calendar.add(Calendar.DAY_OF_MONTH, 1);
        Date tomorrow = calendar.getTime();
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        request.setAttribute("defaultCheckIn", dateFormat.format(today));
        request.setAttribute("defaultCheckOut", dateFormat.format(tomorrow));
        
        // Forward to the create booking JSP
        request.getRequestDispatcher("/WEB-INF/views/staff/booking/create.jsp")
               .forward(request, response);
    }
    
    private void createBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Parse booking data from the form
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date checkInDate = dateFormat.parse(request.getParameter("checkInDate"));
            Date checkOutDate = dateFormat.parse(request.getParameter("checkOutDate"));
            
            int numberOfGuests = Integer.parseInt(request.getParameter("numberOfGuests"));
            String notes = request.getParameter("notes");
            String status = request.getParameter("status");
            
            // Get selected room IDs
            String[] roomIdStrings = request.getParameterValues("roomIds");
            List<Integer> roomIds = new ArrayList<>();
            if (roomIdStrings != null) {
                for (String idStr : roomIdStrings) {
                    roomIds.add(Integer.parseInt(idStr));
                }
            }
            
            // Calculate total price based on room prices and stay duration
            BigDecimal totalPrice = calculateTotalPrice(roomIds, checkInDate, checkOutDate);
            
            // Handle services
            List<BookingService> services = new ArrayList<>();
            String[] serviceIds = request.getParameterValues("serviceIds");
            if (serviceIds != null) {
                for (String serviceId : serviceIds) {
                    int id = Integer.parseInt(serviceId);
                    int quantity = Integer.parseInt(request.getParameter("serviceQuantity_" + id));
                    
                    if (quantity > 0) {
                        Service service = serviceDAO.getServiceById(id);
                        
                        BookingService bookingService = new BookingService();
                        bookingService.setServiceID(id);
                        bookingService.setQuantity(quantity);
                        bookingService.setPriceAtBooking(service.getPrice());
                        
                        // Add service cost to total price
                        totalPrice = totalPrice.add(service.getPrice().multiply(new BigDecimal(quantity)));
                        
                        services.add(bookingService);
                    }
                }
            }
            
            // Create new booking
            Booking booking = new Booking();
            booking.setCustomerID(customerId);
            booking.setCheckInDate(checkInDate);
            booking.setCheckOutDate(checkOutDate);
            booking.setNumberOfGuests(numberOfGuests);
            booking.setNotes(notes);
            booking.setTotalPrice(totalPrice);
            booking.setStatus(status);
            
            // Save booking to database
            boolean success = bookingDAO.createBooking(booking, roomIds, services);
            
            if (success) {
                // Set success message and redirect to booking list
                request.getSession().setAttribute("successMessage", "Booking created successfully.");
                response.sendRedirect(request.getContextPath() + "/staff/booking");
            } else {
                // Set error message and return to form
                request.setAttribute("errorMessage", "Failed to create booking. Please try again.");
                showCreateForm(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            showCreateForm(request, response);
        }
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int bookingId = Integer.parseInt(request.getParameter("id"));
            
            // Get booking details
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                // Booking not found, redirect to list
                request.getSession().setAttribute("errorMessage", "Booking not found.");
                response.sendRedirect(request.getContextPath() + "/staff/booking");
                return;
            }
            
            // Get current rooms
            List<BookingRoom> bookingRooms = booking.getBookingRooms();
            List<Integer> currentRoomIds = new ArrayList<>();
            for (BookingRoom bookingRoom : bookingRooms) {
                currentRoomIds.add(bookingRoom.getRoomID());
            }
            
            // Get all vacant rooms and currently used rooms for this booking
            List<Room> availableRooms = roomDAO.getAvailableRoomsForEdit(bookingId);
            
            // Get all customers
            List<User> customers = userDAO.getCustomers();
            
            // Get all services and booking services
            List<Service> allServices = serviceDAO.getAvailableServices();
            List<BookingService> bookingServices = booking.getBookingServices();
            
            // Format dates for form
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String checkInDateStr = dateFormat.format(booking.getCheckInDate());
            String checkOutDateStr = dateFormat.format(booking.getCheckOutDate());
            
            // Set attributes for JSP
            request.setAttribute("booking", booking);
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("currentRoomIds", currentRoomIds);
            request.setAttribute("customers", customers);
            request.setAttribute("allServices", allServices);
            request.setAttribute("bookingServices", bookingServices);
            request.setAttribute("checkInDateStr", checkInDateStr);
            request.setAttribute("checkOutDateStr", checkOutDateStr);
            
            // Forward to edit JSP
            request.getRequestDispatcher("/WEB-INF/views/staff/booking/edit.jsp")
                   .forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/booking");
        }
    }
    
    private void updateBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date checkInDate = dateFormat.parse(request.getParameter("checkInDate"));
            Date checkOutDate = dateFormat.parse(request.getParameter("checkOutDate"));
            
            int numberOfGuests = Integer.parseInt(request.getParameter("numberOfGuests"));
            String notes = request.getParameter("notes");
            String status = request.getParameter("status");
            
            // Get selected room IDs
            String[] roomIdStrings = request.getParameterValues("roomIds");
            List<Integer> roomIds = new ArrayList<>();
            if (roomIdStrings != null) {
                for (String idStr : roomIdStrings) {
                    roomIds.add(Integer.parseInt(idStr));
                }
            }
            
            // Calculate total price
            BigDecimal totalPrice = calculateTotalPrice(roomIds, checkInDate, checkOutDate);
            
            // Create booking object
            Booking booking = new Booking();
            booking.setBookingID(bookingId);
            booking.setCustomerID(customerId);
            booking.setCheckInDate(checkInDate);
            booking.setCheckOutDate(checkOutDate);
            booking.setNumberOfGuests(numberOfGuests);
            booking.setNotes(notes);
            booking.setTotalPrice(totalPrice);
            booking.setStatus(status);
            
            // Update booking
            boolean success = bookingDAO.updateBooking(booking, roomIds);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Booking updated successfully.");
                response.sendRedirect(request.getContextPath() + "/staff/booking");
            } else {
                request.setAttribute("errorMessage", "Failed to update booking. Please try again.");
                showEditForm(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            showEditForm(request, response);
        }
    }
    
    private void viewBookingDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int bookingId = Integer.parseInt(request.getParameter("id"));
            
            // Get booking with all related information
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                request.getSession().setAttribute("errorMessage", "Booking not found.");
                response.sendRedirect(request.getContextPath() + "/staff/booking");
                return;
            }
            
            // Set attributes for JSP
            request.setAttribute("booking", booking);
            
            // Forward to details JSP
            request.getRequestDispatcher("/WEB-INF/views/staff/booking/details.jsp")
                   .forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/booking");
        }
    }
    
    private void deleteBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int bookingId = Integer.parseInt(request.getParameter("id"));
            
            boolean success = bookingDAO.deleteBooking(bookingId);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Booking deleted successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete booking.");
            }
            
            response.sendRedirect(request.getContextPath() + "/staff/booking");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/booking");
        }
    }
    
    private void changeBookingStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int bookingId = Integer.parseInt(request.getParameter("id"));
            String newStatus = request.getParameter("status");
            
            boolean success = bookingDAO.updateBookingStatus(bookingId, newStatus);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Booking status updated successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update booking status.");
            }
            
            // Redirect back to the calling page
            String referer = request.getHeader("Referer");
            if (referer != null) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/booking");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/booking");
        }
    }
    
    private BigDecimal calculateTotalPrice(List<Integer> roomIds, Date checkInDate, Date checkOutDate) {
        BigDecimal totalPrice = BigDecimal.ZERO;
        
        // Calculate number of days
        long diffInMillies = checkOutDate.getTime() - checkInDate.getTime();
        long diffInDays = diffInMillies / (24 * 60 * 60 * 1000);
        
        // Get room prices and multiply by days
        for (Integer roomId : roomIds) {
            BigDecimal roomPrice = roomDAO.getRoomPriceById(roomId);
            totalPrice = totalPrice.add(roomPrice.multiply(BigDecimal.valueOf(diffInDays)));
        }
        
        return totalPrice;
    }
}