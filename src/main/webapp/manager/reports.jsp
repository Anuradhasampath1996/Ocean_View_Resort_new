<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"manager".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BookingDAO bookingDAO=new
                    BookingDAO(); RoomDAO roomDAO=new RoomDAO(); List<Booking> allBookings =
                    bookingDAO.getAllBookings();
                    List<Room> allRooms = roomDAO.getAllRooms();

                        double totalRevenue = 0;
                        int confirmedBookings = 0;
                        int cancelledBookings = 0;

                        for (Booking b : allBookings) {
                        if ("confirmed".equals(b.getStatus()) || "completed".equals(b.getStatus())) {
                        totalRevenue += b.getTotalAmount().doubleValue();
                        confirmedBookings++;
                        } else if ("cancelled".equals(b.getStatus())) {
                        cancelledBookings++;
                        }
                        }

                        int availableRooms = 0;
                        int occupiedRooms = 0;
                        for (Room r : allRooms) {
                        if ("available".equals(r.getStatus())) availableRooms++;
                        else if ("occupied".equals(r.getStatus())) occupiedRooms++;
                        }

                        double occupancyRate = allRooms.size() > 0 ? (occupiedRooms * 100.0 / allRooms.size()) : 0;
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Reports - Manager - Ocean View Resort</title>
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
                                    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">
                                        <i class="bi bi-water"></i> Ocean View Resort
                                    </a>
                                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                                        data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                                        aria-label="Toggle navigation">
                                        <span class="navbar-toggler-icon"></span>
                                    </button>
                                    <div class="collapse navbar-collapse" id="navbarNav">
                                        <ul class="navbar-nav ms-auto">
                                            <li class="nav-item"><a
                                                    href="${pageContext.request.contextPath}/manager/dashboard.jsp"
                                                    class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a>
                                            </li>
                                            <li class="nav-item"><a
                                                    href="${pageContext.request.contextPath}/manager/bookings.jsp"
                                                    class="nav-link"><i class="bi bi-calendar-check"></i> Bookings</a>
                                            </li>
                                            <li class="nav-item"><a
                                                    href="${pageContext.request.contextPath}/manager/rooms.jsp"
                                                    class="nav-link"><i class="bi bi-door-open"></i> Rooms</a></li>
                                            <li class="nav-item"><a
                                                    href="${pageContext.request.contextPath}/manager/staff.jsp"
                                                    class="nav-link"><i class="bi bi-people"></i> Staff</a></li>
                                            <li class="nav-item"><a
                                                    href="${pageContext.request.contextPath}/manager/reports.jsp"
                                                    class="nav-link active"><i class="bi bi-file-earmark-bar-graph"></i>
                                                    Reports</a></li>
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
                                </div>
                            </nav>

                            <div style="display: flex;">
                                <!-- Sidebar -->
                                <aside class="dashboard-sidebar" style="width: 250px;">
                                    <div style="padding: 1.5rem; border-bottom: 1px solid #e5e7eb;">
                                        <a href="${pageContext.request.contextPath}/index.jsp"
                                            style="text-decoration: none; color: inherit;">
                                            <h3
                                                style="margin: 0; font-size: 1.25rem; font-weight: 600; color: hsl(var(--ocean-blue));">
                                                <i class="bi bi-water"></i> Ocean View Resort
                                            </h3>
                                        </a>
                                    </div>
                                    <ul class="sidebar-nav">
                                        <li><a href="${pageContext.request.contextPath}/manager/dashboard.jsp"
                                                class="sidebar-link">
                                                <i class="bi bi-speedometer2"></i> Dashboard
                                            </a></li>
                                        <li><a href="${pageContext.request.contextPath}/manager/bookings.jsp"
                                                class="sidebar-link">
                                                <i class="bi bi-calendar-check"></i> Bookings
                                            </a></li>
                                        <li><a href="${pageContext.request.contextPath}/manager/rooms.jsp"
                                                class="sidebar-link">
                                                <i class="bi bi-door-open"></i> Rooms
                                            </a></li>
                                        <li><a href="${pageContext.request.contextPath}/manager/staff.jsp"
                                                class="sidebar-link">
                                                <i class="bi bi-people"></i> Staff & Guests
                                            </a></li>
                                        <li><a href="${pageContext.request.contextPath}/manager/reports.jsp"
                                                class="sidebar-link active">
                                                <i class="bi bi-file-earmark-bar-graph"></i> Reports
                                            </a></li>
                                    </ul>
                                </aside>

                                <main style="flex: 1; padding: 2rem;">\n <h2 class="mb-4">Business Reports & Analytics
                                    </h2>

                                    <div class="grid grid-cols-4 gap-4 mb-6">
                                        <div class="stats-card">
                                            <div class="stats-icon" style="background-color: hsl(var(--success));">
                                                <i class="bi bi-currency-dollar"></i>
                                            </div>
                                            <div>
                                                <div class="stats-value">LKR <%= String.format("%.0f", totalRevenue) %>
                                                </div>
                                                <div class="stats-label">Total Revenue</div>
                                            </div>
                                        </div>

                                        <div class="stats-card">
                                            <div class="stats-icon" style="background-color: hsl(var(--ocean-blue));">
                                                <i class="bi bi-check-circle"></i>
                                            </div>
                                            <div>
                                                <div class="stats-value">
                                                    <%= confirmedBookings %>
                                                </div>
                                                <div class="stats-label">Confirmed Bookings</div>
                                            </div>
                                        </div>

                                        <div class="stats-card">
                                            <div class="stats-icon" style="background-color: hsl(var(--warning));">
                                                <i class="bi bi-percent"></i>
                                            </div>
                                            <div>
                                                <div class="stats-value">
                                                    <%= String.format("%.1f", occupancyRate) %>%
                                                </div>
                                                <div class="stats-label">Occupancy Rate</div>
                                            </div>
                                        </div>

                                        <div class="stats-card">
                                            <div class="stats-icon" style="background-color: hsl(var(--danger));">
                                                <i class="bi bi-x-circle"></i>
                                            </div>
                                            <div>
                                                <div class="stats-value">
                                                    <%= cancelledBookings %>
                                                </div>
                                                <div class="stats-label">Cancellations</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card mb-4">
                                        <div class="card-header">
                                            <h3 class="card-title">Room Statistics</h3>
                                        </div>
                                        <div class="card-content">
                                            <div class="grid grid-cols-3 gap-4">
                                                <div class="text-center">
                                                    <h4 class="text-2xl font-bold"
                                                        style="color: hsl(var(--ocean-blue));">
                                                        <%= allRooms.size() %>
                                                    </h4>
                                                    <p class="text-muted">Total Rooms</p>
                                                </div>
                                                <div class="text-center">
                                                    <h4 class="text-2xl font-bold" style="color: hsl(var(--success));">
                                                        <%= availableRooms %>
                                                    </h4>
                                                    <p class="text-muted">Available</p>
                                                </div>
                                                <div class="text-center">
                                                    <h4 class="text-2xl font-bold" style="color: hsl(var(--warning));">
                                                        <%= occupiedRooms %>
                                                    </h4>
                                                    <p class="text-muted">Occupied</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Recent Revenue by Booking</h3>
                                        </div>
                                        <div class="card-content p-0">
                                            <div class="table-responsive">
                                                <table class="table">
                                                    <thead>
                                                        <tr>
                                                            <th>Booking ID</th>
                                                            <th>Check-In</th>
                                                            <th>Check-Out</th>
                                                            <th>Status</th>
                                                            <th>Amount</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% int count=0; for (Booking booking : allBookings) { if (count>
                                                            = 10) break;
                                                            if ("confirmed".equals(booking.getStatus()) ||
                                                            "completed".equals(booking.getStatus())) {
                                                            count++;
                                                            %>
                                                            <tr>
                                                                <td>#<%= booking.getId() %>
                                                                </td>
                                                                <td>
                                                                    <%= booking.getCheckInDate() %>
                                                                </td>
                                                                <td>
                                                                    <%= booking.getCheckOutDate() %>
                                                                </td>
                                                                <td><span class="badge badge-success">
                                                                        <%= booking.getStatus() %>
                                                                    </span></td>
                                                                <td class="font-bold"
                                                                    style="color: hsl(var(--success));">LKR <%=
                                                                        String.format("%.2f",
                                                                        booking.getTotalAmount().doubleValue()) %>
                                                                </td>
                                                            </tr>
                                                            <% } } %>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </main>
                            </div>

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        </body>

                        </html>