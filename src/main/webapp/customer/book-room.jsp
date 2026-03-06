<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"customer".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } RoomDAO roomDAO=new
                    RoomDAO(); List<Room> availableRooms = roomDAO.getAvailableRooms();
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                        <title>Book a Room - Ocean View Resort</title>
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
    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/customer/bookings.jsp">
            <i class="fas fa-fw fa-calendar-check"></i>
            <span>My Bookings</span>
        </a>
    </li>
    <li class="nav-item active">
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

                        
                                    <div class="d-sm-flex align-items-center justify-content-between mb-4"><h1 class="h3 mb-0 text-gray-800">Book a Room</h1></div>

                                    <% if (request.getParameter("error") !=null) { %>
                                        <div class="alert alert-danger">
                                            <% if ("room_not_available".equals(request.getParameter("error"))) { %>
                                                Room is not available for the selected dates.
                                                <% } else if ("booking_failed".equals(request.getParameter("error"))) {
                                                    %>
                                                    Booking failed. Please try again.
                                                    <% } else { %>
                                                        An error occurred. Please try again.
                                                        <% } %>
                                        </div>
                                        <% } %>

                                            <div class="row">
                                                <% for (Room room : availableRooms) { %>
                                                    <div class="col-xl-4 col-md-6 mb-4"><div class="card shadow h-100">
                                                        <img src="<%= room.getImageUrl() %>"
                                                            alt="<%= room.getRoomType() %>" class="card-img-top" style="height:200px;object-fit:cover;">
                                                        <div class="card-body">
                                                            <span class="badge badge-primary mb-2">
                                                                <%= room.getRoomType().replace("_", " " ).toUpperCase()
                                                                    %>
                                                            </span>
                                                            <h4 class="mt-2">Room <%= room.getRoomNumber() %>
                                                            </h4>
                                                            <p class="text-muted mt-2">
                                                                <%= room.getDescription() %>
                                                            </p>
                                                            <p class="text-muted mt-2">
                                                                <i class="fas fa-users"></i> Capacity: <%=
                                                                    room.getCapacity() %> guests
                                                            </p>
                                                            <p class="text-muted"><small>
                                                                    <%= room.getAmenities() %>
                                                                </small></p>
                                                            <div class="d-flex align-items-center justify-content-between mt-3">
                                                                <div class="h5 font-weight-bold text-primary">LKR <%= room.getPricePerNight()
                                                                        %>
                                                                        <span class="text-muted"
                                                                            style="font-size: 0.875rem;">/night</span>
                                                                </div>
                                                                <button class="btn btn-primary"
                                                                    onclick="showBookingModal(<%= room.getId() %>, '<%= room.getRoomNumber() %>', <%= room.getPricePerNight() %>, <%= room.getCapacity() %>)">
                                                                    Book Now
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <% } %>
                                            </div>
                                </div>
                        </div>

                        <!-- Booking Modal -->
                        <div id="bookingModal"
                            class="modal-backdrop" style="display:none;">
                            <div class="card shadow mb-4" style="max-width: 500px; margin: 2rem;">
                                <div class="card-header py-3">
                                    <h5 class="modal-title font-weight-bold">Book Room <span id="modalRoomNumber"></span></h4>
                                </div>
                                <div class="card-body">
                                    <form action="${pageContext.request.contextPath}/bookings" method="post"
                                        onsubmit="return validateBooking()">
                                        <input type="hidden" name="action" value="create">
                                        <input type="hidden" name="roomId" id="modalRoomId">

                                        <div class="form-group">
                                            <label class="font-weight-bold small">Check-in Date *</label>
                                            <input type="date" name="checkIn" id="checkIn" class="form-control" required
                                                min="<%= java.time.LocalDate.now() %>">
                                        </div>

                                        <div class="form-group">
                                            <label class="font-weight-bold small">Check-out Date *</label>
                                            <input type="date" name="checkOut" id="checkOut" class="form-control"
                                                required>
                                        </div>

                                        <div class="form-group">
                                            <label class="font-weight-bold small">Number of Guests *</label>
                                            <input type="number" name="numberOfGuests" id="numberOfGuests"
                                                class="form-control" required min="1" max="10">
                                            <small class="text-muted">Max capacity: <span id="maxCapacity"></span>
                                                guests</small>
                                        </div>

                                        <div class="form-group">
                                            <label class="font-weight-bold small">Special Requests</label>
                                            <textarea name="specialRequests" class="form-control"
                                                placeholder="Any special requests..."></textarea>
                                        </div>

                                        <div class="p-3 mb-3"
                                            class="bg-light p-2 rounded">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Price per night:</span>
                                                <strong>LKR <span id="pricePerNight"></span></strong>
                                            </div>
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Number of nights:</span>
                                                <strong><span id="numberOfNights">0</span></strong>
                                            </div>
                                            <hr>
                                            <div class="d-flex justify-content-between">
                                                <span><strong>Total Amount:</strong></span>
                                                <strong style="color: hsl(var(--ocean-blue)); font-size: 1.25rem;">LKR
                                                    <span </div>

                                                        <div class="d-flex gap-2">
                                                            <button type="button" class="btn btn-secondary"
                                                                onclick="closeBookingModal()">Cancel</button>
                                                            <button type="submit" class="btn btn-primary"
                                                                class="flex-fill">Confirm
                                                                Booking</button>
                                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

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
                            let pricePerNight = 0;
                            let maxCapacity = 0;

                            function showBookingModal(roomId, roomNumber, price, capacity) {
                                document.getElementById('modalRoomId').value = roomId;
                                document.getElementById('modalRoomNumber').textContent = roomNumber;
                                document.getElementById('pricePerNight').textContent = price;
                                document.getElementById('maxCapacity').textContent = capacity;
                                document.getElementById('numberOfGuests').setAttribute('max', capacity);
                                pricePerNight = price;
                                maxCapacity = capacity;

                                document.getElementById('bookingModal').style.display = 'flex';
                                calculateTotal();
                            }

                            function closeBookingModal() {
                                document.getElementById('bookingModal').style.display = 'none';
                            }

                            function calculateTotal() {
                                const checkIn = document.getElementById('checkIn').value;
                                const checkOut = document.getElementById('checkOut').value;

                                if (checkIn && checkOut) {
                                    const date1 = new Date(checkIn);
                                    const date2 = new Date(checkOut);
                                    const diffTime = Math.abs(date2 - date1);
                                    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

                                    document.getElementById('numberOfNights').textContent = diffDays;
                                    document.getElementById('totalAmount').textContent = (diffDays * pricePerNight).toFixed(2);
                                }
                            }

                            function validateBooking() {
                                const checkIn = new Date(document.getElementById('checkIn').value);
                                const checkOut = new Date(document.getElementById('checkOut').value);
                                const guests = parseInt(document.getElementById('numberOfGuests').value);

                                if (checkOut <= checkIn) {
                                    alert('Check-out date must be after check-in date!');
                                    return false;
                                }

                                if (guests > maxCapacity) {
                                    alert('Number of guests exceeds room capacity!');
                                    return false;
                                }

                                return true;
                            }

                            document.getElementById('checkIn').addEventListener('change', calculateTotal);
                            document.getElementById('checkOut').addEventListener('change', calculateTotal);

                            // Set minimum checkout date based on checkin
                            document.getElementById('checkIn').addEventListener('change', function () {
                                const checkInDate = new Date(this.value);
                                checkInDate.setDate(checkInDate.getDate() + 1);
                                document.getElementById('checkOut').min = checkInDate.toISOString().split('T')[0];
                            });
                        </script>
</body>
</html>