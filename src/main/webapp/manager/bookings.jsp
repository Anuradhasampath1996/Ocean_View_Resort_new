<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.oceanviewresortnew.dao.*" %>
<%@ page import="com.example.oceanviewresortnew.model.*" %>
<%@ page import="java.util.*" %>
<% if (session.getAttribute("role") == null || !"manager".equals(session.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
BookingDAO bookingDAO = new BookingDAO();
UserDAO userDAO = new UserDAO();
RoomDAO roomDAO = new RoomDAO();
List<Booking> allBookings = bookingDAO.getAllBookings();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bookings - Manager - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .status-select { padding:.2rem .5rem; font-size:.8rem; border-radius:.375rem; border:1px solid #dee2e6; cursor:pointer; font-weight:600; outline:none; }
        .status-select.status-pending   { background:#fff3cd; color:#856404; border-color:#ffc107; }
        .status-select.status-confirmed { background:#d1e7dd; color:#0a3622; border-color:#198754; }
        .status-select.status-completed { background:#e2e3e5; color:#41464b; border-color:#6c757d; }
        .status-select.status-cancelled { background:#f8d7da; color:#58151c; border-color:#dc3545; }
    </style>
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
            <button type="button" class="sidebar-link sidebar-accordion-btn" onclick="toggleBookingMenu()"><i class="bi bi-calendar-check"></i> Bookings <i class="bi bi-chevron-down sidebar-chevron open" id="bookingChevron"></i></button>
            <ul class="sidebar-submenu open" id="bookingSubmenu">
                <li><a href="${pageContext.request.contextPath}/manager/bookings.jsp" class="sidebar-link sidebar-sublink active"><i class="bi bi-list-ul"></i> All Bookings</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/add-booking.jsp" class="sidebar-link sidebar-sublink"><i class="bi bi-plus-circle"></i> Add Booking</a></li>
            </ul>
        </li>
        <li><a href="${pageContext.request.contextPath}/manager/rooms.jsp" class="sidebar-link"><i class="bi bi-door-open"></i> Rooms</a></li>
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
        <div class="flex justify-between items-center mb-4">
            <h2 style="margin:0;"><i class="bi bi-calendar-check" style="margin-right:.5rem;color:#1298c7;"></i>Manage Bookings</h2>
            <a href="${pageContext.request.contextPath}/admin/add-booking.jsp" class="btn btn-primary"><i class="bi bi-plus-circle"></i> Add Booking</a>
        </div>
        <div class="card">
            <div class="card-content p-0">
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th><th>Customer</th><th>Room</th>
                                <th>Check-In</th><th>Check-Out</th><th>Guests</th>
                                <th>Amount</th><th>Status</th><th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Booking booking : allBookings) {
                                User user = userDAO.getUserById(booking.getUserId());
                                Room room = roomDAO.getRoomById(booking.getRoomId());
                                String custName  = (user != null) ? user.getFullName() : "Unknown";
                                String roomNum   = (room != null) ? room.getRoomNumber() : "-";
                                String roomTypeS = (room != null) ? room.getRoomType() : "-";
                            %>
                            <tr>
                                <td>#<%= booking.getId() %></td>
                                <td><%= custName %></td>
                                <td><%= roomNum %> (<%= roomTypeS %>)</td>
                                <td><%= booking.getCheckInDate() %></td>
                                <td><%= booking.getCheckOutDate() %></td>
                                <td><%= booking.getNumberOfGuests() %></td>
                                <td>LKR <%= String.format("%.2f", booking.getTotalAmount().doubleValue()) %></td>
                                <td>
                                    <select class="status-select status-<%= booking.getStatus() %>"
                                            onchange="changeStatus(<%= booking.getId() %>, this)"
                                            data-prev="<%= booking.getStatus() %>">
                                        <option value="pending"   <%= "pending".equals(booking.getStatus())   ? "selected":"" %>>Pending</option>
                                        <option value="confirmed" <%= "confirmed".equals(booking.getStatus()) ? "selected":"" %>>Confirmed</option>
                                        <option value="completed" <%= "completed".equals(booking.getStatus()) ? "selected":"" %>>Completed</option>
                                        <option value="cancelled" <%= "cancelled".equals(booking.getStatus()) ? "selected":"" %>>Cancelled</option>
                                    </select>
                                </td>
                                <td>
                                    <a class="btn btn-outline" style="padding:.25rem .75rem;font-size:.875rem;"
                                       href="${pageContext.request.contextPath}/bookings?action=invoice&id=<%= booking.getId() %>">Invoice</a>
                                    <button class="btn btn-danger" style="padding:.25rem .75rem;font-size:.875rem;"
                                            onclick="deleteBooking(<%= booking.getId() %>)">Delete</button>
                                </td>
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
    function postBookingAction(action, params) {
        params = params || {};
        var payload = new URLSearchParams();
        payload.set('action', action);
        Object.keys(params).forEach(function(k) { if (params[k] != null) payload.set(k, String(params[k])); });
        var q = payload.toString();
        return fetch('${pageContext.request.contextPath}/bookings?' + q, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: q
        }).then(function(r) { return r.json().then(function(d) {
            if (!r.ok || !d.success) throw new Error(d.message || 'Request failed');
            return d;
        }); });
    }
    function changeStatus(bookingId, sel) {
        var newStatus = sel.value;
        var prev = sel.getAttribute('data-prev');
        if (!confirm('Change status to ' + newStatus + '?')) { sel.value = prev; applyStatusClass(sel, prev); return; }
        postBookingAction('updateStatus', { id: bookingId, bookingId: bookingId, status: newStatus, newStatus: newStatus })
            .then(function() { sel.setAttribute('data-prev', newStatus); applyStatusClass(sel, newStatus); })
            .catch(function(e) { alert(e.message || 'Failed'); sel.value = prev; applyStatusClass(sel, prev); });
    }
    function applyStatusClass(sel, status) {
        sel.className = 'status-select status-' + status;
    }
    function deleteBooking(bookingId) {
        if (!confirm('Delete booking #' + bookingId + '?')) return;
        postBookingAction('delete', { id: bookingId, bookingId: bookingId })
            .then(function() { location.reload(); })
            .catch(function(e) { alert(e.message || 'Failed to delete booking'); });
    }
</script>
</body>
</html>
