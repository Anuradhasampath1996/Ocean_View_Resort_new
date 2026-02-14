package com.example.oceanviewresortnew.servlet;

import com.example.oceanviewresortnew.dao.BookingDAO;
import com.example.oceanviewresortnew.dao.RoomDAO;
import com.example.oceanviewresortnew.model.Booking;
import com.example.oceanviewresortnew.model.Room;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@WebServlet(name = "BookingServlet", value = "/bookings")
public class BookingServlet extends HttpServlet {
    private BookingDAO bookingDAO;
    private RoomDAO roomDAO;
    private Gson gson;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        roomDAO = new RoomDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("list".equals(action)) {
            listBookings(request, response);
        } else if ("userBookings".equals(action)) {
            getUserBookings(request, response);
        } else if ("view".equals(action)) {
            viewBooking(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createBooking(request, response);
        } else if ("updateStatus".equals(action)) {
            updateBookingStatus(request, response);
        } else if ("cancel".equals(action)) {
            cancelBooking(request, response);
        }
    }

    private void listBookings(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<Booking> bookings = bookingDAO.getAllBookings();
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(bookings));
        out.flush();
    }

    private void getUserBookings(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int userId = (int) session.getAttribute("userId");
        List<Booking> bookings = bookingDAO.getBookingsByUserId(userId);
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(bookings));
        out.flush();
    }

    private void viewBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));
        Booking booking = bookingDAO.getBookingById(bookingId);
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(booking));
        out.flush();
    }

    private void createBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        Date checkIn = Date.valueOf(request.getParameter("checkIn"));
        Date checkOut = Date.valueOf(request.getParameter("checkOut"));
        int numberOfGuests = Integer.parseInt(request.getParameter("numberOfGuests"));
        String specialRequests = request.getParameter("specialRequests");

        // Check if room is available
        if (!bookingDAO.isRoomAvailable(roomId, checkIn, checkOut)) {
            response.sendRedirect(request.getContextPath() + "/customer/book-room.jsp?error=room_not_available");
            return;
        }

        // Calculate total amount
        Room room = roomDAO.getRoomById(roomId);
        long days = ChronoUnit.DAYS.between(checkIn.toLocalDate(), checkOut.toLocalDate());
        BigDecimal totalAmount = room.getPricePerNight().multiply(BigDecimal.valueOf(days));

        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setRoomId(roomId);
        booking.setCheckInDate(checkIn);
        booking.setCheckOutDate(checkOut);
        booking.setNumberOfGuests(numberOfGuests);
        booking.setTotalAmount(totalAmount);
        booking.setStatus("pending");
        booking.setSpecialRequests(specialRequests);

        boolean success = bookingDAO.createBooking(booking);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/customer/bookings.jsp?success=booking_created");
        } else {
            response.sendRedirect(request.getContextPath() + "/customer/book-room.jsp?error=booking_failed");
        }
    }

    private void updateBookingStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        boolean success = bookingDAO.updateBookingStatus(bookingId, status);

        if ("confirmed".equals(status)) {
            Booking booking = bookingDAO.getBookingById(bookingId);
            if (booking != null) {
                roomDAO.updateRoomStatus(booking.getRoomId(), "occupied");
            }
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": " + success + "}");
        out.flush();
    }

    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));
        boolean success = bookingDAO.updateBookingStatus(bookingId, "cancelled");

        if (success) {
            Booking booking = bookingDAO.getBookingById(bookingId);
            if (booking != null) {
                roomDAO.updateRoomStatus(booking.getRoomId(), "available");
            }
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": " + success + "}");
        out.flush();
    }
}
