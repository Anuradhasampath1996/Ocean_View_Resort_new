package com.example.oceanviewresortnew.servlet;

import com.example.oceanviewresortnew.dao.BookingDAO;
import com.example.oceanviewresortnew.dao.RoomDAO;
import com.example.oceanviewresortnew.dao.UserDAO;
import com.example.oceanviewresortnew.model.Booking;
import com.example.oceanviewresortnew.model.Room;
import com.example.oceanviewresortnew.model.User;
import com.example.oceanviewresortnew.util.EmailService;
import com.google.gson.Gson;
import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.pdf.draw.LineSeparator;
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
    private UserDAO userDAO;
    private Gson gson;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        roomDAO = new RoomDAO();
        userDAO = new UserDAO();
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
        } else if ("availableRooms".equals(action)) {
            HttpSession session = request.getSession(false);
            Object roleObj = session != null ? session.getAttribute("role") : null;
            String role = roleObj != null ? roleObj.toString() : null;
            if (!isStaffRole(role)) {
                writeJsonError(response, HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
            String checkIn = request.getParameter("checkIn");
            String checkOut = request.getParameter("checkOut");
            if (!hasNonBlank(checkIn) || !hasNonBlank(checkOut)) {
                writeJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "checkIn and checkOut required");
                return;
            }
            List<Room> availRooms = roomDAO.getAvailableRoomsByDate(checkIn, checkOut);
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(availRooms));
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            Object roleObj = session != null ? session.getAttribute("role") : null;
            String role = roleObj != null ? roleObj.toString() : null;
            String action = resolveAction(request);

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

    private String resolveAction(HttpServletRequest request) {
        String actionRaw = firstNonBlank(
                request.getParameter("action"),
                request.getParameter("bookingAction"),
                request.getParameter("op"),
                request.getParameter("operation"));

        if (actionRaw != null) {
            String normalized = actionRaw.trim();
            if (!normalized.isBlank()) {
                String lower = normalized.toLowerCase();
                return switch (lower) {
                    case "create", "new", "add", "book" -> "create";
                    case "createbystaff", "create_by_staff", "createstaff", "addbooking", "add_booking" ->
                        "createByStaff";
                    case "updatestatus", "update_status", "status" -> "updateStatus";
                    case "delete", "remove" -> "delete";
                    case "confirm" -> "confirm";
                    case "complete" -> "complete";
                    case "cancel", "cancelled", "canceled" -> "cancel";
                    default -> normalized;
                };
            }
        }

        boolean hasUser = hasNonBlank(request.getParameter("userId"))
                || hasNonBlank(request.getParameter("customerId"));
        boolean hasRoom = hasNonBlank(request.getParameter("roomId"));
        boolean hasDates = hasNonBlank(request.getParameter("checkIn"))
                && hasNonBlank(request.getParameter("checkOut"));

        if (hasUser && hasRoom && hasDates) {
            return "createByStaff";
        }

        if (hasRoom && hasDates) {
            return "create";
        }

        return null;
    }

    private boolean hasNonBlank(String value) {
        return value != null && !value.isBlank();
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

        String fileName = "invoice_booking_" + bookingId + ".pdf";
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        // Brand colors
        java.awt.Color brandBlue = new java.awt.Color(0x12, 0x98, 0xC7);
        java.awt.Color brandGold = new java.awt.Color(0xFF, 0xB0, 0x1A);
        java.awt.Color lightBg = new java.awt.Color(0xF0, 0xF8, 0xFF);
        java.awt.Color white = java.awt.Color.WHITE;

        Document document = new Document(PageSize.A4, 40, 40, 40, 40);
        try {
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // --- Fonts ---
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, brandBlue);
            Font subtitleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, brandGold);
            Font labelFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, brandBlue);
            Font bodyFont = FontFactory.getFont(FontFactory.HELVETICA, 11, java.awt.Color.DARK_GRAY);
            Font totalLabelFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, brandBlue);
            Font totalValueFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, brandGold);
            Font footerFont = FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 10, java.awt.Color.GRAY);

            // --- Header ---
            PdfPTable header = new PdfPTable(1);
            header.setWidthPercentage(100);
            PdfPCell headerCell = new PdfPCell();
            headerCell.setBackgroundColor(brandBlue);
            headerCell.setPadding(16);
            headerCell.setBorder(Rectangle.NO_BORDER);
            Paragraph hotelName = new Paragraph("Ocean View Resort",
                    FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, white));
            hotelName.setAlignment(Element.ALIGN_CENTER);
            headerCell.addElement(hotelName);
            Paragraph tagline = new Paragraph("BOOKING INVOICE",
                    FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, brandGold));
            tagline.setAlignment(Element.ALIGN_CENTER);
            headerCell.addElement(tagline);
            header.addCell(headerCell);
            document.add(header);
            document.add(new Paragraph(" "));

            // --- Invoice meta ---
            Paragraph meta = new Paragraph();
            meta.add(new Chunk("Invoice #: ", labelFont));
            meta.add(new Chunk("INV-" + String.format("%06d", booking.getId()), bodyFont));
            meta.add(new Chunk("     Date: ", labelFont));
            meta.add(new Chunk(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")), bodyFont));
            document.add(meta);
            document.add(new Paragraph(" "));

            // --- Separator ---
            LineSeparator separator = new LineSeparator();
            separator.setLineColor(brandBlue);
            separator.setLineWidth(1.5f);
            document.add(new Chunk(separator));
            document.add(new Paragraph(" "));

            // --- Details table ---
            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(100);
            table.setWidths(new float[] { 35f, 65f });

            int row = 0;
            addStyledRow(table, "Booking ID", "#" + booking.getId(), labelFont, bodyFont,
                    row++ % 2 == 0 ? lightBg : white);
            addStyledRow(table, "Customer", safePdf(booking.getUserName()), labelFont, bodyFont,
                    row++ % 2 == 0 ? lightBg : white);
            addStyledRow(table, "Room", safePdf(booking.getRoomNumber()) + " (" + safePdf(booking.getRoomType()) + ")",
                    labelFont, bodyFont, row++ % 2 == 0 ? lightBg : white);
            addStyledRow(table, "Check-in", String.valueOf(booking.getCheckInDate()), labelFont, bodyFont,
                    row++ % 2 == 0 ? lightBg : white);
            addStyledRow(table, "Check-out", String.valueOf(booking.getCheckOutDate()), labelFont, bodyFont,
                    row++ % 2 == 0 ? lightBg : white);
            addStyledRow(table, "Guests", String.valueOf(booking.getNumberOfGuests()), labelFont, bodyFont,
                    row++ % 2 == 0 ? lightBg : white);
            addStyledRow(table, "Status", safePdf(booking.getStatus()), labelFont, bodyFont,
                    row++ % 2 == 0 ? lightBg : white);
            addStyledRow(table, "Special Requests", safePdf(booking.getSpecialRequests()), labelFont, bodyFont,
                    row++ % 2 == 0 ? lightBg : white);

            document.add(table);
            document.add(new Paragraph(" "));

            // --- Total banner ---
            PdfPTable totalTable = new PdfPTable(2);
            totalTable.setWidthPercentage(100);
            totalTable.setWidths(new float[] { 65f, 35f });

            PdfPCell totalLabelCell = new PdfPCell(new Phrase("Total Amount", totalLabelFont));
            totalLabelCell.setBackgroundColor(lightBg);
            totalLabelCell.setPadding(12);
            totalLabelCell.setBorderColor(brandBlue);
            totalLabelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            totalTable.addCell(totalLabelCell);

            PdfPCell totalValCell = new PdfPCell(new Phrase("LKR " + booking.getTotalAmount(), totalValueFont));
            totalValCell.setBackgroundColor(brandBlue);
            totalValCell.setPadding(12);
            totalValCell.setBorder(Rectangle.NO_BORDER);
            totalValCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            totalTable.addCell(totalValCell);

            document.add(totalTable);
            document.add(new Paragraph(" "));
            document.add(new Paragraph(" "));

            // --- Separator ---
            document.add(new Chunk(separator));
            document.add(new Paragraph(" "));

            // --- Footer ---
            Paragraph footer = new Paragraph("Thank you for choosing Ocean View Resort.", footerFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);
            Paragraph contact = new Paragraph("Email: info@oceanviewresort.lk  |  Phone: +94 11 234 5678", footerFont);
            contact.setAlignment(Element.ALIGN_CENTER);
            document.add(contact);

        } catch (DocumentException exception) {
            throw new IOException("Failed to generate PDF invoice", exception);
        } finally {
            if (document.isOpen()) {
                document.close();
            }
        }
    }

    private void addStyledRow(PdfPTable table, String label, String value,
            Font labelFont, Font valueFont, java.awt.Color bgColor) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, labelFont));
        labelCell.setBackgroundColor(bgColor);
        labelCell.setPadding(8);
        labelCell.setBorderColor(new java.awt.Color(0xE5, 0xE7, 0xEB));

        PdfPCell valueCell = new PdfPCell(new Phrase(value, valueFont));
        valueCell.setBackgroundColor(bgColor);
        valueCell.setPadding(8);
        valueCell.setBorderColor(new java.awt.Color(0xE5, 0xE7, 0xEB));

        table.addCell(labelCell);
        table.addCell(valueCell);
    }

    private String safePdf(String value) {
        return (value == null || value.isBlank()) ? "-" : value;
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
        boolean isAjax = "json".equals(request.getParameter("responseType"));

        Integer userId = parseIntParameter(
                firstNonBlank(request.getParameter("userId"), request.getParameter("customerId")));

        // Inline new-customer creation when no userId supplied
        if (userId == null) {
            String newName = request.getParameter("newCustomerName");
            String newEmail = request.getParameter("newCustomerEmail");
            String newPhone = request.getParameter("newCustomerPhone");
            if (hasNonBlank(newName) && hasNonBlank(newEmail)) {
                User cust = new User();
                cust.setFullName(newName.trim());
                cust.setEmail(newEmail.trim());
                cust.setPhone(newPhone != null && !newPhone.isBlank() ? newPhone.trim() : null);
                cust.setRole("customer");
                cust.setUsername("cust_" + System.currentTimeMillis());
                cust.setPassword("NoLogin_" + System.currentTimeMillis());
                if (userDAO.register(cust)) {
                    User created = userDAO.getUserByEmail(newEmail.trim());
                    if (created != null)
                        userId = created.getId();
                }
            }
        }

        Integer roomId = parseIntParameter(request.getParameter("roomId"));
        String checkInValue = request.getParameter("checkIn");
        String checkOutValue = request.getParameter("checkOut");
        Integer numberOfGuests = parseIntParameter(request.getParameter("numberOfGuests"));
        String specialRequests = request.getParameter("specialRequests");

        if (userId == null || roomId == null || numberOfGuests == null || checkInValue == null || checkOutValue == null
                || checkInValue.isBlank() || checkOutValue.isBlank()) {
            if (isAjax)
                writeJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "Missing required fields");
            else
                response.sendRedirect(request.getContextPath() + "/admin/bookings.jsp?error=invalid_input");
            return;
        }

        Date checkIn;
        Date checkOut;
        try {
            checkIn = Date.valueOf(checkInValue);
            checkOut = Date.valueOf(checkOutValue);
        } catch (IllegalArgumentException exception) {
            if (isAjax)
                writeJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid dates");
            else
                response.sendRedirect(request.getContextPath() + "/admin/bookings.jsp?error=invalid_dates");
            return;
        }

        if (!checkOut.toLocalDate().isAfter(checkIn.toLocalDate())) {
            if (isAjax)
                writeJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "Check-out must be after check-in");
            else
                response.sendRedirect(request.getContextPath() + "/admin/bookings.jsp?error=invalid_dates");
            return;
        }

        if (!bookingDAO.isRoomAvailable(roomId, checkIn, checkOut)) {
            if (isAjax)
                writeJsonError(response, HttpServletResponse.SC_CONFLICT, "Room not available for selected dates");
            else
                response.sendRedirect(request.getContextPath() + "/admin/bookings.jsp?error=room_not_available");
            return;
        }

        Room room = roomDAO.getRoomById(roomId);
        if (room == null) {
            if (isAjax)
                writeJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid room");
            else
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

        int newBookingId = bookingDAO.createBookingGetId(booking);
        boolean success = newBookingId > 0;

        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            if (success)
                out.print("{\"success\":true,\"bookingId\":" + newBookingId + "}");
            else
                out.print("{\"success\":false,\"message\":\"Failed to create booking\"}");
            out.flush();
        } else {
            if (success)
                response.sendRedirect(request.getContextPath() + "/admin/bookings.jsp?success=booking_created");
            else
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

                // Send confirmation email to the customer
                try {
                    Booking confirmedBooking = bookingDAO.getBookingById(bookingId);
                    User customer = userDAO.getUserById(booking.getUserId());
                    if (customer != null && customer.getEmail() != null && !customer.getEmail().isBlank()) {
                        EmailService.sendBookingConfirmation(customer.getEmail(), confirmedBooking);
                    }
                } catch (Exception emailEx) {
                    emailEx.printStackTrace(); // Don't fail the request if email fails
                }
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
