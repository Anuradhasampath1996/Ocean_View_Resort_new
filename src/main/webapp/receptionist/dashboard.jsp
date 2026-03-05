<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.oceanviewresortnew.dao.*" %>
<%@ page import="com.example.oceanviewresortnew.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDate" %>
<% if (session.getAttribute("role") == null || !"receptionist".equals(session.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
BookingDAO bookingDAO = new BookingDAO();
RoomDAO roomDAO = new RoomDAO();
UserDAO userDAO = new UserDAO();
List<Room> allRooms = roomDAO.getAllRooms();
List<Booking> todaysBookings = bookingDAO.getAllBookings();
int availableRooms = 0; int occupiedRooms = 0; int maintenanceRooms = 0;
for (Room room : allRooms) {
    if ("available".equals(room.getStatus())) availableRooms++;
    else if ("occupied".equals(room.getStatus())) occupiedRooms++;
    else if ("maintenance".equals(room.getStatus())) maintenanceRooms++;
}
LocalDate today = LocalDate.now();
int todaysCheckIns = 0; int todaysCheckOuts = 0;
for (Booking booking : todaysBookings) {
    if (booking.getCheckInDate().toString().equals(today.toString()) && "confirmed".equals(booking.getStatus())) todaysCheckIns++;
    if (booking.getCheckOutDate().toString().equals(today.toString()) && ("confirmed".equals(booking.getStatus()) || "completed".equals(booking.getStatus()))) todaysCheckOuts++;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reception Desk - Ocean View Resort</title>
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
        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard.jsp" class="sidebar-link active"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/receptionist/check-in.jsp" class="sidebar-link"><i class="bi bi-box-arrow-in-right"></i> Check-In</a></li>
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
            <h2 style="margin:0;"><i class="bi bi-speedometer2" style="margin-right:.5rem;color:#1298c7;"></i>Reception Desk</h2>
            <span style="color:#6c757d;font-size:.95rem;"><i class="bi bi-calendar3" style="margin-right:.3rem;"></i><%= today %></span>
        </div>
        <div class="grid grid-cols-4 gap-4 mb-4">
            <div class="stats-card">
                <div class="stats-icon" style="background-color:hsl(var(--success));"><i class="bi bi-door-open"></i></div>
                <div><div class="stats-value"><%= availableRooms %></div><div class="stats-label">Available Rooms</div></div>
            </div>
            <div class="stats-card">
                <div class="stats-icon" style="background-color:hsl(var(--warning));"><i class="bi bi-door-closed"></i></div>
                <div><div class="stats-value"><%= occupiedRooms %></div><div class="stats-label">Occupied Rooms</div></div>
            </div>
            <div class="stats-card">
                <div class="stats-icon" style="background-color:hsl(var(--ocean-blue));"><i class="bi bi-box-arrow-in-right"></i></div>
                <div><div class="stats-value"><%= todaysCheckIns %></div><div class="stats-label">Today's Check-Ins</div></div>
            </div>
            <div class="stats-card">
                <div class="stats-icon" style="background-color:hsl(var(--primary));"><i class="bi bi-box-arrow-left"></i></div>
                <div><div class="stats-value"><%= todaysCheckOuts %></div><div class="stats-label">Today's Check-Outs</div></div>
            </div>
        </div>
        <div class="card">
            <div class="card-header"><h3 class="card-title">Expected Arrivals Today</h3></div>
            <div class="card-content p-0">
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr><th>Booking ID</th><th>Guest Name</th><th>Room</th><th>Guests</th><th>Check-Out</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                            <% boolean hasArrivals = false;
                               for (Booking booking : todaysBookings) {
                                if (booking.getCheckInDate().toString().equals(today.toString()) && "confirmed".equals(booking.getStatus())) {
                                    hasArrivals = true;
                                    User user = userDAO.getUserById(booking.getUserId());
                                    Room room = roomDAO.getRoomById(booking.getRoomId());
                            %>
                            <tr>
                                <td>#<%= booking.getId() %></td>
                                <td><%= user != null ? user.getFullName() : "Unknown" %></td>
                                <td><%= room != null ? room.getRoomNumber() : "Unknown" %></td>
                                <td><%= booking.getNumberOfGuests() %></td>
                                <td><%= booking.getCheckOutDate() %></td>
                                <td><span class="badge bg-warning text-dark">Confirmed</span></td>
                            </tr>
                            <% } } if (!hasArrivals) { %>
                            <tr><td colspan="6" class="text-center text-muted" style="padding:2rem;">No arrivals expected today</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
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
</script>
</body>
</html>
