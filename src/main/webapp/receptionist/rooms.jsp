<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.oceanviewresortnew.dao.*" %>
<%@ page import="com.example.oceanviewresortnew.model.*" %>
<%@ page import="java.util.*" %>
<%
    if (session.getAttribute("role") == null || !"receptionist".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    RoomDAO roomDAO = new RoomDAO();
    List<Room> allRooms = roomDAO.getAllRooms();
    int availableCount = 0, occupiedCount = 0, maintenanceCount = 0;
    for (Room room : allRooms) {
        if ("available".equals(room.getStatus())) availableCount++;
        else if ("occupied".equals(room.getStatus())) occupiedCount++;
        else if ("maintenance".equals(room.getStatus())) maintenanceCount++;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Status - Receptionist - Ocean View Resort</title>
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
            <span class="sidebar-user-role">Receptionist</span>
        </div>
    </div>
    <div class="sidebar-nav-label">Navigation</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard.jsp" class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/receptionist/rooms.jsp" class="sidebar-link active"><i class="bi bi-door-open"></i> Room Status</a></li>
        <li class="sidebar-accordion-item">
            <button type="button" class="sidebar-link sidebar-accordion-btn" onclick="toggleBookingMenu()">
                <i class="bi bi-calendar-check"></i> Bookings <i class="bi bi-chevron-down sidebar-chevron" id="bookingChevron"></i>
            </button>
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
        <h2 class="mb-4">Room Status</h2>
        <div class="grid grid-cols-4 mb-4">
            <div class="card stat-card">
                <div class="stat-value"><%= availableCount %></div>
                <div class="stat-label">Available</div>
            </div>
            <div class="card stat-card">
                <div class="stat-value"><%= occupiedCount %></div>
                <div class="stat-label">Occupied</div>
            </div>
            <div class="card stat-card">
                <div class="stat-value"><%= maintenanceCount %></div>
                <div class="stat-label">Maintenance</div>
            </div>
            <div class="card stat-card">
                <div class="stat-value"><%= allRooms.size() %></div>
                <div class="stat-label">Total Rooms</div>
            </div>
        </div>
        <div class="card">
            <div class="card-header" style="display:flex;align-items:center;justify-content:space-between;">
                <h4 class="card-title mb-0">All Rooms</h4>
                <select class="form-select" style="width:auto;" id="statusFilter" onchange="filterRooms()">
                    <option value="">All Statuses</option>
                    <option value="available">Available</option>
                    <option value="occupied">Occupied</option>
                    <option value="maintenance">Maintenance</option>
                </select>
            </div>
            <div class="card-content p-0">
                <div class="table-container">
                    <table class="table" id="roomsTable">
                        <thead>
                            <tr>
                                <th>Room Number</th>
                                <th>Type</th>
                                <th>Capacity</th>
                                <th>Price/Night</th>
                                <th>Status</th>
                                <th>Update Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Room room : allRooms) { %>
                            <tr data-status="<%= room.getStatus() %>">
                                <td><strong><%= room.getRoomNumber() %></strong></td>
                                <td><%= room.getRoomType() != null ? room.getRoomType().replace("_"," ").toUpperCase() : "-" %></td>
                                <td><%= room.getCapacity() %> guests</td>
                                <td>LKR <%= String.format("%.2f", room.getPricePerNight()) %></td>
                                <td>
                                    <% if ("available".equals(room.getStatus())) { %>
                                        <span class="badge badge-success">Available</span>
                                    <% } else if ("occupied".equals(room.getStatus())) { %>
                                        <span class="badge badge-warning">Occupied</span>
                                    <% } else { %>
                                        <span class="badge badge-danger">Maintenance</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (!"available".equals(room.getStatus())) { %>
                                        <button class="btn btn-outline" style="padding:.25rem .6rem;font-size:.8rem;" onclick="updateRoomStatus(<%= room.getId() %>,'available')"><i class="bi bi-check-circle"></i> Available</button>
                                    <% } %>
                                    <% if (!"occupied".equals(room.getStatus())) { %>
                                        <button class="btn btn-secondary" style="padding:.25rem .6rem;font-size:.8rem;" onclick="updateRoomStatus(<%= room.getId() %>,'occupied')"><i class="bi bi-door-closed"></i> Occupied</button>
                                    <% } %>
                                    <% if (!"maintenance".equals(room.getStatus())) { %>
                                        <button class="btn btn-danger" style="padding:.25rem .6rem;font-size:.8rem;" onclick="updateRoomStatus(<%= room.getId() %>,'maintenance')"><i class="bi bi-tools"></i> Maintenance</button>
                                    <% } %>
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
        var sidebar = document.getElementById('sidebar');
        var mainContent = document.getElementById('mainContent');
        var overlay = document.getElementById('sidebarOverlay');
        var isMobile = window.innerWidth <= 992;
        if (isMobile) { sidebar.classList.toggle('open'); overlay.classList.toggle('active'); }
        else { sidebar.classList.toggle('collapsed'); mainContent.classList.toggle('expanded'); }
    }
    window.addEventListener('resize', function () {
        document.getElementById('sidebar').classList.remove('collapsed','open');
        document.getElementById('mainContent').classList.remove('expanded');
        document.getElementById('sidebarOverlay').classList.remove('active');
    });
    function filterRooms() {
        var filter = document.getElementById('statusFilter').value;
        document.querySelectorAll('#roomsTable tbody tr').forEach(function(row) {
            row.style.display = (filter === '' || row.getAttribute('data-status') === filter) ? '' : 'none';
        });
    }
    function updateRoomStatus(roomId, newStatus) {
        if (!confirm('Change room status to ' + newStatus + '?')) return;
        var payload = new URLSearchParams();
        payload.set('action','updateStatus'); payload.set('id', roomId); payload.set('status', newStatus);
        fetch('${pageContext.request.contextPath}/rooms?' + payload.toString(), {
            method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body: payload.toString()
        }).then(function(r){ return r.json(); })
          .then(function(d){ if (d.success) location.reload(); else alert(d.message || 'Update failed'); })
          .catch(function(){ location.reload(); });
    }
</script>
</body>
</html>
