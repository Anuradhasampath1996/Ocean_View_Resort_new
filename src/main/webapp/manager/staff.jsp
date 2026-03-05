<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.oceanviewresortnew.dao.*" %>
<%@ page import="com.example.oceanviewresortnew.model.*" %>
<%@ page import="java.util.*" %>
<%
    if (session.getAttribute("role") == null || !"manager".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    UserDAO userDAO = new UserDAO();
    BookingDAO bookingDAO = new BookingDAO();
    List<User> allUsers = userDAO.getAllUsers();
    int staffCount = 0;
    int customerCount = 0;
    for (User u : allUsers) {
        if ("customer".equals(u.getRole())) customerCount++;
        else staffCount++;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff &amp; Guests - Manager - Ocean View Resort</title>
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
            <span class="sidebar-user-role">Manager</span>
        </div>
    </div>
    <div class="sidebar-nav-label">Navigation</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/manager/dashboard.jsp" class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
        <li class="sidebar-accordion-item">
            <button type="button" class="sidebar-link sidebar-accordion-btn" onclick="toggleBookingMenu()">
                <i class="bi bi-calendar-check"></i> Bookings <i class="bi bi-chevron-down sidebar-chevron" id="bookingChevron"></i>
            </button>
            <ul class="sidebar-submenu" id="bookingSubmenu">
                <li><a href="${pageContext.request.contextPath}/manager/bookings.jsp" class="sidebar-link sidebar-sublink"><i class="bi bi-list-ul"></i> All Bookings</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/add-booking.jsp" class="sidebar-link sidebar-sublink"><i class="bi bi-plus-circle"></i> Add Booking</a></li>
            </ul>
        </li>
        <li><a href="${pageContext.request.contextPath}/manager/rooms.jsp" class="sidebar-link"><i class="bi bi-door-open"></i> Rooms</a></li>
        <li><a href="${pageContext.request.contextPath}/manager/staff.jsp" class="sidebar-link active"><i class="bi bi-people"></i> Staff &amp; Guests</a></li>
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
        <h2 class="mb-4">Staff &amp; Guests</h2>
        <div class="grid grid-cols-4 mb-4">
            <div class="card stat-card">
                <div class="stat-value"><%= staffCount %></div>
                <div class="stat-label">Staff Members</div>
            </div>
            <div class="card stat-card">
                <div class="stat-value"><%= customerCount %></div>
                <div class="stat-label">Registered Guests</div>
            </div>
            <div class="card stat-card">
                <div class="stat-value"><%= allUsers.stream().filter(u -> "admin".equals(u.getRole()) || "manager".equals(u.getRole()) || "receptionist".equals(u.getRole())).count() %></div>
                <div class="stat-label">Total Staff</div>
            </div>
            <div class="card stat-card">
                <div class="stat-value"><%= allUsers.size() %></div>
                <div class="stat-label">Total Users</div>
            </div>
        </div>
        <div class="card">
            <div class="card-header">
                <h4 class="card-title">All Users</h4>
            </div>
            <div class="card-content p-0">
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Full Name</th>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Bookings</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User user : allUsers) {
                                String r = user.getRole();
                                int userBookings = bookingDAO.getBookingsByUserId(user.getId()).size();
                            %>
                            <tr>
                                <td>#<%= user.getId() %></td>
                                <td><strong><%= user.getFullName() %></strong></td>
                                <td><%= user.getUsername() %></td>
                                <td><%= user.getEmail() %></td>
                                <td><%= user.getPhone() != null ? user.getPhone() : "-" %></td>
                                <td>
                                    <% if ("admin".equals(r)) { %>
                                        <span class="badge badge-primary">Admin</span>
                                    <% } else if ("manager".equals(r)) { %>
                                        <span class="badge badge-warning">Manager</span>
                                    <% } else if ("receptionist".equals(r)) { %>
                                        <span class="badge badge-secondary">Receptionist</span>
                                    <% } else { %>
                                        <span class="badge badge-success">Guest</span>
                                    <% } %>
                                </td>
                                <td><%= userBookings %></td>
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
        var sidebar = document.getElementById('sidebar');
        var mainContent = document.getElementById('mainContent');
        var overlay = document.getElementById('sidebarOverlay');
        sidebar.classList.remove('collapsed', 'open');
        mainContent.classList.remove('expanded');
        overlay.classList.remove('active');
    });
</script>
</body>
</html>
