<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"admin".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BookingDAO bookingDAO=new
                    BookingDAO(); RoomDAO roomDAO=new RoomDAO(); UserDAO userDAO=new UserDAO(); int
                    totalBookings=bookingDAO.getTotalBookingsCount(); List<Room> allRooms = roomDAO.getAllRooms();
                    List<User> allUsers = userDAO.getAllUsers();
                        List<Booking> recentBookings = bookingDAO.getAllBookings();

                            int availableRooms = 0;
                            for (Room room : allRooms) {
                            if ("available".equals(room.getStatus())) {
                            availableRooms++;
                            }
                            }
                            %>
                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Admin Dashboard - Ocean View Resort</title>
                                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                    rel="stylesheet">
                                <link rel="stylesheet"
                                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
                                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                            </head>

                            <body>
                                <!-- Navbar -->
                                <nav class="navbar navbar-expand-lg navbar-light sticky-top">
                                    <div class="container-fluid navbar-container">
                                        <a href="${pageContext.request.contextPath}/index.jsp"
                                            class="navbar-brand logo-container">
                                            <img src="${pageContext.request.contextPath}/images/logo.png"
                                                alt="Ocean View Resort" class="logo-image">
                                        </a>
                                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                                            data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                                            aria-label="Toggle navigation">
                                            <span class="navbar-toggler-icon"></span>
                                        </button>
                                        <div class="collapse navbar-collapse" id="navbarNav">
                                            <ul class="navbar-nav ms-auto">
                                                <li class="nav-item"><a
                                                        href="${pageContext.request.contextPath}/admin/dashboard.jsp"
                                                        class="nav-link active"><i class="bi bi-speedometer2"></i>
                                                        Dashboard</a></li>
                                                <li class="nav-item"><a
                                                        href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                                        class="nav-link"><i class="bi bi-calendar-check"></i>
                                                        Bookings</a></li>
                                                <li class="nav-item"><a
                                                        href="${pageContext.request.contextPath}/admin/rooms.jsp"
                                                        class="nav-link"><i class="bi bi-door-open"></i> Rooms</a></li>
                                                <li class="nav-item"><a
                                                        href="${pageContext.request.contextPath}/admin/customers.jsp"
                                                        class="nav-link"><i class="bi bi-people"></i> Customers</a></li>
                                                <li class="nav-item"><span class="nav-link"><i
                                                            class="bi bi-person-circle"></i>
                                                        <%= session.getAttribute("username") %>
                                                    </span></li>
                                                <li class="nav-item">
                                                    <form action="${pageContext.request.contextPath}/auth" method="post"
                                                        style="display: inline;">
                                                        <input type="hidden" name="action" value="logout">
                                                        <button type="submit" class="btn btn-primary ms-2">
                                                            <i class="bi bi-box-arrow-right"></i> Logout
                                                        </button>
                                                    </form>
                                                </li>
                                            </ul>
                                        </div>
                                </nav>

                                <div style="display: flex;">
                                    <!-- Sidebar -->
                                    <aside class="dashboard-sidebar" style="width: 250px;">
                                        <div
                                            style="padding: 1.5rem; border-bottom: 1px solid #e5e7eb; text-align: center;">
                                            <a href="${pageContext.request.contextPath}/index.jsp"
                                                class="logo-container">
                                                <img src="${pageContext.request.contextPath}/images/logo.png"
                                                    alt="Ocean View Resort" class="logo-image sidebar">
                                            </a>
                                        </div>
                                        <ul class="sidebar-nav">
                                            <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
                                                    class="sidebar-link active">
                                                    <i class="bi bi-speedometer2"></i> Dashboard
                                                </a></li>
                                            <li><a href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                                    class="sidebar-link">
                                                    <i class="bi bi-calendar-check"></i> Bookings
                                                </a></li>
                                            <li><a href="${pageContext.request.contextPath}/admin/rooms.jsp"
                                                    class="sidebar-link">
                                                    <i class="bi bi-door-open"></i> Rooms
                                                </a></li>
                                            <li><a href="${pageContext.request.contextPath}/admin/customers.jsp"
                                                    class="sidebar-link">
                                                    <i class="bi bi-people"></i> Customers
                                                </a></li>
                                        </ul>
                                    </aside>

                                    <!-- Main Content -->
                                    <main style="flex: 1; padding: 2rem;">
                                        <div class="container-fluid">
                                            <h2 class="mb-4">Dashboard Overview</h2>

                                            <!-- Stats Cards -->
                                            <div class="grid grid-cols-4 mb-4">
                                                <div class="card stat-card">
                                                    <div class="stat-value">
                                                        <%= totalBookings %>
                                                    </div>
                                                    <div class="stat-label">Total Bookings</div>
                                                </div>
                                                <div class="card stat-card">
                                                    <div class="stat-value">
                                                        <%= allRooms.size() %>
                                                    </div>
                                                    <div class="stat-label">Total Rooms</div>
                                                </div>
                                                <div class="card stat-card">
                                                    <div class="stat-value">
                                                        <%= availableRooms %>
                                                    </div>
                                                    <div class="stat-label">Available Rooms</div>
                                                </div>
                                                <div class="card stat-card">
                                                    <div class="stat-value">
                                                        <%= allUsers.size() %>
                                                    </div>
                                                    <div class="stat-label">Total Users</div>
                                                </div>
                                            </div>

                                            <!-- Recent Bookings -->
                                            <div class="card">
                                                <div class="card-header">
                                                    <h4 class="card-title">Recent Bookings</h4>
                                                </div>
                                                <div class="card-content p-0">
                                                    <div class="table-container">
                                                        <table class="table">
                                                            <thead>
                                                                <tr>
                                                                    <th>ID</th>
                                                                    <th>Customer</th>
                                                                    <th>Room</th>
                                                                    <th>Check-in</th>
                                                                    <th>Check-out</th>
                                                                    <th>Amount</th>
                                                                    <th>Status</th>
                                                                    <th>Invoice</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% int count=0; for (Booking booking : recentBookings) {
                                                                    if (count++>= 10) break;
                                                                    %>
                                                                    <tr>
                                                                        <td>#<%= booking.getId() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= booking.getUserName() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= booking.getRoomNumber() %> (<%=
                                                                                    booking.getRoomType() %>)
                                                                        </td>
                                                                        <td>
                                                                            <%= booking.getCheckInDate() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= booking.getCheckOutDate() %>
                                                                        </td>
                                                                        <td>LKR <%=
                                                                                booking.getTotalAmount().doubleValue()
                                                                                %>
                                                                        </td>
                                                                        <td>
                                                                            <% if
                                                                                ("confirmed".equals(booking.getStatus()))
                                                                                { %>
                                                                                <span
                                                                                    class="badge badge-success">Confirmed</span>
                                                                                <% } else if
                                                                                    ("pending".equals(booking.getStatus()))
                                                                                    { %>
                                                                                    <span
                                                                                        class="badge badge-warning">Pending</span>
                                                                                    <% } else if
                                                                                        ("cancelled".equals(booking.getStatus()))
                                                                                        { %>
                                                                                        <span
                                                                                            class="badge badge-danger">Cancelled</span>
                                                                                        <% } else { %>
                                                                                            <span
                                                                                                class="badge badge-secondary">
                                                                                                <%= booking.getStatus()
                                                                                                    %>
                                                                                            </span>
                                                                                            <% } %>
                                                                        </td>
                                                                        <td>
                                                                            <a class="btn btn-outline"
                                                                                style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                                href="${pageContext.request.contextPath}/bookings?action=invoice&id=<%= booking.getId() %>">
                                                                                Download
                                                                            </a>
                                                                        </td>
                                                                    </tr>
                                                                    <% } %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <a href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                                        class="btn btn-primary">View All Bookings</a>
                                                </div>
                                            </div>
                                        </div>
                                    </main>

                                    <script
                                        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                            </body>

                            </html>