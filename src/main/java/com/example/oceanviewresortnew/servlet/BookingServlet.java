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
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.time.format.DateTimeFormatter;
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
        } else if ("invoice".equals(action)) {
            HttpSession session = request.getSession(false);
            Object roleObj = session != null ? session.getAttribute("role") : null;
            String role = roleObj != null ? roleObj.toString() : null;

            if (!isStaffRole(role)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            downloadInvoice(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            Object roleObj = session != null ? session.getAttribute("role") : null;
            String role = roleObj != null ? roleObj.toString() : null;
            String action = request.getParameter("action");

            if ("confirm".equals(action)) {
                action = "updateStatus";
                request.setAttribute("forcedStatus", "confirmed");
            } else if ("complete".equals(action)) {
                action = "updateStatus";
                request.setAttribute("forcedStatus", "completed");
            } else if ("cancel".equals(action)) {
                action = "updateStatus";
                request.setAttribute("forcedStatus", "cancelled");
            } else if ("remove".equals(action)) {
                action = "delete";
            }

            if ("create".equals(action)) {
                createBooking(request, response);
            } else if ("createByStaff".equals(action)) {
                if (!isStaffRole(role)) {
                    writeJsonError(response, HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
                createBookingByStaff(request, response);
            } else if ("updateStatus".equals(action)) {
                if (!isStaffRole(role)) {
                    writeJsonError(response, HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
                updateBookingStatus(request, response);
            } else if ("delete".equals(action)) {
                if (!isStaffRole(role)) {
                    writeJsonError(response, HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
                deleteBooking(request, response);
            } else {
                writeJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid booking action");
            }
        } catch (Exception exception) {
            exception.printStackTrace();
            writeJsonError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Booking request failed. Please try again.");
        }
    }

    private boolean isStaffRole(String role) {
        return "admin".equals(role) || "manager".equals(role) || "receptionist".equals(role);
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

    private void downloadInvoice(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idValue = firstNonBlank(request.getParameter("id"), request.getParameter("bookingId"));
        Integer bookingId = parseIntParameter(idValue);

        if (bookingId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking id");
            return;
        }

        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
            return;
        }

        String fileName = "invoice_booking_" + bookingId + ".html";
        response.setContentType("text/html;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html><head><meta charset='UTF-8'><title>Invoice #" + bookingId + "</title>");
        out.println("<style>");
        out.println("body{font-family:Arial,sans-serif;padding:24px;color:#1f2937;}");
        out.println(".wrap{max-width:800px;margin:0 auto;border:1px solid #e5e7eb;border-radius:10px;padding:24px;}");
        out.println("h1{margin:0 0 8px;color:#1298c7;} h2{margin:0 0 20px;color:#374151;font-size:18px;}");
        out.println("table{width:100%;border-collapse:collapse;margin-top:16px;}");
        out.println("th,td{border:1px solid #e5e7eb;padding:10px;text-align:left;}");
        out.println("th{background:#f9fafb;width:35%;}");
        out.println(".total{font-size:20px;font-weight:bold;color:#1298c7;}");
        out.println("</style></head><body>");
        out.println("<div class='wrap'>");
        out.println("<h1>Ocean View Resort</h1>");
        out.println("<h2>Booking Invoice</h2>");
        out.println("<table>");
        out.println("<tr><th>Invoice Generated</th><td>"
                + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) + "</td></tr>");
        out.println("<tr><th>Booking ID</th><td>#" + booking.getId() + "</td></tr>");
        out.println("<tr><th>Customer</th><td>" + safe(booking.getUserName()) + "</td></tr>");
        out.println("<tr><th>Room</th><td>" + safe(booking.getRoomNumber()) + " (" + safe(booking.getRoomType())
                + ")</td></tr>");
        out.println("<tr><th>Check-in</th><td>" + booking.getCheckInDate() + "</td></tr>");
        out.println("<tr><th>Check-out</th><td>" + booking.getCheckOutDate() + "</td></tr>");
        out.println("<tr><th>Guests</th><td>" + booking.getNumberOfGuests() + "</td></tr>");
        out.println("<tr><th>Status</th><td>" + safe(booking.getStatus()) + "</td></tr>");
        out.println("<tr><th>Special Requests</th><td>" + safe(booking.getSpecialRequests()) + "</td></tr>");
        out.println("<tr><th>Total Amount</th><td class='total'>LKR " + booking.getTotalAmount() + "</td></tr>");
        out.println("</table>");
        out.println("</div></body></html>");
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

    private void createBookingByStaff(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Integer userId = parseIntParameter(
                firstNonBlank(request.getParameter("userId"), request.getParameter("customerId")));
        Integer roomId = parseIntParameter(request.getParameter("roomId"));
        String checkInValue = request.getParameter("checkIn");
        String checkOutValue = request.getParameter("checkOut");
        Integer numberOfGuests = parseIntParameter(request.getParameter("numberOfGuests"));
        String specialRequests = request.getParameter("specialRequests");

        if (userId == null || roomId == null || numberOfGuests == null || checkInValue == null || checkOutValue == null
                || checkInValue.isBlank() || checkOutValue.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings.jsp?error=invalid_input");
            return;
        }

        Date checkIn;
        Date checkOut;
        try {
            checkIn = Date.valueOf(checkInValue);
            checkOut = Date.valueOf(checkOutValue);
        } catch (IllegalArgumentException exception) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings.jsp?error=invalid_dates");
            return;
        }

        if (!checkOut.toLocalDate().isAfter(checkIn.toLocalDate())) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings.jsp?error=invalid_dates");
            return;
        }

        if (!bookingDAO.isRoomAvailable(roomId, checkIn, checkOut)) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings.jsp?error=room_not_available");
            return;
        }

        Room room = roomDAO.getRoomById(roomId);
        if (room == null) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings.jsp?error=invalid_room");
            return;
        }

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
            response.sendRedirect(request.getContextPath() + "/admin/bookings.jsp?success=booking_created");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/bookings.jsp?error=booking_create_failed");
        }
    }

    private void updateBookingStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idValue = firstNonBlank(
                request.getParameter("id"),
                request.getParameter("bookingId"),
                request.getParameter("booking_id"),
                request.getParameter("selectedBookingId"));
        Integer bookingId = parseIntParameter(idValue);
        String statusRaw = firstNonBlank(
                (String) request.getAttribute("forcedStatus"),
                request.getParameter("status"),
                request.getParameter("bookingStatus"),
                request.getParameter("newStatus"),
                request.getParameter("booking_status"),
                request.getParameter("state"),
                request.getParameter("value"),
                request.getParameter("actionType"),
                request.getParameter("operation"));

        String status = normalizeStatus(statusRaw);

        if (bookingId == null || status == null || status.isBlank()) {
            writeJsonError(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid booking id or status (id=" + idValue + ", status=" + statusRaw + ")");
            return;
        }

        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) {
            writeJsonError(response, HttpServletResponse.SC_NOT_FOUND, "Booking not found");
            return;
        }

        boolean success = bookingDAO.updateBookingStatus(bookingId, status);

        if (success) {
            if ("confirmed".equals(status)) {
                roomDAO.updateRoomStatus(booking.getRoomId(), "occupied");
            } else if ("cancelled".equals(status) || "completed".equals(status)) {
                roomDAO.updateRoomStatus(booking.getRoomId(), "available");
            }
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": " + success + "}");
        out.flush();
    }

    private void deleteBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idValue = firstNonBlank(
                request.getParameter("id"),
                request.getParameter("bookingId"),
                request.getParameter("booking_id"),
                request.getParameter("selectedBookingId"));
        Integer bookingId = parseIntParameter(idValue);
        if (bookingId == null) {
            writeJsonError(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid booking id (id=" + idValue + ")");
            return;
        }

        Booking booking = bookingDAO.getBookingById(bookingId);

        boolean success = bookingDAO.deleteBooking(bookingId);
        if (success && booking != null) {
            roomDAO.updateRoomStatus(booking.getRoomId(), "available");
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": " + success + "}");
        out.flush();
    }

    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idValue = firstNonBlank(
                request.getParameter("id"),
                request.getParameter("bookingId"),
                request.getParameter("booking_id"),
                request.getParameter("selectedBookingId"));
        Integer bookingId = parseIntParameter(idValue);
        if (bookingId == null) {
            writeJsonError(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid booking id (id=" + idValue + ")");
            return;
        }

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

    private Integer parseIntParameter(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException exception) {
            String digitsOnly = value.replaceAll("[^0-9]", "");
            if (digitsOnly.isBlank()) {
                return null;
            }
            try {
                return Integer.parseInt(digitsOnly);
            } catch (NumberFormatException ignored) {
                return null;
            }
        }
    }

    private String normalizeStatus(String rawStatus) {
        if (rawStatus == null) {
            return null;
        }

        String value = rawStatus.trim().toLowerCase();
        return switch (value) {
            case "pending" -> "pending";
            case "confirm", "confirmed", "approve", "approved" -> "confirmed";
            case "complete", "completed", "finish", "finished" -> "completed";
            case "cancel", "cancelled", "canceled", "reject", "rejected" -> "cancelled";
            default -> null;
        };
    }

    private String firstNonBlank(String... values) {
        if (values == null) {
            return null;
        }
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value;
            }
        }
        return null;
    }

    private String safe(String value) {
        if (value == null || value.isBlank()) {
            return "-";
        }
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private void writeJsonError(HttpServletResponse response, int statusCode, String message)
            throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": false, \"message\": \"" + message + "\"}");
        out.flush();
    }
}
