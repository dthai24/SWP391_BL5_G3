package Controller;

import Dal.BookingDAO;
import Dal.UserDAO;
import Dal.RoomDAO;
import Dal.ServiceDAO;
import Model.Booking;
import Model.User;
import Model.Room;
import Model.Service;
import Model.BookingRoom;
import Model.BookingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

//@WebServlet(name = "BookingManagementServlet", urlPatterns = {"/manage-bookings"})
public class BookingManagementServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private BookingDAO bookingDAO;
    private UserDAO userDAO;
    private RoomDAO roomDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingDAO = new BookingDAO();
        userDAO = new UserDAO();
        roomDAO = new RoomDAO();
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Check user authentication and authorization
        User currentUser = authenticateAndAuthorize(request, response);
        if (currentUser == null) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        String role = currentUser.getRole();
        boolean isManager = "Manager".equalsIgnoreCase(role);
        boolean canView = isManager || "Staff".equalsIgnoreCase(role) || "Receptionist".equalsIgnoreCase(role);

        if (!canView) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to access this resource.");
            return;
        }

        try {
            switch (action) {
                case "list":
                    listBookings(request, response);
                    break;
                case "view":
                    viewBooking(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteBooking(request, response);
                    break;
                default:
                    listBookings(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, e, "Error processing request: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Check user authentication and authorization
        User currentUser = authenticateAndAuthorize(request, response);
        if (currentUser == null) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
            response.sendRedirect("manage-bookings");
            return;
        }

        String role = currentUser.getRole();
        boolean isManager = "Manager".equalsIgnoreCase(role);

        //Require Manager Role
        if (!isManager) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to perform this action.");
            return;
        }

        try {
            switch (action) {
                case "save":
                    saveBooking(request, response);
                    break;
                case "update":
                    updateBooking(request, response);
                    break;
                case "delete":
                    deleteBooking(request, response);
                    break;
                case "addRoom":
                    addRoomToBooking(request, response);
                    break;
                case "removeRoom":
                    removeRoomFromBooking(request, response);
                    break;
                case "addService":
                    addServiceToBooking(request, response);
                    break;
                case "removeService":
                    removeServiceFromBooking(request, response);
                    break;
                default:
                    response.sendRedirect("manage-bookings");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, e, "Error processing action: " + e.getMessage());
        }
    }

    private User authenticateAndAuthorize(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // Temporary user creation for development - Replace with actual authentication when ready
        if (currentUser == null) {
            currentUser = new User();
            currentUser.setUserID(2);
            currentUser.setRole("Manager");
            session = request.getSession(true);
            session.setAttribute("user", currentUser);
            System.out.println("DEVELOPMENT MODE: Created temporary Manager user with ID 2");
        }

        /* 
        // Uncomment when ready for production
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return null;
        }
         */
        return currentUser;
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            Exception e, String message) throws IOException {
        System.err.println(message);
        e.printStackTrace();
        request.getSession().setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
        response.sendRedirect("manage-bookings");
    }

    //Booking Display Methods
    private void listBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all bookings without pagination for DataTables
            List<Booking> bookings = bookingDAO.getAllBookings();
            request.setAttribute("bookings", bookings);
            
            // Forward to the bookings list page
            request.getRequestDispatcher("/View/Booking/booking-list.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in listBookings: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while retrieving bookings: " + e.getMessage());
            request.getRequestDispatcher("/View/Booking/booking-list.jsp").forward(request, response);
        }
    }

    private void viewBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIdParam = request.getParameter("bookingId");
        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Booking booking = bookingDAO.getBookingById(bookingId);

            if (booking == null) {
                request.getSession().setAttribute("errorMessage", "Booking with ID " + bookingIdParam + " not found.");
                response.sendRedirect("manage-bookings");
                return;
            }

            User customer = userDAO.getUserById(booking.getCustomerID());
            List<BookingRoom> assignedRooms = bookingDAO.getRoomsForBooking(bookingId);
            List<BookingService> assignedServices = bookingDAO.getServicesForBooking(bookingId);

            request.setAttribute("booking", booking);
            request.setAttribute("customer", customer);
            request.setAttribute("assignedRooms", assignedRooms);
            request.setAttribute("assignedServices", assignedServices);

            request.getRequestDispatcher("/View/Booking/view-booking.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid Booking ID format: " + bookingIdParam);
            response.sendRedirect("manage-bookings");
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> customerList = userDAO.searchUsers(null, "Customer", "FullName", "ASC");
        request.setAttribute("customerList", customerList);
        request.getRequestDispatcher("/View/Booking/add-booking.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIdParam = request.getParameter("bookingId");
        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Booking existingBooking = bookingDAO.getBookingById(bookingId);

            if (existingBooking == null) {
                request.getSession().setAttribute("errorMessage", "Booking with ID " + bookingIdParam + " not found.");
                response.sendRedirect("manage-bookings");
                return;
            }

            List<User> customerList = userDAO.searchUsers(null, "Customer", "FullName", "ASC");
            List<BookingRoom> assignedRooms = bookingDAO.getRoomsForBooking(bookingId);
            List<BookingService> assignedServices = bookingDAO.getServicesForBooking(bookingId);
            List<Room> allRoomsWithCategories = roomDAO.getAllRoomsWithCategoryNames();
            List<Service> availableServices = serviceDAO.listAvailableServices();

            request.setAttribute("booking", existingBooking);
            request.setAttribute("customerList", customerList);
            request.setAttribute("assignedRooms", assignedRooms);
            request.setAttribute("assignedServices", assignedServices);
            request.setAttribute("allRooms", allRoomsWithCategories);
            request.setAttribute("availableServices", availableServices);

            request.getRequestDispatcher("/View/Booking/edit-booking.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid Booking ID format: " + bookingIdParam);
            response.sendRedirect("manage-bookings");
        }
    }

    //Booking Modification Methods
    private void saveBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerID = Integer.parseInt(request.getParameter("customerID"));
            String checkInStr = request.getParameter("checkInDate");
            String checkOutStr = request.getParameter("checkOutDate");
            int numberOfGuests = Integer.parseInt(request.getParameter("numberOfGuests"));
            String notes = request.getParameter("notes");
            String status = request.getParameter("status");

            if (checkInStr == null || checkInStr.isEmpty() || checkOutStr == null || checkOutStr.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Check-in and Check-out dates are required.");
                response.sendRedirect("manage-bookings?action=add");
                return;
            }

            if (numberOfGuests <= 0) {
                request.getSession().setAttribute("errorMessage", "Number of guests must be positive.");
                response.sendRedirect("manage-bookings?action=add");
                return;
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            Date checkInDate = sdf.parse(checkInStr);
            Date checkOutDate = sdf.parse(checkOutStr);

            if (!checkOutDate.after(checkInDate)) {
                request.getSession().setAttribute("errorMessage", "Check-out date must be after Check-in date.");
                response.sendRedirect("manage-bookings?action=add");
                return;
            }

            Booking newBooking = new Booking();
            newBooking.setCustomerID(customerID);
            newBooking.setCheckInDate(checkInDate);
            newBooking.setCheckOutDate(checkOutDate);
            newBooking.setNumberOfGuests(numberOfGuests);
            newBooking.setNotes(notes);
            newBooking.setStatus(status);
            newBooking.setTotalPrice(BigDecimal.ZERO); // Initial price
            newBooking.setBookingDate(new Date());
            newBooking.setUpdatedAt(new Date());
            newBooking.setIsDeleted(false);

            int newBookingId = bookingDAO.addBooking(newBooking);

            if (newBookingId != -1) {
                request.getSession().setAttribute("successMessage", "Booking added successfully with ID: " + newBookingId + ". You can now add rooms/services.");
                response.sendRedirect("manage-bookings?action=edit&bookingId=" + newBookingId);
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to add booking. Database error occurred.");
                response.sendRedirect("manage-bookings?action=add");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid number format provided (Customer ID or Guests).");
            response.sendRedirect("manage-bookings?action=add");
        } catch (ParseException e) {
            request.getSession().setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD.");
            response.sendRedirect("manage-bookings?action=add");
        }
    }

    private void updateBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIdParam = request.getParameter("bookingId");
        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            int customerID = Integer.parseInt(request.getParameter("customerID"));
            String checkInStr = request.getParameter("checkInDate");
            String checkOutStr = request.getParameter("checkOutDate");
            int numberOfGuests = Integer.parseInt(request.getParameter("numberOfGuests"));
            String notes = request.getParameter("notes");
            String status = request.getParameter("status");

            if (checkInStr == null || checkInStr.isEmpty() || checkOutStr == null || checkOutStr.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Check-in and Check-out dates are required.");
                response.sendRedirect("manage-bookings?action=edit&bookingId=" + bookingIdParam);
                return;
            }

            if (numberOfGuests <= 0) {
                request.getSession().setAttribute("errorMessage", "Number of guests must be positive.");
                response.sendRedirect("manage-bookings?action=edit&bookingId=" + bookingIdParam);
                return;
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            Date checkInDate = sdf.parse(checkInStr);
            Date checkOutDate = sdf.parse(checkOutStr);

            if (!checkOutDate.after(checkInDate)) {
                request.getSession().setAttribute("errorMessage", "Check-out date must be after Check-in date.");
                response.sendRedirect("manage-bookings?action=edit&bookingId=" + bookingIdParam);
                return;
            }

            Booking bookingToUpdate = bookingDAO.getBookingById(bookingId);
            if (bookingToUpdate == null) {
                request.getSession().setAttribute("errorMessage", "Booking not found for update.");
                response.sendRedirect("manage-bookings");
                return;
            }

            bookingToUpdate.setCustomerID(customerID);
            bookingToUpdate.setCheckInDate(checkInDate);
            bookingToUpdate.setCheckOutDate(checkOutDate);
            bookingToUpdate.setNumberOfGuests(numberOfGuests);
            bookingToUpdate.setNotes(notes);
            bookingToUpdate.setStatus(status);
            bookingToUpdate.setUpdatedAt(new Date());

            boolean success = bookingDAO.editBooking(bookingToUpdate);

            if (success) {
                request.getSession().setAttribute("successMessage", "Booking ID " + bookingId + " updated successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update booking ID " + bookingId + ".");
            }
            response.sendRedirect("manage-bookings?action=edit&bookingId=" + bookingIdParam);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid number format provided (Customer ID or Guests).");
            response.sendRedirect("manage-bookings?action=edit&bookingId=" + bookingIdParam);
        } catch (ParseException e) {
            request.getSession().setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD.");
            response.sendRedirect("manage-bookings?action=edit&bookingId=" + bookingIdParam);
        }
    }

    private void deleteBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIdParam = request.getParameter("bookingId");
        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            boolean success = bookingDAO.deleteBooking(bookingId);

            if (success) {
                request.getSession().setAttribute("successMessage", "Booking ID " + bookingId + " marked as deleted successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete booking ID " + bookingId + ".");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid Booking ID for deletion: " + bookingIdParam);
        }
        response.sendRedirect("manage-bookings");
    }

    //Room/Service Management Methods
    private void addRoomToBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        String roomIdStr = request.getParameter("roomId");
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            int roomId = Integer.parseInt(roomIdStr);

            Room room = roomDAO.getRoomById(roomId);
            BigDecimal priceAtBooking = BigDecimal.ZERO;
            if (room != null) {
                priceAtBooking = room.getPriceOverride() != null ? room.getPriceOverride()
                        : roomDAO.getRoomCategoryBasePrice(room.getCategoryID());
            }
            if (priceAtBooking == null) {
                priceAtBooking = BigDecimal.ZERO;
            }

            boolean success = bookingDAO.addRoomToBooking(bookingId, roomId, priceAtBooking);

            if (success) {
                request.getSession().setAttribute("successMessage", "Room added successfully.");
                // TODO: Implement recalculate total price logic
                recalculateBookingTotal(bookingId);
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to add room. It might already be assigned or unavailable.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid Booking ID or Room ID.");
        }
        response.sendRedirect("manage-bookings?action=edit&bookingId=" + bookingIdStr);
    }

    private void removeRoomFromBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        String bookingRoomIdStr = request.getParameter("bookingRoomId");
        try {
            int bookingRoomId = Integer.parseInt(bookingRoomIdStr);
            int bookingId = Integer.parseInt(bookingIdStr);
            boolean success = bookingDAO.removeRoomFromBooking(bookingRoomId);

            if (success) {
                request.getSession().setAttribute("successMessage", "Room removed successfully.");
                // TODO: Implement recalculate total price logic
                recalculateBookingTotal(bookingId);
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to remove room.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid Booking Room ID.");
        }
        response.sendRedirect("manage-bookings?action=edit&bookingId=" + bookingIdStr);
    }

    private void addServiceToBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        String serviceIdStr = request.getParameter("serviceId");
        String quantityStr = request.getParameter("quantity");
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            int serviceId = Integer.parseInt(serviceIdStr);
            int quantity = Integer.parseInt(quantityStr);

            if (quantity <= 0) {
                request.getSession().setAttribute("errorMessage", "Quantity must be positive.");
                response.sendRedirect("manage-bookings?action=edit&bookingId=" + bookingIdStr);
                return;
            }

            Service service = serviceDAO.getServiceById(serviceId);
            BigDecimal priceAtBooking = (service != null && service.getPrice() != null)
                    ? service.getPrice() : BigDecimal.ZERO;

            boolean success = bookingDAO.addServiceToBooking(bookingId, serviceId, quantity, priceAtBooking, new Date());

            if (success) {
                request.getSession().setAttribute("successMessage", "Service added successfully.");
                // TODO: Implement recalculate total price logic
                recalculateBookingTotal(bookingId);
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to add service.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid Booking ID, Service ID, or Quantity.");
        }
        response.sendRedirect("manage-bookings?action=edit&bookingId=" + bookingIdStr);
    }

    private void removeServiceFromBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        String bookingServiceIdStr = request.getParameter("bookingServiceId");
        try {
            int bookingServiceId = Integer.parseInt(bookingServiceIdStr);
            int bookingId = Integer.parseInt(bookingIdStr);
            boolean success = bookingDAO.removeServiceFromBooking(bookingServiceId);

            if (success) {
                request.getSession().setAttribute("successMessage", "Service removed successfully.");
                // TODO: Implement recalculate total price logic
                recalculateBookingTotal(bookingId);
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to remove service.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid Booking Service ID.");
        }
        response.sendRedirect("manage-bookings?action=edit&bookingId=" + bookingIdStr);
    }

    private void recalculateBookingTotal(int bookingId) {
        try {
            // Implementation would calculate total from rooms and services
            // For now, we'll assume bookingDAO has or will have this method
            bookingDAO.recalculateBookingTotal(bookingId);
        } catch (Exception e) {
            System.err.println("Error recalculating booking total: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for managing hotel bookings, including rooms and services";
    }
}