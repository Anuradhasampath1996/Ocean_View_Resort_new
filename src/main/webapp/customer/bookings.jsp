<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"customer".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } int userId=(int)
                    session.getAttribute("userId"); BookingDAO bookingDAO=new BookingDAO(); List<Booking> myBookings =
                    bookingDAO.getBookingsByUserId(userId);
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>My Bookings - Ocean View Resort</title>
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
                                    <li><span class="nav-link">Welcome, <%= session.getAttribute("username") %></span>
                                    </li>
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
                                <div style="padding: 1.5rem; border-bottom: 1px solid #e5e7eb; text-align: center;">
                                    <a href="${pageContext.request.contextPath}/index.jsp" class="logo-container">
                                        <img src="${pageContext.request.contextPath}/images/logo.png"
                                            alt="Ocean View Resort" class="logo-image sidebar">
                                    </a>
                                </div>
                                <ul class="sidebar-nav">
                                    <li><a href="${pageContext.request.contextPath}/customer/bookings.jsp"
                                            class="sidebar-link active">
                                            <i class="bi bi-calendar-check"></i> My Bookings
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/customer/book-room.jsp"
                                            class="sidebar-link">
                                            <i class="bi bi-door-open"></i> Book a Room
                                        </a></li>
                                </ul>
                            </aside>

                            <main style="flex: 1; padding: 2rem;">
                                <div class="container-fluid">
                                    <div class="flex justify-between items-center mb-4">
                                        <h2>My Bookings</h2>
                                        <a href="${pageContext.request.contextPath}/customer/book-room.jsp"
                                            class="btn btn-primary">
                                            <i class="bi bi-plus-circle"></i> New Booking
                                        </a>
                                    </div>

                                    <% if (request.getParameter("success") !=null) { %>
                                        <div class="alert alert-success">
                                            <% if ("booking_created".equals(request.getParameter("success"))) { %>
                                                Booking created successfully! Your booking is pending confirmation.
                                                <% } else if
                                                    ("booking_cancelled".equals(request.getParameter("success"))) { %>
                                                    Booking cancelled successfully.
                                                    <% } %>
                                        </div>
                                        <% } %>

                                            <% if (myBookings.isEmpty()) { %>
                                                <div class="card">
                                                    <div class="card-content text-center" style="padding: 4rem 2rem;">
                                                        <i class="bi bi-calendar-x"
                                                            style="font-size: 4rem; color: hsl(var(--muted-foreground));"></i>
                                                        <h4 class="mt-3">No Bookings Yet</h4>
                                                        <p class="text-muted">You haven't made any bookings. Start
                                                            exploring our rooms!</p>
                                                        <a href="${pageContext.request.contextPath}/customer/book-room.jsp"
                                                            class="btn btn-primary mt-3">
                                                            Browse Rooms
                                                        </a>
                                                    </div>
                                                </div>
                                                <% } else { %>
                                                    <div class="grid grid-cols-1" style="gap: 1rem;">
                                                        <% for (Booking booking : myBookings) { %>
                                                            <div class="card">
                                                                <div class="card-content">
                                                                    <div class="flex justify-between items-center">
                                                                        <div style="flex: 1;">
                                                                            <div class="flex items-center gap-2 mb-2">
                                                                                <h4>Room <%= booking.getRoomNumber() %>
                                                                                </h4>
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
                                                                                            <% } else if
                                                                                                ("completed".equals(booking.getStatus()))
                                                                                                { %>
                                                                                                <span
                                                                                                    class="badge badge-secondary">Completed</span>
                                                                                                <% } %>
                                                                            </div>
                                                                            <p class="text-muted">
                                                                                <%= booking.getRoomType().replace("_", " "
                                                                                    ).toUpperCase() %>
                                                                            </p>

                                                                            <div class="grid grid-cols-3 mt-3"
                                                                                style="gap: 2rem;">
                                                                                <div>
                                                                                    <small
                                                                                        class="text-muted">Check-in</small>
                                                                                    <p><i class="bi bi-calendar"></i>
                                                                                        <%= booking.getCheckInDate() %>
                                                                                    </p>
                                                                                </div>
                                                                                <div>
                                                                                    <small
                                                                                        class="text-muted">Check-out</small>
                                                                                    <p><i class="bi bi-calendar"></i>
                                                                                        <%= booking.getCheckOutDate() %>
                                                                                    </p>
                                                                                </div>
                                                                                <div>
                                                                                    <small
                                                                                        class="text-muted">Guests</small>
                                                                                    <p><i class="bi bi-people"></i>
                                                                                        <%= booking.getNumberOfGuests()
                                                                                            %>
                                                                                    </p>
                                                                                </div>
                                                                            </div>

                                                                            <% if (booking.getSpecialRequests() !=null
                                                                                &&
                                                                                !booking.getSpecialRequests().isEmpty())
                                                                                { %>
                                                                                <div class="mt-3">
                                                                                    <small class="text-muted">Special
                                                                                        Requests:</small>
                                                                                    <p>
                                                                                        <%= booking.getSpecialRequests()
                                                                                            %>
                                                                                    </p>
                                                                                </div>
                                                                                <% } %>
                                                                        </div>

                                                                        <div
                                                                            style="text-align: right; padding-left: 2rem;">
                                                                            <div class="room-price">LKR <%=
                                                                                    booking.getTotalAmount().doubleValue()
                                                                                    %>
                                                                            </div>
                                                                            <small class="text-muted">Total
                                                                                Amount</small>

                                                                            <% if ("pending".equals(booking.getStatus())
                                                                                || "confirmed"
                                                                                .equals(booking.getStatus())) { %>
                                                                                <button class="btn btn-outline mt-3"
                                                                                    onclick="cancelBooking(<%= booking.getId() %>)">
                                                                                    <i class="bi bi-x-circle"></i>
                                                                                    Cancel
                                                                                </button>
                                                                                <% } %>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="card-footer">
                                                                    <small class="text-muted">
                                                                        <i class="bi bi-clock"></i> Booked on <%=
                                                                            booking.getCreatedAt() %>
                                                                    </small>
                                                                </div>
                                                            </div>
                                                            <% } %>
                                                    </div>
                                                    <% } %>
                                </div>
                            </main>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            function cancelBooking(bookingId) {
                                if (confirm('Are you sure you want to cancel this booking?')) {
                                    fetch('${pageContext.request.contextPath}/bookings', {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                        body: 'action=cancel&id=' + bookingId
                                    })
                                        .then(response => response.json())
                                        .then(data => {
                                            if (data.success) {
                                                window.location.href = '${pageContext.request.contextPath}/customer/bookings.jsp?success=booking_cancelled';
                                            } else {
                                                alert('Failed to cancel booking');
                                            }
                                        });
                                }
                            }
                        </script>
                    </body>

                    </html>