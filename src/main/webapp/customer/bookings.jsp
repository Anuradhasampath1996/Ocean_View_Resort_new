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
                        <meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                        <title>My Bookings - Ocean View Resort</title>
                        <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
                        <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">
                        <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
                                            </head>

                    <body id="page-top">
<div id="wrapper">
<!-- Sidebar -->
<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">
    <a class="sidebar-brand d-flex align-items-center justify-content-center" href="${pageContext.request.contextPath}/login.jsp">
        <div class="sidebar-brand-icon">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="Ocean View Resort" style="height:40px;">
        </div>
        <div class="sidebar-brand-text mx-3">Ocean View Resort</div>
    </a>
    <hr class="sidebar-divider my-0">
    <li class="nav-item active">
        <a class="nav-link" href="${pageContext.request.contextPath}/customer/bookings.jsp">
            <i class="fas fa-fw fa-calendar-check"></i>
            <span>My Bookings</span>
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/customer/book-room.jsp">
            <i class="fas fa-fw fa-door-open"></i>
            <span>Book a Room</span>
        </a>
    </li>
    <hr class="sidebar-divider d-none d-md-block">
    <div class="text-center d-none d-md-inline">
        <button class="rounded-circle border-0" id="sidebarToggle"></button>
    </div>
</ul>
<!-- End of Sidebar -->
<!-- Content Wrapper -->
<div id="content-wrapper" class="d-flex flex-column">
<div id="content">
<!-- Topbar -->
<nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
    <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
        <i class="fa fa-bars"></i>
    </button>
    <ul class="navbar-nav ml-auto">
        <li class="nav-item dropdown no-arrow">
            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
               data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <span class="mr-2 d-none d-lg-inline text-gray-600 small"><%= session.getAttribute("username") %></span>
                <img class="img-profile rounded-circle" src="${pageContext.request.contextPath}/images/logo.png">
            </a>
            <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
                <div class="dropdown-divider"></div>
                <form action="${pageContext.request.contextPath}/auth" method="post">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="dropdown-item">
                        <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                        Logout
                    </button>
                </form>
            </div>
        </li>
    </ul>
</nav>
<!-- End of Topbar -->
<div class="container-fluid">

                        
                                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                                        <h1 class="h3 mb-0 text-gray-800">My Bookings</h1>
                                        <a href="${pageContext.request.contextPath}/customer/book-room.jsp"
                                            class="btn btn-primary">
                                            <i class="fas fa-plus-circle"></i> New Booking
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
                                                <div class="card shadow mb-4">
                                                    <div class="card-body text-center" style="padding: 4rem 2rem;">
                                                        <i class="fas fa-calendar-times"
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
                                                    <div class="row" style="gap: 1rem;">
                                                        <% for (Booking booking : myBookings) { %>
                                                            <div class="card shadow mb-4">
                                                                <div class="card-body">
                                                                    <div class="d-flex justify-content-between align-items-center">
                                                                        <div class="flex-fill">
                                                                            <div class="d-flex align-items-center mb-2">
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

                                                                            <div class="row mt-3">
                                                                                <div>
                                                                                    <small
                                                                                        class="text-muted">Check-in</small>
                                                                                    <p><i class="fas fa-calendar"></i>
                                                                                        <%= booking.getCheckInDate() %>
                                                                                    </p>
                                                                                </div>
                                                                                <div>
                                                                                    <small
                                                                                        class="text-muted">Check-out</small>
                                                                                    <p><i class="fas fa-calendar"></i>
                                                                                        <%= booking.getCheckOutDate() %>
                                                                                    </p>
                                                                                </div>
                                                                                <div>
                                                                                    <small
                                                                                        class="text-muted">Guests</small>
                                                                                    <p><i class="fas fa-users"></i>
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
                                                                            <div class="h5 font-weight-bold text-primary">LKR <%=
                                                                                    booking.getTotalAmount().doubleValue()
                                                                                    %>
                                                                            </div>
                                                                            <small class="text-muted">Total
                                                                                Amount</small>

                                                                            <% if ("pending".equals(booking.getStatus())
                                                                                || "confirmed"
                                                                                .equals(booking.getStatus())) { %>
                                                                                <button class="btn btn-sm btn-outline-danger mt-3"
                                                                                    onclick="cancelBooking(<%= booking.getId() %>)">
                                                                                    <i class="fas fa-times-circle"></i>
                                                                                    Cancel
                                                                                </button>
                                                                                <% } %>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="card-footer">
                                                                    <small class="text-muted">
                                                                        <i class="fas fa-clock"></i> Booked on <%=
                                                                            booking.getCreatedAt() %>
                                                                    </small>
                                                                </div>
                                                            </div>
                                                            <% } %>
                                                    </div>
                                                    <% } %>
                                </div>
        </div>
        <footer class="sticky-footer bg-white">
            <div class="container my-auto">
                <div class="copyright text-center my-auto">
                    <span>Ocean View Resort &copy; 2024</span>
                </div>
            </div>
        </footer>
    </div>
</div>
<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
</a>
<script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>
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