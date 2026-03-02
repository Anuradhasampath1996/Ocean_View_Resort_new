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
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Book a Room - Ocean View Resort</title>
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
                                            class="sidebar-link">
                                            <i class="bi bi-calendar-check"></i> My Bookings
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/customer/book-room.jsp"
                                            class="sidebar-link active">
                                            <i class="bi bi-door-open"></i> Book a Room
                                        </a></li>
                                </ul>
                            </aside>

                            <main style="flex: 1; padding: 2rem;">
                                <div class="container-fluid">
                                    <h2 class="mb-4">Book a Room</h2>

                                    <% if (request.getParameter("error") !=null) { %>
                                        <div class="alert alert-error">
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

                                            <div class="grid grid-cols-3">
                                                <% for (Room room : availableRooms) { %>
                                                    <div class="card room-card">
                                                        <img src="<%= room.getImageUrl() %>"
                                                            alt="<%= room.getRoomType() %>" class="room-image">
                                                        <div class="card-content">
                                                            <span class="room-type">
                                                                <%= room.getRoomType().replace("_", " " ).toUpperCase()
                                                                    %>
                                                            </span>
                                                            <h4 class="mt-2">Room <%= room.getRoomNumber() %>
                                                            </h4>
                                                            <p class="text-muted mt-2">
                                                                <%= room.getDescription() %>
                                                            </p>
                                                            <p class="text-muted mt-2">
                                                                <i class="bi bi-people"></i> Capacity: <%=
                                                                    room.getCapacity() %> guests
                                                            </p>
                                                            <p class="text-muted"><small>
                                                                    <%= room.getAmenities() %>
                                                                </small></p>
                                                            <div class="flex items-center justify-between mt-3">
                                                                <div class="room-price">LKR <%= room.getPricePerNight()
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
                            </main>
                        </div>

                        <!-- Booking Modal -->
                        <div id="bookingModal"
                            style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
                            <div class="card" style="max-width: 500px; margin: 2rem;">
                                <div class="card-header">
                                    <h4 class="card-title">Book Room <span id="modalRoomNumber"></span></h4>
                                </div>
                                <div class="card-content">
                                    <form action="${pageContext.request.contextPath}/bookings" method="post"
                                        onsubmit="return validateBooking()">
                                        <input type="hidden" name="action" value="create">
                                        <input type="hidden" name="roomId" id="modalRoomId">

                                        <div class="form-group">
                                            <label class="form-label">Check-in Date *</label>
                                            <input type="date" name="checkIn" id="checkIn" class="form-input" required
                                                min="<%= java.time.LocalDate.now() %>">
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">Check-out Date *</label>
                                            <input type="date" name="checkOut" id="checkOut" class="form-input"
                                                required>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">Number of Guests *</label>
                                            <input type="number" name="numberOfGuests" id="numberOfGuests"
                                                class="form-input" required min="1" max="10">
                                            <small class="text-muted">Max capacity: <span id="maxCapacity"></span>
                                                guests</small>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">Special Requests</label>
                                            <textarea name="specialRequests" class="form-textarea"
                                                placeholder="Any special requests..."></textarea>
                                        </div>

                                        <div class="p-3 mb-3"
                                            style="background-color: hsl(var(--muted)); border-radius: var(--radius);">
                                            <div class="flex justify-between mb-2">
                                                <span>Price per night:</span>
                                                <strong>LKR <span id="pricePerNight"></span></strong>
                                            </div>
                                            <div class="flex justify-between mb-2">
                                                <span>Number of nights:</span>
                                                <strong><span id="numberOfNights">0</span></strong>
                                            </div>
                                            <hr>
                                            <div class="flex justify-between">
                                                <span><strong>Total Amount:</strong></span>
                                                <strong style="color: hsl(var(--ocean-blue)); font-size: 1.25rem;">LKR
                                                    <span </div>

                                                        <div class="flex gap-2">
                                                            <button type="button" class="btn btn-secondary"
                                                                onclick="closeBookingModal()">Cancel</button>
                                                            <button type="submit" class="btn btn-primary"
                                                                style="flex: 1;">Confirm
                                                                Booking</button>
                                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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