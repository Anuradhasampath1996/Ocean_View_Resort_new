<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.oceanviewresortnew.dao.*" %>
<%@ page import="com.example.oceanviewresortnew.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDate" %>
<% if (session.getAttribute("role") == null || !"receptionist".equals(session.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
BookingDAO bookingDAO = new BookingDAO();
UserDAO userDAO = new UserDAO();
RoomDAO roomDAO = new RoomDAO();
LocalDate today = LocalDate.now();
List<Booking> todayCheckIns = new ArrayList<>();
for (Booking booking : bookingDAO.getAllBookings()) {
    if (booking.getCheckInDate().equals(today) && "confirmed".equals(booking.getStatus())) {
        todayCheckIns.add(booking);
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check-In - Receptionist - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<aside class="dashboard-sidebar" id="sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo-container">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="Ocean View Resort" class="logo-image sidebar">
        </a>
    </div>
    <div class="sidebar-user">
        <div class="sidebar-user-avatar"><i class="bi bi-person-fill"></i></div>
        <div class="sidebar-user-info">
            <span class="sidebar-user-name"><%= session.getAttribute("username") %></span>
            <span class="sidebar-user-role">Receptionist</span>
        </div>
    </div>
    <div class="sidebar-nav-label">Navigation</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard.jsp" class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/receptionist/check-in.jsp" class="sidebar-link active"><i class="bi bi-box-arrow-in-right"></i> Check-In</a></li>
        <li><a href="${pageContext.request.contextPath}/receptionist/check-out.jsp" class="sidebar-link"><i class="bi bi-box-arrow-left"></i> Check-Out</a></li>
        <li><a href="${pageContext.request.contextPath}/receptionist/rooms.jsp" class="sidebar-link"><i class="bi bi-door-open"></i> Room Status</a></li>
        <li class="sidebar-accordion-item">
            <button type="button" class="sidebar-link sidebar-accordion-btn" onclick="toggleBookingMenu()"><i class="bi bi-calendar-check"></i> Bookings <i class="bi bi-chevron-down sidebar-chevron" id="bookingChevron"></i></button>
            <ul class="sidebar-submenu" id="bookingSubmenu">
                <li><a href="${pageContext.request.contextPath}/receptionist/bookings.jsp" class="sidebar-link sidebar-sublink"><i class="bi bi-list-ul"></i> All Bookings</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/add-booking.jsp" class="sidebar-link sidebar-sublink"><i class="bi bi-plus-circle"></i> Add Booking</a></li>
            </ul>
        </li>
    </ul>
    <div class="sidebar-footer">
        <form action="${pageContext.request.contextPath}/auth" method="post" style="margin:0;">
            <input type="hidden" name="action" value="logout">
            <button type="submit" class="sidebar-logout-btn"><i class="bi bi-box-arrow-left"></i> Logout</button>
        </form>
    </div>
</aside>
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
<main class="dashboard-main-content" id="mainContent">
    <div class="container-fluid">
        <div class="flex justify-between items-center mb-4">
            <h2 style="margin:0;"><i class="bi bi-box-arrow-in-right" style="margin-right:.5rem;color:#1298c7;"></i>Today's Check-Ins</h2>
            <a href="${pageContext.request.contextPath}/admin/add-booking.jsp" class="btn btn-primary"><i class="bi bi-plus-circle"></i> New Booking</a>
        </div>
        <div class="grid grid-cols-4 gap-4 mb-4">
            <div class="stats-card">
                <div class="stats-icon" style="background-color:hsl(var(--ocean-blue));"><i class="bi bi-box-arrow-in-right"></i></div>
                <div><div class="stats-value"><%= todayCheckIns.size() %></div><div class="stats-label">Expected Today</div></div>
            </div>
        </div>
        <div class="card mb-4">
            <div class="card-header"><h3 class="card-title">Guests Checking In Today</h3></div>
            <div class="card-content p-0">
                <% if (todayCheckIns.isEmpty()) { %>
                <div style="padding:2.5rem;text-align:center;color:#6c757d;">
                    <i class="bi bi-inbox" style="font-size:2.5rem;display:block;margin-bottom:.75rem;"></i>
                    No check-ins scheduled for today
                </div>
                <% } else { %>
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr><th>Booking ID</th><th>Guest Name</th><th>Room</th><th>Room Type</th><th>Check-In</th><th>Check-Out</th><th>Guests</th><th>Action</th></tr>
                        </thead>
                        <tbody>
                            <% for (Booking booking : todayCheckIns) {
                                User user = userDAO.getUserById(booking.getUserId());
                                Room room = roomDAO.getRoomById(booking.getRoomId());
                            %>
                            <tr>
                                <td>#<%= booking.getId() %></td>
                                <td><%= user != null ? user.getFullName() : "Unknown" %></td>
                                <td><%= room != null ? room.getRoomNumber() : "N/A" %></td>
                                <td><%= room != null ? room.getRoomType() : "N/A" %></td>
                                <td><%= booking.getCheckInDate() %></td>
                                <td><%= booking.getCheckOutDate() %></td>
                                <td><%= booking.getNumberOfGuests() %></td>
                                <td>
                                    <button class="btn btn-primary" style="padding:.25rem .75rem;font-size:.875rem;"
                                            onclick="checkInGuest(<%= booking.getId() %>)">
                                        <i class="bi bi-check-circle"></i> Check In
                                    </button>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>
        </div>
        <div class="card">
            <div class="card-header"><h3 class="card-title">Walk-In Guest Registration</h3></div>
            <div class="card-content">
                <form id="walkInForm">
                    <div class="grid grid-cols-2" style="gap:1rem;">
                        <div class="form-group">
                            <label class="form-label">Guest Name *</label>
                            <input type="text" class="form-input" id="guestName" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Email *</label>
                            <input type="email" class="form-input" id="guestEmail" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Phone *</label>
                            <input type="tel" class="form-input" id="guestPhone" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Room Type *</label>
                            <select class="form-select" id="walkInRoomType" required>
                                <option value="">Select Room Type</option>
                                <option value="single">Single Room</option>
                                <option value="double">Double Room</option>
                                <option value="suite">Suite</option>
                                <option value="deluxe">Deluxe Suite</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Check-Out Date *</label>
                            <input type="date" class="form-input" id="checkOutDate" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Number of Guests *</label>
                            <input type="number" class="form-input" id="numberOfGuests" min="1" max="4" value="1" required>
                        </div>
                    </div>
                    <div style="margin-top:1rem;">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-person-plus"></i> Register Walk-In Guest</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleBookingMenu() {
        var sm = document.getElementById('bookingSubmenu');
        var ch = document.getElementById('bookingChevron');
        if (sm) { sm.classList.toggle('open'); ch.classList.toggle('open'); }
    }
    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('collapsed');
        var ov = document.getElementById('sidebarOverlay');
        if (ov) ov.classList.toggle('active');
    }
    function checkInGuest(bookingId) {
        if (confirm('Confirm check-in for booking #' + bookingId + '?')) {
            alert('Guest checked in for booking #' + bookingId + '!');
        }
    }
    document.getElementById('walkInForm').addEventListener('submit', function(e) {
        e.preventDefault();
        alert('Walk-in guest registered successfully!');
        this.reset();
    });
</script>
</body>
</html>
