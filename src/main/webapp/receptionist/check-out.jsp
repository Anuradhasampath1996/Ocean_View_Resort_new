<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <%@ page import="java.time.LocalDate" %>
                    <% if (session.getAttribute("role")==null || !"receptionist".equals(session.getAttribute("role"))) {
                        response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BookingDAO
                        bookingDAO=new BookingDAO(); UserDAO userDAO=new UserDAO(); RoomDAO roomDAO=new RoomDAO();
                        LocalDate today=LocalDate.now(); List<Booking> todayCheckOuts = new ArrayList<>();
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
                                <aside class="dashboard-sidebar" id="sidebar">
                                    <div class="sidebar-header">
                                        <a href="${pageContext.request.contextPath}/index.jsp" class="logo-container">
                                            <img src="${pageContext.request.contextPath}/images/logo.png"
                                                alt="Ocean View Resort" class="logo-image sidebar">
                                        </a>
                                    </div>
                                    <div class="sidebar-user">
                                        <div class="sidebar-user-avatar"><i class="bi bi-person-fill"></i></div>
                                        <div class="sidebar-user-info">
                                            <span class="sidebar-user-name">
                                                <%= session.getAttribute("username") %>
                                            </span>
                                            <span class="sidebar-user-role">Receptionist</span>
                                        </div>
                                    </div>
                                    <div class="sidebar-nav-label">Navigation</div>
                                    <ul class="sidebar-nav">
                                        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard.jsp"
                                                class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a>
                                        </li>
                                        <li><a href="${pageContext.request.contextPath}/receptionist/check-in.jsp"
                                                class="sidebar-link"><i class="bi bi-box-arrow-in-right"></i>
                                                Check-In</a></li>
                                        <li><a href="${pageContext.request.contextPath}/receptionist/check-out.jsp"
                                                class="sidebar-link active"><i class="bi bi-box-arrow-left"></i>
                                                Check-Out</a></li>
                                        <li><a href="${pageContext.request.contextPath}/receptionist/rooms.jsp"
                                                class="sidebar-link"><i class="bi bi-door-open"></i> Room Status</a>
                                        </li>
                                        <li class="sidebar-accordion-item">
                                            <button type="button" class="sidebar-link sidebar-accordion-btn"
                                                onclick="toggleBookingMenu()"><i class="bi bi-calendar-check"></i>
                                                Bookings <i class="bi bi-chevron-down sidebar-chevron"
                                                    id="bookingChevron"></i></button>
                                            <ul class="sidebar-submenu" id="bookingSubmenu">
                                                <li><a href="${pageContext.request.contextPath}/receptionist/bookings.jsp"
                                                        class="sidebar-link sidebar-sublink"><i
                                                            class="bi bi-list-ul"></i> All Bookings</a></li>
                                                <li><a href="${pageContext.request.contextPath}/admin/add-booking.jsp"
                                                        class="sidebar-link sidebar-sublink"><i
                                                            class="bi bi-plus-circle"></i> Add Booking</a></li>
                                            </ul>
                                        </li>
                                    </ul>
                                    <div class="sidebar-footer">
                                        <form action="${pageContext.request.contextPath}/auth" method="post"
                                            style="margin:0;">
                                            <input type="hidden" name="action" value="logout">
                                            <button type="submit" class="sidebar-logout-btn"><i
                                                    class="bi bi-box-arrow-left"></i> Logout</button>
                                        </form>
                                    </div>
                                </aside>
                                <div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                                <main class="dashboard-main-content" id="mainContent">
                                    <div class="container-fluid">
                                        <div class="flex justify-between items-center mb-4">
                                            <h2 style="margin:0;"><i class="bi bi-box-arrow-left"
                                                    style="margin-right:.5rem;color:#1298c7;"></i>Today's Check-Outs
                                            </h2>
                                        </div>
                                        <div class="grid grid-cols-4 gap-4 mb-4">
                                            <div class="stats-card">
                                                <div class="stats-icon"
                                                    style="background-color:hsl(var(--ocean-blue));"><i
                                                        class="bi bi-box-arrow-left"></i></div>
                                                <div>
                                                    <div class="stats-value">
                                                        <%= todayCheckOuts.size() %>
                                                    </div>
                                                    <div class="stats-label">Expected Today</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card mb-4">
                                            <div class="card-header">
                                                <h3 class="card-title">Guests Checking Out Today</h3>
                                            </div>
                                            <div class="card-content p-0">
                                                <% if (todayCheckOuts.isEmpty()) { %>
                                                    <div style="padding:2.5rem;text-align:center;color:#6c757d;">
                                                        <i class="bi bi-inbox"
                                                            style="font-size:2.5rem;display:block;margin-bottom:.75rem;"></i>
                                                        No check-outs scheduled for today
                                                    </div>
                                                    <% } else { %>
                                                        <div class="table-container">
                                                            <table class="table">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Booking ID</th>
                                                                        <th>Guest Name</th>
                                                                        <th>Room</th>
                                                                        <th>Room Type</th>
                                                                        <th>Check-In</th>
                                                                        <th>Check-Out</th>
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
                                                                                <%= room !=null ? room.getRoomType()
                                                                                    : "N/A" %>
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
                                                                                <button class="btn btn-primary"
                                                                                    style="padding:.25rem .75rem;font-size:.875rem;"
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

                                        <!-- Payment Processing Card -->
                                        <div class="card mt-4" id="paymentCard" style="display:none;">
                                            <div class="card-header">
                                                <h3 class="card-title">Payment Processing</h3>
                                            </div>
                                            <div class="card-content">
                                                <div class="row g-4">
                                                    <div class="col-md-6">
                                                        <h5 class="mb-3">Booking Summary</h5>
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
                                                        <h5 class="mb-3">Payment Method</h5>
                                                        <div class="mb-3">
                                                            <label class="form-label fw-semibold">Select Payment
                                                                Method</label>
                                                            <select class="form-select" id="paymentMethod">
                                                                <option value="cash">Cash</option>
                                                                <option value="card">Credit/Debit Card</option>
                                                                <option value="mobile">Mobile Payment</option>
                                                            </select>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label fw-semibold">Amount
                                                                Received</label>
                                                            <input type="number" class="form-control"
                                                                id="amountReceived" step="0.01" placeholder="0.00">
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label fw-semibold">Change</label>
                                                            <input type="text" class="form-control" id="changeAmount"
                                                                readonly value="LKR 0.00">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="d-flex gap-2">
                                                    <button class="btn btn-primary" onclick="completeCheckOut()"><i
                                                            class="bi bi-check-circle"></i> Complete Check-Out</button>
                                                    <button class="btn btn-outline" onclick="cancelPayment()"><i
                                                            class="bi bi-x-circle"></i> Cancel</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </main>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    let currentBookingId = null;
                                    let currentAmount = 0;

                                    function toggleSidebar() {
                                        const sidebar = document.getElementById('sidebar');
                                        const overlay = document.getElementById('sidebarOverlay');
                                        const main = document.getElementById('mainContent');
                                        sidebar.classList.toggle('open');
                                        overlay.classList.toggle('active');
                                        if (main) main.classList.toggle('sidebar-open');
                                    }

                                    function toggleBookingMenu() {
                                        const submenu = document.getElementById('bookingSubmenu');
                                        const chevron = document.getElementById('bookingChevron');
                                        submenu.classList.toggle('open');
                                        chevron.classList.toggle('open');
                                    }

                                    function processCheckOut(bookingId, amount) {
                                        currentBookingId = bookingId;
                                        currentAmount = amount;
                                        const roomCharges = amount / 1.1;
                                        const tax = amount - roomCharges;
                                        document.getElementById('paymentBookingId').textContent = '#' + bookingId;
                                        document.getElementById('paymentRoomCharges').textContent = 'LKR ' + roomCharges.toFixed(2);
                                        document.getElementById('paymentTax').textContent = 'LKR ' + tax.toFixed(2);
                                        document.getElementById('paymentTotal').innerHTML = '<strong>LKR ' + amount.toFixed(2) + '</strong>';
                                        document.getElementById('paymentCard').style.display = 'block';
                                        document.getElementById('paymentCard').scrollIntoView({ behavior: 'smooth' });
                                    }

                                    document.addEventListener('DOMContentLoaded', function () {
                                        document.getElementById('amountReceived').addEventListener('input', function () {
                                            const received = parseFloat(this.value) || 0;
                                            const change = received - currentAmount;
                                            document.getElementById('changeAmount').value = 'LKR ' + (change >= 0 ? change.toFixed(2) : '0.00');
                                        });
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
                            rel="stylesheet" type="text/css">
                            <link
                                href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
                                rel="stylesheet">
                            <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
                            </head>

                            <body id="page-top">
                                <div id="wrapper">
                                    <!-- Sidebar -->
                                    <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion"
                                        id="accordionSidebar">
                                        <a class="sidebar-brand d-flex align-items-center justify-content-center"
                                            href="${pageContext.request.contextPath}/index.jsp">
                                            <div class="sidebar-brand-icon">
                                                <img src="${pageContext.request.contextPath}/images/logo.png"
                                                    alt="Ocean View Resort" style="height:40px;">
                                            </div>
                                            <div class="sidebar-brand-text mx-3">Ocean View Resort</div>
                                        </a>
                                        <hr class="sidebar-divider my-0">
                                        <li class="nav-item">
                                            <a class="nav-link"
                                                href="${pageContext.request.contextPath}/receptionist/dashboard.jsp">
                                                <i class="fas fa-fw fa-tachometer-alt"></i>
                                                <span>Dashboard</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link"
                                                href="${pageContext.request.contextPath}/receptionist/check-in.jsp">
                                                <i class="fas fa-fw fa-sign-in-alt"></i>
                                                <span>Check-In</span>
                                            </a>
                                        </li>
                                        <li class="nav-item active">
                                            <a class="nav-link"
                                                href="${pageContext.request.contextPath}/receptionist/check-out.jsp">
                                                <i class="fas fa-fw fa-sign-out-alt"></i>
                                                <span>Check-Out</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link"
                                                href="${pageContext.request.contextPath}/receptionist/rooms.jsp">
                                                <i class="fas fa-fw fa-door-open"></i>
                                                <span>Room Status</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link"
                                                href="${pageContext.request.contextPath}/receptionist/bookings.jsp">
                                                <i class="fas fa-fw fa-calendar-check"></i>
                                                <span>Bookings</span>
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
                                            <nav
                                                class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
                                                <button id="sidebarToggleTop"
                                                    class="btn btn-link d-md-none rounded-circle mr-3">
                                                    <i class="fa fa-bars"></i>
                                                </button>
                                                <ul class="navbar-nav ml-auto">
                                                    <li class="nav-item dropdown no-arrow">
                                                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown"
                                                            role="button" data-toggle="dropdown" aria-haspopup="true"
                                                            aria-expanded="false">
                                                            <span class="mr-2 d-none d-lg-inline text-gray-600 small">
                                                                <%= session.getAttribute("username") %>
                                                            </span>
                                                            <img class="img-profile rounded-circle"
                                                                src="${pageContext.request.contextPath}/images/logo.png">
                                                        </a>
                                                        <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                                                            aria-labelledby="userDropdown">
                                                            <div class="dropdown-divider"></div>
                                                            <form action="${pageContext.request.contextPath}/auth"
                                                                method="post">
                                                                <input type="hidden" name="action" value="logout">
                                                                <button type="submit" class="dropdown-item">
                                                                    <i
                                                                        class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
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
                                                    <h1 class="h3 mb-0 text-gray-800">Today's Check-Outs</h1>
                                                </div>

                                                <div class="row mb-4">
                                                    <div class="col-md-4">
                                                        <div class="card stat-card">
                                                            <div class="card-body">
                                                                <div class="stat-info">
                                                                    <p class="stat-title">Expected Today</p>
                                                                    <h3 class="stat-value">
                                                                        <%= todayCheckOuts.size() %>
                                                                    </h3>
                                                                </div>
                                                                <div class="stat-icon bg-warning">
                                                                    <i class="fas fa-sign-out-alt"></i>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="card shadow mb-4">
                                                    <div class="card-header py-3">
                                                        <h6 class="m-0 font-weight-bold text-primary">Guests Checking
                                                            Out Today</h6>
                                                    </div>
                                                    <div class="card-body p-0">
                                                        <% if (todayCheckOuts.isEmpty()) { %>
                                                            <div class="p-4 text-center text-muted">
                                                                <i class="fas fa-inbox" style="font-size: 3rem;"></i>
                                                                <p class="mt-2">No check-outs scheduled for today</p>
                                                            </div>
                                                            <% } else { %>
                                                                <div class="table-responsive">
                                                                    <table class="table table-bordered">
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
                                                                            <% for (Booking booking : todayCheckOuts) {
                                                                                User
                                                                                user=userDAO.getUserById(booking.getUserId());
                                                                                Room
                                                                                room=roomDAO.getRoomById(booking.getRoomId());
                                                                                %>
                                                                                <tr>
                                                                                    <td>#<%= booking.getId() %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= user !=null ?
                                                                                            user.getFullName()
                                                                                            : "Unknown" %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= room !=null ?
                                                                                            room.getRoomNumber() : "N/A"
                                                                                            %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= room !=null ? room.getType()
                                                                                            : "N/A" %>
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
                                                                                        <button
                                                                                            class="btn btn-warning btn-sm"
                                                                                            onclick="processCheckOut(<%= booking.getId() %>, <%= booking.getTotalAmount().doubleValue() %>)">
                                                                                            <i
                                                                                                class="fas fa-money-bill-wave"></i>
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
                                                    <div class="card-header py-3">
                                                        <h6 class="m-0 font-weight-bold text-primary">Payment Processing
                                                        </h6>
                                                    </div>
                                                    <div class="card-body">
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
                                                                        <td id="paymentTotal"><strong>LKR 0.00</strong>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <h6 class="mb-3">Payment Method</h6>
                                                                <div class="mb-3">
                                                                    <label class="font-weight-bold small">Select Payment
                                                                        Method</label>
                                                                    <select class="form-control" id="paymentMethod">
                                                                        <option value="cash">Cash</option>
                                                                        <option value="card">Credit/Debit Card</option>
                                                                        <option value="mobile">Mobile Payment</option>
                                                                    </select>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="font-weight-bold small">Amount
                                                                        Received</label>
                                                                    <input type="number" class="form-control"
                                                                        id="amountReceived" step="0.01"
                                                                        placeholder="0.00">
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="font-weight-bold small">Change</label>
                                                                    <input type="text" class="form-control"
                                                                        id="changeAmount" readonly value="LKR 0.00">
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="d-flex gap-2">
                                                            <button class="btn btn-success"
                                                                onclick="completeCheckOut()">
                                                                <i class="fas fa-check-circle"></i> Complete Check-Out
                                                            </button>
                                                            <button class="btn btn-secondary" onclick="cancelPayment()">
                                                                <i class="fas fa-times-circle"></i> Cancel
                                                            </button>
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
                                <script
                                    src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
                                <script
                                    src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>
                                <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>
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