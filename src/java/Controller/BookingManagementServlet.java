package Controller;

import Dal.BookingDAO;
import Model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BookingManagementServlet", urlPatterns = {"/manage-bookings"})
public class BookingManagementServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookingDAO bookingDAO = new BookingDAO();
        String action = request.getParameter("action");
        String bookingIdParam = request.getParameter("bookingId");
        Booking editBooking = null;
        if ("edit".equals(action) && bookingIdParam != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                editBooking = bookingDAO.getBookingById(bookingId);
            } catch (NumberFormatException e) {
                // ignore
            }
        }
        List<Booking> bookings = bookingDAO.getAllBookings();
        request.setAttribute("bookings", bookings);
        request.setAttribute("editBooking", editBooking);
        request.getRequestDispatcher("BookingManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookingDAO bookingDAO = new BookingDAO();
        String deleteBookingIdParam = request.getParameter("deleteBookingID");
        if (deleteBookingIdParam != null && !deleteBookingIdParam.isEmpty()) {
            try {
                int deleteBookingId = Integer.parseInt(deleteBookingIdParam);
                bookingDAO.deleteBooking(deleteBookingId);
            } catch (NumberFormatException e) {
                // ignore
            }
            response.sendRedirect("manage-bookings");
            return;
        }
        // ...có thể bổ sung logic thêm/sửa booking ở đây nếu cần...
        response.sendRedirect("manage-bookings");
    }
}
