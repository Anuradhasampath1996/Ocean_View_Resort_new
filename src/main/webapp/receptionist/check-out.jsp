<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <%@ page import="java.time.LocalDate" %>
                    <% if (session.getAttribute("role")==null || !"receptionist".equals(session.getAttribute("role"))) {
                        response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BookingDAO
                        bookingDAO=new BookingDAO(); UserDAO userDAO=new UserDAO(); RoomDAO roomDAO=new RoomDAO(); //
                        Get today's check-outs LocalDate today=LocalDate.now(); List<Booking> todayCheckOuts = new
                        ArrayList<>();
                            for (Booking booking : bookingDAO.getAllBookings()) {
                            if (booking.getCheckOutDate().equals(today) && "confirmed".equals(booking.getStatus())) {
                            todayCheckOuts.add(booking);
                            }
                            }
                            %>
                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Check-Out - Receptionist - Ocean View Resort</title>
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
                                                    class="sidebar-link active">
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
                                        <h2 class="mb-4">Today's Check-Outs</h2>

                                        <div class="row mb-4">
                                            <div class="col-md-4">
                                                <div class="card stat-card">
                                                    <div class="card-content">
                                                        <div class="stat-info">
                                                            <p class="stat-title">Expected Today</p>
                                                            <h3 class="stat-value">
                                                                <%= todayCheckOuts.size() %>
                                                            </h3>
                                                        </div>
                                                        <div class="stat-icon bg-warning">
                                                            <i class="bi bi-box-arrow-left"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="card">
                                            <div class="card-header">
                                                <h5 class="mb-0">Guests Checking Out Today</h5>
                                            </div>
                                            <div class="card-content p-0">
                                                <% if (todayCheckOuts.isEmpty()) { %>
                                                    <div class="p-4 text-center text-muted">
                                                        <i class="bi bi-inbox" style="font-size: 3rem;"></i>
                                                        <p class="mt-2">No check-outs scheduled for today</p>
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
                                                                        <th>Total Amount</th>
                                                                        <th>Action</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <% for (Booking booking : todayCheckOuts) { User
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
                                                                            <td>LKR <%= String.format("%.2f",
                                                                                    booking.getTotalAmount().doubleValue())
                                                                                    %>
                                                                            </td>
                                                                            <td>
                                                                                <button class="btn btn-warning btn-sm"
                                                                                    onclick="processCheckOut(<%= booking.getId() %>, <%= booking.getTotalAmount().doubleValue() %>)">
                                                                                    <i class="bi bi-cash-coin"></i>
                                                                                    Process Check-Out
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

                                        <!-- Payment Processing Modal Simulation -->
                                        <div class="card mt-4" id="paymentCard" style="display: none;">
                                            <div class="card-header">
                                                <h5 class="mb-0">Payment Processing</h5>
                                            </div>
                                            <div class="card-content">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <h6 class="mb-3">Booking Summary</h6>
                                                        <table class="table table-bordered">
                                                            <tr>
                                                                <td><strong>Booking ID:</strong></td>
                                                                <td id="paymentBookingId">-</td>
                                                            </tr>
                                                            <tr>
                                                                <td><strong>Room Charges:</strong></td>
                                                                <td id="paymentRoomCharges">LKR 0.00</td>
                                                            </tr>
                                                            <tr>
                                                                <td><strong>Tax (10%):</strong></td>
                                                                <td id="paymentTax">LKR 0.00</td>
                                                            </tr>
                                                            <tr class="table-primary">
                                                                <td><strong>Total Amount:</strong></td>
                                                                <td id="paymentTotal"><strong>LKR 0.00</strong></td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <h6 class="mb-3">Payment Method</h6>
                                                        <div class="mb-3">
                                                            <label class="form-label">Select Payment Method</label>
                                                            <select class="form-control" id="paymentMethod">
                                                                <option value="cash">Cash</option>
                                                                <option value="card">Credit/Debit Card</option>
                                                                <option value="mobile">Mobile Payment</option>
                                                            </select>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">Amount Received</label>
                                                            <input type="number" class="form-control"
                                                                id="amountReceived" step="0.01" placeholder="0.00">
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">Change</label>
                                                            <input type="text" class="form-control" id="changeAmount"
                                                                readonly value="LKR 0.00">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="d-flex gap-2">
                                                    <button class="btn btn-success" onclick="completeCheckOut()">
                                                        <i class="bi bi-check-circle"></i> Complete Check-Out
                                                    </button>
                                                    <button class="btn btn-secondary" onclick="cancelPayment()">
                                                        <i class="bi bi-x-circle"></i> Cancel
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </main>
                                </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    let currentBookingId = null;
                                    let currentAmount = 0;

                                    function processCheckOut(bookingId, amount) {
                                        currentBookingId = bookingId;
                                        currentAmount = amount;

                                        const roomCharges = amount / 1.1; // Remove tax to get base amount
                                        const tax = amount - roomCharges;

                                        document.getElementById('paymentBookingId').textContent = '#' + bookingId;
                                        document.getElementById('paymentRoomCharges').textContent = 'LKR ' + roomCharges.toFixed(2);
                                        document.getElementById('paymentTax').textContent = 'LKR ' + tax.toFixed(2);
                                        document.getElementById('paymentTotal').textContent = 'LKR ' + amount.toFixed(2);
                                        document.getElementById('paymentCard').style.display = 'block';

                                        document.getElementById('paymentCard').scrollIntoView({ behavior: 'smooth' });
                                    }

                                    document.getElementById('amountReceived').addEventListener('input', function () {
                                        const received = parseFloat(this.value) || 0;
                                        const change = received - currentAmount;
                                        document.getElementById('changeAmount').value = 'LKR ' + (change >= 0 ? change.toFixed(2) : '0.00');
                                    });

                                    function completeCheckOut() {
                                        const received = parseFloat(document.getElementById('amountReceived').value) || 0;
                                        if (received < currentAmount) {
                                            alert('Amount received is less than total amount due!');
                                            return;
                                        }

                                        alert('Check-out completed successfully for booking #' + currentBookingId + '! (Backend functionality pending)');
                                        cancelPayment();
                                        location.reload();
                                    }

                                    function cancelPayment() {
                                        document.getElementById('paymentCard').style.display = 'none';
                                        document.getElementById('amountReceived').value = '';
                                        document.getElementById('changeAmount').value = 'LKR 0.00';
                                        currentBookingId = null;
                                        currentAmount = 0;
                                    }
                                </script>
                            </body>

                            </html>