<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.oceanviewresortnew.dao.*" %>
<%@ page import="com.example.oceanviewresortnew.model.*" %>
<%@ page import="java.util.*" %>
<% if (session.getAttribute("role") == null || !"manager".equals(session.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
RoomDAO roomDAO = new RoomDAO();
List<Room> allRooms = roomDAO.getAllRooms();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rooms Overview - Manager - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<aside class="dashboard-sidebar" id="sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/login.jsp" class="logo-container">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="Ocean View Resort" class="logo-image sidebar">
        </a>
    </div>
    <div class="sidebar-user">
        <div class="sidebar-user-avatar"><i class="bi bi-person-fill"></i></div>
        <div class="sidebar-user-info">
            <span class="sidebar-user-name"><%= session.getAttribute("username") %></span>
            <span class="sidebar-user-role">Manager</span>
        </div>
    </div>
    <div class="sidebar-nav-label">Navigation</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/manager/dashboard.jsp" class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
        <li class="sidebar-accordion-item">
            <button type="button" class="sidebar-link sidebar-accordion-btn" onclick="toggleBookingMenu()"><i class="bi bi-calendar-check"></i> Bookings <i class="bi bi-chevron-down sidebar-chevron" id="bookingChevron"></i></button>
            <ul class="sidebar-submenu" id="bookingSubmenu">
                <li><a href="${pageContext.request.contextPath}/manager/bookings.jsp" class="sidebar-link sidebar-sublink"><i class="bi bi-list-ul"></i> All Bookings</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/add-booking.jsp" class="sidebar-link sidebar-sublink"><i class="bi bi-plus-circle"></i> Add Booking</a></li>
            </ul>
        </li>
        <li><a href="${pageContext.request.contextPath}/manager/rooms.jsp" class="sidebar-link active"><i class="bi bi-door-open"></i> Rooms</a></li>
        <li><a href="${pageContext.request.contextPath}/manager/staff.jsp" class="sidebar-link"><i class="bi bi-people"></i> Staff &amp; Guests</a></li>
        <li><a href="${pageContext.request.contextPath}/manager/reports.jsp" class="sidebar-link"><i class="bi bi-bar-chart-line"></i> Reports</a></li>
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
        <h2 style="margin-bottom:1.5rem;"><i class="bi bi-door-open" style="margin-right:.5rem;color:#1298c7;"></i>Rooms Overview</h2>
        <div class="card">
            <div class="card-content p-0">
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Room No.</th><th>Type</th><th>Capacity</th>
                                <th>Price / Night</th><th>Status</th><th>Amenities</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Room room : allRooms) {
                                String sc = "badge bg-secondary text-white";
                                if ("available".equals(room.getStatus()))   sc = "badge bg-success text-white";
                                else if ("occupied".equals(room.getStatus()))    sc = "badge bg-warning text-dark";
                                else if ("maintenance".equals(room.getStatus())) sc = "badge bg-danger text-white";
                            %>
                            <tr>
                                <td><strong><%= room.getRoomNumber() %></strong></td>
                                <td><%= room.getRoomType() %></td>
                                <td><%= room.getCapacity() %> guest(s)</td>
                                <td>LKR <%= String.format("%.2f", room.getPricePerNight()) %></td>
                                <td><span class="<%= sc %>"><%= room.getStatus().substring(0,1).toUpperCase() + room.getStatus().substring(1) %></span></td>
                                <td><%= room.getAmenities() != null ? room.getAmenities() : "-" %></td>
                            </tr>
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
