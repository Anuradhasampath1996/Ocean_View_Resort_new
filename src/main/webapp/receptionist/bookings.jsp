<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"receptionist".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BookingDAO bookingDAO=new
                    BookingDAO(); UserDAO userDAO=new UserDAO(); RoomDAO roomDAO=new RoomDAO(); List<Booking>
                    allBookings = bookingDAO.getAllBookings();
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Bookings - Receptionist - Ocean View Resort</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link rel="stylesheet"
                            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                    </head>

                    <body>
                        <nav class="navbar">
                            <div class="navbar-container">
                                <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">
                                    <i class="bi bi-water"></i> Ocean View Resort
                                </a>
                                <ul class="navbar-nav">
                                    <li><span class="nav-link"><i class="bi bi-person-circle"></i>
                                            <%= session.getAttribute("username") %> (Receptionist)
                                        </span></li>
                                    <li>
                                        <form action="${pageContext.request.contextPath}/auth" method="post"
                                            style="display: inline;">
                                            <input type="hidden" name="action" value="logout">
                                            <button type="submit" class="btn btn-ghost">
                                                <i class="bi bi-box-arrow-right"></i> Logout
                                            </button>
                                        </form>
                                    </li>
                                </ul>
                            </div>
                        </nav>

                        <div style="display: flex;">
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
                                            class="sidebar-link">
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
                                            class="sidebar-link active">
                                            <i class="bi bi-calendar-check"></i> Bookings
                                        </a></li>
                                </ul>
                            </aside>

                            <main style="flex: 1; padding: 2rem;">
                                <h2 class="mb-4">All Bookings</h2>

                                <div class="card">
                                    <div class="card-content p-0">
                                        <div class="table-responsive">
                                            <table class="table">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Guest Name</th>
                                                        <th>Room</th>
                                                        <th>Check-In</th>
                                                        <th>Check-Out</th>
                                                        <th>Guests</th>
                                                        <th>Status</th>
                                                        <th>Amount</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% for (Booking booking : allBookings) { User
                                                        user=userDAO.getUserById(booking.getUserId()); Room
                                                        room=roomDAO.getRoomById(booking.getRoomId()); String
                                                        statusBadge="secondary" ; if
                                                        ("confirmed".equals(booking.getStatus())) {
                                                        statusBadge="success" ; } else if
                                                        ("pending".equals(booking.getStatus())) { statusBadge="warning"
                                                        ; } else if ("cancelled".equals(booking.getStatus())) {
                                                        statusBadge="danger" ; } %>
                                                        <tr>
                                                            <td>#<%= booking.getId() %>
                                                            </td>
                                                            <td>
                                                                <%= user !=null ? user.getFullName() : "Unknown" %>
                                                            </td>
                                                            <td>
                                                                <%= room !=null ? room.getRoomNumber() : "Unknown" %>
                                                            </td>
                                                            <td>
                                                                <%= booking.getCheckInDate() %>
                                                            </td>
                                                            <td>
                                                                <%= booking.getCheckOutDate() %>
                                                            </td>
                                                            <td>
                                                                <%= booking.getNumberOfGuests() %>
                                                            </td>
                                                            <td>
                                                                <span class="badge badge-<%= statusBadge %>">
                                                                    <%= booking.getStatus().substring(0,
                                                                        1).toUpperCase() +
                                                                        booking.getStatus().substring(1) %>
                                                                </span>
                                                            </td>
                                                            <td>LKR <%= String.format("%.2f",
                                                                    booking.getTotalAmount().doubleValue()) %>
                                                            </td>
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