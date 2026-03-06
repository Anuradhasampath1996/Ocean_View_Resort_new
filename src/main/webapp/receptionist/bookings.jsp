<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.oceanviewresortnew.dao.*" %>
<%@ page import="com.example.oceanviewresortnew.model.*" %>
<%@ page import="java.util.*" %>
<%
    if (session.getAttribute("role") == null || !"receptionist".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
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
    <title>Bookings - Receptionist - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .status-select { padding:.2rem .5rem; font-size:.8rem; border-radius:.375rem; border:1px solid #dee2e6; cursor:pointer; font-weight:600; outline:none; }
        .status-select.status-pending   { background:#fff3cd; color:#856404; border-color:#ffc107; }
        .status-select.status-confirmed { background:#d1e7dd; color:#0a3622; border-color:#198754; }
        .status-select.status-completed { background:#e2e3e5; color:#41464b; border-color:#6c757d; }
        .status-select.status-cancelled { background:#f8d7da; color:#58151c; border-color:#dc3545; }
        .filter-bar { background:var(--card); border:1px solid var(--border); border-radius:var(--radius); padding:1rem 1.25rem; margin-bottom:1.25rem; display:flex; flex-wrap:wrap; gap:.75rem; align-items:flex-end; }
        .filter-group { display:flex; flex-direction:column; gap:.3rem; }
        .filter-group label { font-size:.75rem; font-weight:600; color:var(--muted-foreground); text-transform:uppercase; letter-spacing:.04em; }
        .filter-group input { padding:.35rem .65rem; font-size:.875rem; border:1px solid var(--border); border-radius:.375rem; background:var(--background); color:var(--foreground); outline:none; min-width:150px; }
        .filter-group input:focus { border-color:#1298c7; box-shadow:0 0 0 2px rgba(18,152,199,.15); }
        .filter-results { font-size:.8rem; color:var(--muted-foreground); margin-left:auto; align-self:center; white-space:nowrap; }
        tr.filtered-out { display:none; }
        .view-modal-overlay { position:fixed;inset:0;background:rgba(0,0,0,.45);z-index:1050;display:none;align-items:center;justify-content:center; }
        .view-modal-overlay.show { display:flex; }
        .view-modal { background:var(--card);border-radius:var(--radius);width:100%;max-width:540px;box-shadow:0 8px 32px rgba(0,0,0,.18);overflow:hidden; }
        .view-modal-header { background:#1298c7;color:#fff;padding:1rem 1.25rem;display:flex;align-items:center;justify-content:space-between; }
        .view-modal-header h5 { margin:0;font-weight:700;font-size:1rem; }
        .view-modal-close { background:none;border:none;color:#fff;font-size:1.3rem;cursor:pointer;line-height:1; }
        .view-modal-body { padding:1.25rem; }
        .detail-grid { display:grid;grid-template-columns:1fr 1fr;gap:.65rem 1.25rem; }
        .detail-item label { font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--muted-foreground);display:block;margin-bottom:.15rem; }
        .detail-item span { font-size:.9rem;color:var(--foreground);font-weight:500; }
        .view-modal-footer { padding:.85rem 1.25rem;border-top:1px solid var(--border);display:flex;justify-content:flex-end; }
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
            <span class="sidebar-user-role">Receptionist</span>
        </div>
    </div>
    <div class="sidebar-nav-label">Navigation</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard.jsp" class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/receptionist/rooms.jsp" class="sidebar-link"><i class="bi bi-door-open"></i> Room Status</a></li>
        <li class="sidebar-accordion-item">
            <button type="button" class="sidebar-link sidebar-accordion-btn" onclick="toggleBookingMenu()">
                <i class="bi bi-calendar-check"></i> Bookings <i class="bi bi-chevron-down sidebar-chevron open" id="bookingChevron"></i>
            </button>
            <ul class="sidebar-submenu open" id="bookingSubmenu">
                <li><a href="${pageContext.request.contextPath}/receptionist/bookings.jsp" class="sidebar-link sidebar-sublink active"><i class="bi bi-list-ul"></i> All Bookings</a></li>
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
        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:1.25rem;">
            <h2 style="margin:0;">All Bookings</h2>
            <a href="${pageContext.request.contextPath}/admin/add-booking.jsp" class="btn btn-primary"><i class="bi bi-plus-circle"></i> Add Booking</a>
        </div>

        <!-- Filter Bar -->
        <div class="filter-bar">
            <div class="filter-group">
                <label><i class="bi bi-person"></i> Guest Name</label>
                <input type="text" id="filterGuest" placeholder="Search guest..." oninput="applyFilters()">
            </div>
            <div class="filter-group">
                <label><i class="bi bi-door-open"></i> Room</label>
                <input type="text" id="filterRoom" placeholder="Room no. or type..." oninput="applyFilters()">
            </div>
            <div class="filter-group">
                <label><i class="bi bi-calendar-event"></i> Check-In From</label>
                <input type="date" id="filterDateFrom" onchange="applyFilters()">
            </div>
            <div class="filter-group">
                <label><i class="bi bi-calendar-event"></i> Check-In To</label>
                <input type="date" id="filterDateTo" onchange="applyFilters()">
            </div>
            <div class="filter-group" style="justify-content:flex-end;">
                <label>&nbsp;</label>
                <button class="btn btn-outline" style="padding:.35rem .85rem;font-size:.875rem;" onclick="clearFilters()"><i class="bi bi-x-circle"></i> Clear</button>
            </div>
            <span class="filter-results" id="filterResults"></span>
        </div>

        <div class="card">
            <div class="card-content p-0">
                <div class="table-container">
                    <table class="table" id="bookingsTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Guest Name</th>
                                <th>Room</th>
                                <th>Check-In</th>
                                <th>Check-Out</th>
                                <th>Guests</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Invoice</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Booking booking : allBookings) {
                                User user = userDAO.getUserById(booking.getUserId());
                                Room room = roomDAO.getRoomById(booking.getRoomId());
                                String custName = (user != null) ? user.getFullName() : "Unknown";
                                String roomNum = (room != null) ? room.getRoomNumber() : "-";
                                String roomType = (room != null) ? room.getRoomType() : "-";
                            %>
                            <tr data-guest="<%= custName.toLowerCase() %>" data-room="<%= (roomNum + " " + roomType).toLowerCase() %>" data-checkin="<%= booking.getCheckInDate() %>" data-checkout="<%= booking.getCheckOutDate() %>"
                                data-id="<%= booking.getId() %>"
                                data-fullguest="<%= custName %>"
                                data-email="<%= (user != null && user.getEmail() != null) ? user.getEmail() : "-" %>"
                                data-phone="<%= (user != null && user.getPhone() != null) ? user.getPhone() : "-" %>"
                                data-roomnum="<%= roomNum %>"
                                data-roomtype="<%= roomType %>"
                                data-numguests="<%= booking.getNumberOfGuests() %>"
                                data-amount="LKR <%= String.format("%.2f", booking.getTotalAmount().doubleValue()) %>"
                                data-status="<%= booking.getStatus() %>"
                                data-special="<%= (booking.getSpecialRequests() != null && !booking.getSpecialRequests().isEmpty()) ? booking.getSpecialRequests().replace("\"","&quot;") : "-" %>">
                                <td>#<%= booking.getId() %></td>
                                <td><%= custName %></td>
                                <td><%= roomNum %> (<%= roomType %>)</td>
                                <td><%= booking.getCheckInDate() %></td>
                                <td><%= booking.getCheckOutDate() %></td>
                                <td><%= booking.getNumberOfGuests() %></td>
                                <td>LKR <%= String.format("%.2f", booking.getTotalAmount().doubleValue()) %></td>
                                <td>
                                    <select class="status-select status-<%= booking.getStatus() %>"
                                            onchange="changeStatus(<%= booking.getId() %>, this)"
                                            data-prev="<%= booking.getStatus() %>">
                                        <option value="pending"   <%= "pending".equals(booking.getStatus())   ? "selected" : "" %>>Pending</option>
                                        <option value="confirmed" <%= "confirmed".equals(booking.getStatus()) ? "selected" : "" %>>Confirmed</option>
                                        <option value="completed" <%= "completed".equals(booking.getStatus()) ? "selected" : "" %>>Completed</option>
                                        <option value="cancelled" <%= "cancelled".equals(booking.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                    </select>
                                </td>
                                <td>
                                    <a class="btn btn-outline" style="padding:.25rem .75rem;font-size:.875rem;"
                                       href="${pageContext.request.contextPath}/bookings?action=invoice&id=<%= booking.getId() %>">Invoice</a>
                                </td>
                                <td>
                                    <button class="btn btn-primary" style="padding:.25rem .75rem;font-size:.875rem;"
                                            onclick="openView(this)"><i class="bi bi-eye"></i> View</button>
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

<!-- Booking Detail Modal -->
<div class="view-modal-overlay" id="viewModalOverlay" onclick="closeView(event)">
    <div class="view-modal">
        <div class="view-modal-header">
            <h5><i class="bi bi-calendar-check" style="margin-right:.5rem;"></i>Booking Details</h5>
            <button class="view-modal-close" onclick="document.getElementById('viewModalOverlay').classList.remove('show')">&times;</button>
        </div>
        <div class="view-modal-body">
            <div class="detail-grid">
                <div class="detail-item"><label>Booking ID</label><span id="vId"></span></div>
                <div class="detail-item"><label>Status</label><span id="vStatus"></span></div>
                <div class="detail-item"><label>Guest Name</label><span id="vGuest"></span></div>
                <div class="detail-item"><label>No. of Guests</label><span id="vNumGuests"></span></div>
                <div class="detail-item"><label>Email</label><span id="vEmail"></span></div>
                <div class="detail-item"><label>Phone</label><span id="vPhone"></span></div>
                <div class="detail-item"><label>Room Number</label><span id="vRoom"></span></div>
                <div class="detail-item"><label>Room Type</label><span id="vRoomType"></span></div>
                <div class="detail-item"><label>Check-In</label><span id="vCheckIn"></span></div>
                <div class="detail-item"><label>Check-Out</label><span id="vCheckOut"></span></div>
                <div class="detail-item"><label>Total Amount</label><span id="vAmount" style="font-weight:700;color:#1298c7;"></span></div>
                <div class="detail-item" style="grid-column:1/-1"><label>Special Requests</label><span id="vSpecial"></span></div>
            </div>
        </div>
        <div class="view-modal-footer">
            <button class="btn btn-outline" onclick="document.getElementById('viewModalOverlay').classList.remove('show')">Close</button>
        </div>
    </div>
</div>

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
    function applyFilters() {
        var guest  = document.getElementById('filterGuest').value.trim().toLowerCase();
        var room   = document.getElementById('filterRoom').value.trim().toLowerCase();
        var from   = document.getElementById('filterDateFrom').value;
        var to     = document.getElementById('filterDateTo').value;
        var rows   = document.querySelectorAll('#bookingsTable tbody tr');
        var shown  = 0;
        rows.forEach(function(row) {
            var guestMatch = !guest || row.dataset.guest.includes(guest);
            var roomMatch  = !room  || row.dataset.room.includes(room);
            var checkin    = row.dataset.checkin;
            var dateFrom   = !from || checkin >= from;
            var dateTo     = !to   || checkin <= to;
            if (guestMatch && roomMatch && dateFrom && dateTo) {
                row.classList.remove('filtered-out');
                shown++;
            } else {
                row.classList.add('filtered-out');
            }
        });
        var total = rows.length;
        var el = document.getElementById('filterResults');
        el.textContent = (shown < total) ? 'Showing ' + shown + ' of ' + total + ' bookings' : total + ' bookings';
    }
    function clearFilters() {
        document.getElementById('filterGuest').value = '';
        document.getElementById('filterRoom').value = '';
        document.getElementById('filterDateFrom').value = '';
        document.getElementById('filterDateTo').value = '';
        applyFilters();
    }
    window.addEventListener('DOMContentLoaded', function() { applyFilters(); });
    function openView(btn) {
        var row = btn.closest('tr');
        var d = row.dataset;
        document.getElementById('vId').textContent       = '#' + d.id;
        document.getElementById('vGuest').textContent    = d.fullguest;
        document.getElementById('vEmail').textContent    = d.email;
        document.getElementById('vPhone').textContent    = d.phone;
        document.getElementById('vRoom').textContent     = d.roomnum;
        document.getElementById('vRoomType').textContent = d.roomtype;
        document.getElementById('vCheckIn').textContent  = d.checkin;
        document.getElementById('vCheckOut').textContent = d.checkout;
        document.getElementById('vNumGuests').textContent = d.numguests;
        document.getElementById('vAmount').textContent   = d.amount;
        document.getElementById('vSpecial').textContent  = d.special;
        var s  = d.status;
        var bg = {pending:'#fff3cd',confirmed:'#d1e7dd',completed:'#e2e3e5',cancelled:'#f8d7da'};
        var fg = {pending:'#856404',confirmed:'#0a3622',completed:'#41464b',cancelled:'#58151c'};
        var el = document.getElementById('vStatus');
        el.textContent = s.charAt(0).toUpperCase() + s.slice(1);
        el.style.cssText = 'padding:.2rem .6rem;border-radius:.3rem;font-size:.8rem;font-weight:700;background:'+(bg[s]||'#eee')+';color:'+(fg[s]||'#333');
        document.getElementById('viewModalOverlay').classList.add('show');
    }
    function closeView(e) {
        if (e.target === document.getElementById('viewModalOverlay'))
            document.getElementById('viewModalOverlay').classList.remove('show');
    }
    function changeStatus(bookingId, sel) {
        var newStatus = sel.value;
        var prev = sel.getAttribute('data-prev');
        if (!confirm('Change status to ' + newStatus + '?')) { sel.value = prev; applyStatusClass(sel, prev); return; }
        var payload = new URLSearchParams();
        payload.set('action','updateStatus'); payload.set('id', bookingId); payload.set('bookingId', bookingId); payload.set('status', newStatus); payload.set('newStatus', newStatus);
        fetch('${pageContext.request.contextPath}/bookings?' + payload.toString(), {
            method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body: payload.toString()
        }).then(function(r){ return r.json(); })
          .then(function(d){
              if (!d.success) throw new Error(d.message || 'Failed');
              sel.setAttribute('data-prev', newStatus); applyStatusClass(sel, newStatus);
          }).catch(function(e){ alert(e.message || 'Failed'); sel.value = prev; applyStatusClass(sel, prev); });
    }
    function applyStatusClass(sel, status) { sel.className = 'status-select status-' + status; }
</script>
</body>
</html>
