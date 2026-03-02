<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <%@ page import="java.time.LocalDate" %>
                    <% if (session.getAttribute("role")==null || !"receptionist".equals(session.getAttribute("role"))) {
                        response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BookingDAO
                        bookingDAO=new BookingDAO(); UserDAO userDAO=new UserDAO(); RoomDAO roomDAO=new RoomDAO(); //
                        Get today's check-ins LocalDate today=LocalDate.now(); List<Booking> todayCheckIns = new
                        ArrayList<>();
                            for (Booking booking : bookingDAO.getAllBookings()) {
                            if (booking.getCheckInDate().equals(today) && "confirmed".equals(booking.getStatus())) {
                            todayCheckIns.add(booking);
                            }
                            }
                            %>
                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Check-In - Receptionist - Ocean View Resort</title>
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
                                            <img src="${pageContext.request.contextPath}/images/logo.png"
                                                alt="Ocean View Resort" class="logo-image">
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
                                        <div
                                            style="padding: 1.5rem; border-bottom: 1px solid #e5e7eb; text-align: center;">
                                            <a href="${pageContext.request.contextPath}/index.jsp"
                                                class="logo-container">
                                                <img src="${pageContext.request.contextPath}/images/logo.png"
                                                    alt="Ocean View Resort" class="logo-image sidebar">
                                            </a>
                                        </div>
                                        <ul class="sidebar-nav">
                                            <li><a href="${pageContext.request.contextPath}/receptionist/dashboard.jsp"
                                                    class="sidebar-link">
                                                    <i class="bi bi-speedometer2"></i> Dashboard
                                                </a></li>
                                            <li><a href="${pageContext.request.contextPath}/receptionist/check-in.jsp"
                                                    class="sidebar-link active">
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

                                    <main style="flex: 1; padding: 2rem;">
                                        <h2 class="mb-4">Today's Check-Ins</h2>

                                        <div class="row mb-4">
                                            <div class="col-md-4">
                                                <div class="card stat-card">
                                                    <div class="card-content">
                                                        <div class="stat-info">
                                                            <p class="stat-title">Expected Today</p>
                                                            <h3 class="stat-value">
                                                                <%= todayCheckIns.size() %>
                                                            </h3>
                                                        </div>
                                                        <div class="stat-icon bg-primary">
                                                            <i class="bi bi-box-arrow-in-right"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="card">
                                            <div class="card-header">
                                                <h5 class="mb-0">Guests Checking In Today</h5>
                                            </div>
                                            <div class="card-content p-0">
                                                <% if (todayCheckIns.isEmpty()) { %>
                                                    <div class="p-4 text-center text-muted">
                                                        <i class="bi bi-inbox" style="font-size: 3rem;"></i>
                                                        <p class="mt-2">No check-ins scheduled for today</p>
                                                    </div>
                                                    <% } else { %>
                                                        <div class="table-responsive">
                                                            <table class="table">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Booking ID</th>
                                                                        <th>Guest Name</th>
                                                                        <th>Room Number</th>
                                                                        <th>Room Type</th>
                                                                        <th>Check-In Date</th>
                                                                        <th>Check-Out Date</th>
                                                                        <th>Guests</th>
                                                                        <th>Action</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <% for (Booking booking : todayCheckIns) { User
                                                                        user=userDAO.getUserById(booking.getUserId());
                                                                        Room
                                                                        room=roomDAO.getRoomById(booking.getRoomId());
                                                                        %>
                                                                        <tr>
                                                                            <td>#<%= booking.getId() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= user !=null ? user.getFullName()
                                                                                    : "Unknown" %>
                                                                            </td>
                                                                            <td>
                                                                                <%= room !=null ? room.getRoomNumber()
                                                                                    : "N/A" %>
                                                                            </td>
                                                                            <td>
                                                                                <%= room !=null ? room.getType() : "N/A"
                                                                                    %>
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
                                                                                <button class="btn btn-primary btn-sm"
                                                                                    onclick="checkInGuest(<%= booking.getId() %>)">
                                                                                    <i class="bi bi-check-circle"></i>
                                                                                    Check In
                                                                                </button>
                                                                            </td>
                                                                        </tr>
                                                                        <% } %>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                        <% } %>
                                            </div>
                                        </div>

                                        <div class="card mt-4">
                                            <div class="card-header">
                                                <h5 class="mb-0">Walk-In Guest Registration</h5>
                                            </div>
                                            <div class="card-content">
                                                <form id="walkInForm">
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label for="guestName" class="form-label">Guest Name</label>
                                                            <input type="text" class="form-control" id="guestName"
                                                                required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label for="guestEmail" class="form-label">Email</label>
                                                            <input type="email" class="form-control" id="guestEmail"
                                                                required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label for="guestPhone" class="form-label">Phone</label>
                                                            <input type="tel" class="form-control" id="guestPhone"
                                                                required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label for="roomType" class="form-label">Room Type</label>
                                                            <select class="form-control" id="roomType" required>
                                                                <option value="">Select Room Type</option>
                                                                <option value="single">Single Room</option>
                                                                <option value="double">Double Room</option>
                                                                <option value="suite">Suite</option>
                                                                <option value="deluxe">Deluxe Suite</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label for="checkOutDate" class="form-label">Check-Out
                                                                Date</label>
                                                            <input type="date" class="form-control" id="checkOutDate"
                                                                required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label for="numberOfGuests" class="form-label">Number of
                                                                Guests</label>
                                                            <input type="number" class="form-control"
                                                                id="numberOfGuests" min="1" max="4" value="1" required>
                                                        </div>
                                                    </div>
                                                    <button type="submit" class="btn btn-primary">
                                                        <i class="bi bi-plus-circle"></i> Register Walk-In Guest
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </main>
                                </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    function checkInGuest(bookingId) {
                                        if (confirm('Confirm check-in for booking #' + bookingId + '?')) {
                                            alert('Guest checked in successfully! (Backend functionality pending)');
                                        }
                                    }

                                    document.getElementById('walkInForm').addEventListener('submit', function (e) {
                                        e.preventDefault();
                                        alert('Walk-in guest registered successfully! (Backend functionality pending)');
                                        this.reset();
                                    });
                                </script>
                            </body>

                            </html>