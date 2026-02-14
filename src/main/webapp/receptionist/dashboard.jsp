<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <%@ page import="java.time.LocalDate" %>
                    <% if (session.getAttribute("role")==null || !"receptionist".equals(session.getAttribute("role"))) {
                        response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BookingDAO
                        bookingDAO=new BookingDAO(); RoomDAO roomDAO=new RoomDAO(); UserDAO userDAO=new UserDAO();
                        List<Room> allRooms = roomDAO.getAllRooms();
                        List<Booking> todaysBookings = bookingDAO.getAllBookings();

                            int availableRooms = 0;
                            int occupiedRooms = 0;
                            int maintenanceRooms = 0;

                            for (Room room : allRooms) {
                            if ("available".equals(room.getStatus())) {
                            availableRooms++;
                            } else if ("occupied".equals(room.getStatus())) {
                            occupiedRooms++;
                            } else if ("maintenance".equals(room.getStatus())) {
                            maintenanceRooms++;
                            }
                            }

                            // Count today's check-ins and check-outs
                            LocalDate today = LocalDate.now();
                            int todaysCheckIns = 0;
                            int todaysCheckOuts = 0;

                            for (Booking booking : todaysBookings) {
                            if (booking.getCheckInDate().toString().equals(today.toString()) &&
                            "confirmed".equals(booking.getStatus())) {
                            todaysCheckIns++;
                            }
                            if (booking.getCheckOutDate().toString().equals(today.toString()) &&
                            ("confirmed".equals(booking.getStatus()) || "completed".equals(booking.getStatus()))) {
                            todaysCheckOuts++;
                            }
                            }
                            %>
                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Reception Desk - Ocean View Resort</title>
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
                                                        href="${pageContext.request.contextPath}/receptionist/dashboard.jsp"
                                                        class="nav-link active"><i class="bi bi-speedometer2"></i>
                                                        Dashboard</a></li>
                                                <li class="nav-item"><a
                                                        href="${pageContext.request.contextPath}/receptionist/check-in.jsp"
                                                        class="nav-link"><i class="bi bi-box-arrow-in-right"></i>
                                                        Check-In</a></li>
                                                <li class="nav-item"><a
                                                        href="${pageContext.request.contextPath}/receptionist/check-out.jsp"
                                                        class="nav-link"><i class="bi bi-box-arrow-left"></i>
                                                        Check-Out</a></li>
                                                <li class="nav-item"><a
                                                        href="${pageContext.request.contextPath}/receptionist/rooms.jsp"
                                                        class="nav-link"><i class="bi bi-door-open"></i> Rooms</a></li>
                                                <li class="nav-item"><a
                                                        href="${pageContext.request.contextPath}/receptionist/bookings.jsp"
                                                        class="nav-link"><i class="bi bi-calendar-check"></i>
                                                        Bookings</a></li>
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
                                            <li><a href="${pageContext.request.contextPath}/receptionist/dashboard.jsp"
                                                    class="sidebar-link active">
                                                    <i class="bi bi-speedometer2"></i> Dashboard
                                                </a></li>
                                            <li><a href="${pageContext.request.contextPath}/receptionist/check-in.jsp"
                                                    class="sidebar-link">
                                                    <i class="bi bi-box-arrow-in-right"></i> Check-In
                                                </a></li>
                                            <li><a href="${pageContext.request.contextPath}/receptionist/check-out.jsp"
                                                    class="sidebar-link">
                                                    <i class="bi bi-box-arrow-left"></i> Check-Out
                                                </a></li>
                                            <li><a href="${pageContext.request.contextPath}/receptionist/rooms.jsp"
                                                    class="sidebar-link">
                                                    <i class="bi bi-door-open"></i> Room Status
                                                </a></li>
                                            <li><a href="${pageContext.request.contextPath}/receptionist/bookings.jsp"
                                                    class="sidebar-link">
                                                    <i class="bi bi-calendar-check"></i> Bookings
                                                </a></li>
                                        </ul>
                                    </aside>

                                    <!-- Main Content -->
                                    <main style="flex: 1; padding: 2rem;">
                                        <h1 class="text-3xl font-bold mb-2">Reception Desk</h1>
                                        <p class="text-muted mb-6">Today's Date: <%= LocalDate.now() %>
                                        </p>

                                        <!-- Quick Stats -->
                                        <div class="grid grid-cols-4 gap-4 mb-8">
                                            <div class="stats-card">
                                                <div class="stats-icon" style="background-color: hsl(var(--success));">
                                                    <i class="bi bi-door-open"></i>
                                                </div>
                                                <div>
                                                    <div class="stats-value">
                                                        <%= availableRooms %>
                                                    </div>
                                                    <div class="stats-label">Available Rooms</div>
                                                </div>
                                            </div>

                                            <div class="stats-card">
                                                <div class="stats-icon" style="background-color: hsl(var(--warning));">
                                                    <i class="bi bi-door-closed"></i>
                                                </div>
                                                <div>
                                                    <div class="stats-value">
                                                        <%= occupiedRooms %>
                                                    </div>
                                                    <div class="stats-label">Occupied Rooms</div>
                                                </div>
                                            </div>

                                            <div class="stats-card">
                                                <div class="stats-icon"
                                                    style="background-color: hsl(var(--ocean-blue));">
                                                    <i class="bi bi-box-arrow-in-right"></i>
                                                </div>
                                                <div>
                                                    <div class="stats-value">
                                                        <%= todaysCheckIns %>
                                                    </div>
                                                    <div class="stats-label">Today's Check-Ins</div>
                                                </div>
                                            </div>

                                            <div class="stats-card">
                                                <div class="stats-icon" style="background-color: hsl(var(--primary));">
                                                    <i class="bi bi-box-arrow-left"></i>
                                                </div>
                                                <div>
                                                    <div class="stats-value">
                                                        <%= todaysCheckOuts %>
                                                    </div>
                                                    <div class="stats-label">Today's Check-Outs</div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Room Status Overview -->
                                        <div class="card mb-4">
                                            <div class="card-header">
                                                <h3 class="card-title">Room Status Overview</h3>
                                            </div>
                                            <div class="card-content">
                                                <div class="table-responsive">
                                                    <table class="table">
                                                        <thead>
                                                            <tr>
                                                                <th>Room Number</th>
                                                                <th>Room Type</th>
                                                                <th>Capacity</th>
                                                                <th>Price/Night</th>
                                                                <th>Status</th>
                                                                <th>Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for (Room room : allRooms) { %>
                                                                <tr>
                                                                    <td><strong>
                                                                            <%= room.getRoomNumber() %>
                                                                        </strong></td>
                                                                    <td>
                                                                        <%= room.getRoomType() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= room.getCapacity() %> guests
                                                                    </td>
                                                                    <td>LKR <%= String.format("%.2f",
                                                                            room.getPricePerNight()) %>
                                                                    </td>
                                                                    <td>
                                                                        <% String roomStatusBadge="danger" ; if
                                                                            ("available".equals(room.getStatus())) {
                                                                            roomStatusBadge="success" ; } else if
                                                                            ("occupied".equals(room.getStatus())) {
                                                                            roomStatusBadge="warning" ; } %>
                                                                            <span
                                                                                class="badge badge-<%= roomStatusBadge %>">
                                                                                <%= room.getStatus().substring(0,
                                                                                    1).toUpperCase() +
                                                                                    room.getStatus().substring(1) %>
                                                                            </span>
                                                                    </td>
                                                                    <td>
                                                                        <% if ("available".equals(room.getStatus())) {
                                                                            %>
                                                                            <a href="${pageContext.request.contextPath}/receptionist/check-in.jsp?roomId=<%= room.getId() %>"
                                                                                class="btn btn-sm btn-primary">Check-In</a>
                                                                            <% } else if
                                                                                ("occupied".equals(room.getStatus())) {
                                                                                %>
                                                                                <a href="${pageContext.request.contextPath}/receptionist/check-out.jsp?roomId=<%= room.getId() %>"
                                                                                    class="btn btn-sm btn-secondary">Check-Out</a>
                                                                                <% } %>
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Today's Expected Arrivals -->
                                        <div class="card">
                                            <div class="card-header">
                                                <h3 class="card-title">Expected Arrivals Today</h3>
                                            </div>
                                            <div class="card-content">
                                                <div class="table-responsive">
                                                    <table class="table">
                                                        <thead>
                                                            <tr>
                                                                <th>Booking ID</th>
                                                                <th>Guest Name</th>
                                                                <th>Room</th>
                                                                <th>Guests</th>
                                                                <th>Check-Out Date</th>
                                                                <th>Status</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% boolean hasArrivals=false; for (Booking booking :
                                                                todaysBookings) { if
                                                                (booking.getCheckInDate().toString().equals(today.toString())
                                                                && "confirmed" .equals(booking.getStatus())) {
                                                                hasArrivals=true; User
                                                                user=userDAO.getUserById(booking.getUserId()); Room
                                                                room=roomDAO.getRoomById(booking.getRoomId()); %>
                                                                <tr>
                                                                    <td>#<%= booking.getId() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= user !=null ? user.getFullName() : "Unknown"
                                                                            %>
                                                                    </td>
                                                                    <td>
                                                                        <%= room !=null ? room.getRoomNumber()
                                                                            : "Unknown" %>
                                                                    </td>
                                                                    <td>
                                                                        <%= booking.getNumberOfGuests() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= booking.getCheckOutDate() %>
                                                                    </td>
                                                                    <td><span
                                                                            class="badge badge-warning">Confirmed</span>
                                                                    </td>
                                                                </tr>
                                                                <% } } if (!hasArrivals) { %>
                                                                    <tr>
                                                                        <td colspan="6" class="text-center">No
                                                                            arrivals
                                                                            expected today</td>
                                                                    </tr>
                                                                    <% } %>
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