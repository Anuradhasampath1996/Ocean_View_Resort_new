<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"admin".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BookingDAO bookingDAO=new
                    BookingDAO(); UserDAO userDAO=new UserDAO(); RoomDAO roomDAO=new RoomDAO(); List<Booking>
                    allBookings = bookingDAO.getAllBookings();
                    List<User> allUsers = userDAO.getAllUsers();
                        List<Room> availableRooms = roomDAO.getAvailableRooms();
                            %>
                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Manage Bookings - Admin - Ocean View Resort</title>
                                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                    rel="stylesheet">
                                <link rel="stylesheet"
                                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
                                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                                <style>
                                    .status-select {
                                        padding: 0.2rem 0.5rem;
                                        font-size: 0.8rem;
                                        border-radius: 0.375rem;
                                        border: 1px solid #dee2e6;
                                        cursor: pointer;
                                        font-weight: 600;
                                        outline: none;
                                    }

                                    .status-select.status-pending {
                                        background: #fff3cd;
                                        color: #856404;
                                        border-color: #ffc107;
                                    }

                                    .status-select.status-confirmed {
                                        background: #d1e7dd;
                                        color: #0a3622;
                                        border-color: #198754;
                                    }

                                    .status-select.status-completed {
                                        background: #e2e3e5;
                                        color: #41464b;
                                        border-color: #6c757d;
                                    }

                                    .status-select.status-cancelled {
                                        background: #f8d7da;
                                        color: #58151c;
                                        border-color: #dc3545;
                                    }
                                </style>
                            </head>

                            <body>
                                <!-- Sidebar -->
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
                                            <span class="sidebar-user-role">
                                                <%= session.getAttribute("role") %>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="sidebar-nav-label">Navigation</div>
                                    <ul class="sidebar-nav">
                                        <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
                                                class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a>
                                        </li>
                                        <li class="sidebar-accordion-item">
                                            <button type="button" class="sidebar-link sidebar-accordion-btn"
                                                onclick="toggleBookingMenu()"><i class="bi bi-calendar-check"></i>
                                                Bookings <i class="bi bi-chevron-down sidebar-chevron open"
                                                    id="bookingChevron"></i></button>
                                            <ul class="sidebar-submenu open" id="bookingSubmenu">
                                                <li><a href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                                        class="sidebar-link sidebar-sublink active"><i
                                                            class="bi bi-list-ul"></i> All Bookings</a></li>
                                                <li><a href="${pageContext.request.contextPath}/admin/add-booking.jsp"
                                                        class="sidebar-link sidebar-sublink"><i
                                                            class="bi bi-plus-circle"></i> Add Booking</a></li>
                                            </ul>
                                        </li>
                                        <li><a href="${pageContext.request.contextPath}/admin/rooms.jsp"
                                                class="sidebar-link"><i class="bi bi-door-open"></i> Rooms</a></li>
                                        <li><a href="${pageContext.request.contextPath}/admin/customers.jsp"
                                                class="sidebar-link"><i class="bi bi-people"></i> Customers</a></li>
                                        <li><a href="${pageContext.request.contextPath}/admin/staff.jsp"
                                                class="sidebar-link"><i class="bi bi-person-badge"></i> Staff</a></li>
                                        <li><a href="${pageContext.request.contextPath}/admin/reports.jsp"
                                                class="sidebar-link"><i class="bi bi-bar-chart-line"></i> Reports</a>
                                        </li>
                                    </ul>
                                    <div class="sidebar-footer">
                                        <a href="${pageContext.request.contextPath}/logout"
                                            class="sidebar-logout-btn"><i class="bi bi-box-arrow-left"></i> Logout</a>
                                    </div>
                                </aside>
                                <div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                                <!-- Main Content -->
                                <main class="dashboard-main-content" id="mainContent">
                                    <div class="container-fluid">
                                        <div class="flex justify-between items-center mb-4">
                                            <h2 style="margin: 0;">Manage Bookings</h2>
                                            <button class="btn btn-primary"
                                                onclick="document.getElementById('addBookingModal').style.display='flex'">
                                                <i class="bi bi-plus-circle"></i> Add Booking
                                            </button>
                                        </div>

                                        <% if (request.getParameter("success") !=null) { %>
                                            <div class="alert alert-success">
                                                <% if ("booking_created".equals(request.getParameter("success"))) { %>
                                                    Booking created successfully!
                                                    <% } else { %>
                                                        Booking updated successfully!
                                                        <% } %>
                                            </div>
                                            <% } %>

                                                <% if (request.getParameter("error") !=null) { %>
                                                    <div class="alert alert-error">
                                                        <% if
                                                            ("room_not_available".equals(request.getParameter("error")))
                                                            { %>
                                                            Room is not available for selected dates.
                                                            <% } else if
                                                                ("invalid_dates".equals(request.getParameter("error")))
                                                                { %>
                                                                Invalid check-in/check-out dates.
                                                                <% } else if
                                                                    ("invalid_input".equals(request.getParameter("error")))
                                                                    { %>
                                                                    Please fill all required fields.
                                                                    <% } else if
                                                                        ("invalid_room".equals(request.getParameter("error")))
                                                                        { %>
                                                                        Selected room is invalid.
                                                                        <% } else { %>
                                                                            Failed to create booking. Please try
                                                                            again.
                                                                            <% } %>
                                                    </div>
                                                    <% } %>

                                                        <div class="card">
                                                            <div class="card-content p-0">
                                                                <div class="table-container">
                                                                    <table class="table">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>ID</th>
                                                                                <th>Customer</th>
                                                                                <th>Room</th>
                                                                                <th>Check-in</th>
                                                                                <th>Check-out</th>
                                                                                <th>Guests</th>
                                                                                <th>Amount</th>
                                                                                <th>Status</th>
                                                                                <th>Actions</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <% for (Booking booking : allBookings) {
                                                                                String
                                                                                customerName=booking.getUserName()==null
                                                                                ? "-" : booking.getUserName(); String
                                                                                roomNumber=booking.getRoomNumber()==null
                                                                                ? "-" : booking.getRoomNumber(); String
                                                                                roomType=booking.getRoomType()==null
                                                                                ? "-" : booking.getRoomType(); String
                                                                                specialRequests=(booking.getSpecialRequests()==null
                                                                                ||
                                                                                booking.getSpecialRequests().isBlank())
                                                                                ? "-" : booking.getSpecialRequests();
                                                                                String
                                                                                safeCustomer=customerName.replace("\"", "&quot;"
                                                                                ); String
                                                                                safeRoomNumber=roomNumber.replace("\"", "&quot;"
                                                                                ); String
                                                                                safeRoomType=roomType.replace("\"", "&quot;"
                                                                                ); String
                                                                                safeSpecial=specialRequests.replace("\"", "&quot;"
                                                                                ); %>
                                                                                <tr>
                                                                                    <td>#<%= booking.getId() %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= customerName %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= roomNumber %> (<%= roomType
                                                                                                %>)
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= booking.getCheckInDate() %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= booking.getCheckOutDate() %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= booking.getNumberOfGuests()
                                                                                            %>
                                                                                    </td>
                                                                                    <td>LKR <%=
                                                                                            booking.getTotalAmount().doubleValue()
                                                                                            %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <select
                                                                                            class="status-select status-<%= booking.getStatus() %>"
                                                                                            onchange="changeStatus(<%= booking.getId() %>, this)"
                                                                                            data-prev="<%= booking.getStatus() %>">
                                                                                            <option value="pending"
                                                                                                <%="pending"
                                                                                                .equals(booking.getStatus())
                                                                                                ? "selected" : "" %>
                                                                                                >Pending</option>
                                                                                            <option value="confirmed"
                                                                                                <%="confirmed"
                                                                                                .equals(booking.getStatus())
                                                                                                ? "selected" : "" %>
                                                                                                >Confirmed</option>
                                                                                            <option value="completed"
                                                                                                <%="completed"
                                                                                                .equals(booking.getStatus())
                                                                                                ? "selected" : "" %>
                                                                                                >Completed</option>
                                                                                            <option value="cancelled"
                                                                                                <%="cancelled"
                                                                                                .equals(booking.getStatus())
                                                                                                ? "selected" : "" %>
                                                                                                >Cancelled</option>
                                                                                        </select>
                                                                                    </td>
                                                                                    <td>
                                                                                        <button
                                                                                            class="btn btn-secondary"
                                                                                            style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                                            data-booking-id="<%= booking.getId() %>"
                                                                                            data-customer="<%= safeCustomer %>"
                                                                                            data-room-number="<%= safeRoomNumber %>"
                                                                                            data-room-type="<%= safeRoomType %>"
                                                                                            data-check-in="<%= booking.getCheckInDate() %>"
                                                                                            data-check-out="<%= booking.getCheckOutDate() %>"
                                                                                            data-guests="<%= booking.getNumberOfGuests() %>"
                                                                                            data-amount="<%= booking.getTotalAmount() %>"
                                                                                            data-status="<%= booking.getStatus() %>"
                                                                                            data-special="<%= safeSpecial %>"
                                                                                            onclick="openBookingDetails(this)">View</button>
                                                                                        <a class="btn btn-outline"
                                                                                            style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                                            href="${pageContext.request.contextPath}/bookings?action=invoice&id=<%= booking.getId() %>">Invoice</a>
                                                                                        <button class="btn btn-danger"
                                                                                            style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                                            onclick="deleteBooking(<%= booking.getId() %>)">Delete</button>
                                                                                    </td>
                                                                                </tr>
                                                                                <% } %>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>
                                    </div>
                                </main>
                                </div>

                                <!-- Add Booking Modal -->
                                <div id="addBookingModal"
                                    style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(0,0,0,0.45); z-index: 9999; align-items: center; justify-content: center;">
                                    <div class="card" style="max-width: 620px; width: 100%; margin: 1rem;">
                                        <div class="card-header flex justify-between items-center">
                                            <h4 class="card-title" style="margin: 0;">Add New Booking</h4>
                                            <button class="btn btn-outline" type="button"
                                                onclick="document.getElementById('addBookingModal').style.display='none'">Close</button>
                                        </div>
                                        <div class="card-content">
                                            <form action="${pageContext.request.contextPath}/bookings" method="post">
                                                <input type="hidden" name="action" value="createByStaff">
                                                <div class="form-group">
                                                    <label class="form-label">Customer *</label>
                                                    <select name="userId" class="form-select" required>
                                                        <option value="">Select customer</option>
                                                        <% for (User user : allUsers) { if
                                                            ("customer".equals(user.getRole())) { %>
                                                            <option value="<%= user.getId() %>">
                                                                <%= user.getFullName() %> (<%= user.getUsername() %>)
                                                            </option>
                                                            <% } } %>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label">Room *</label>
                                                    <select name="roomId" class="form-select" required>
                                                        <option value="">Select available room</option>
                                                        <% for (Room room : availableRooms) { %>
                                                            <option value="<%= room.getId() %>">Room <%=
                                                                    room.getRoomNumber() %> - <%= room.getRoomType() %>
                                                                        (LKR <%= room.getPricePerNight() %>/night)
                                                            </option>
                                                            <% } %>
                                                    </select>
                                                </div>
                                                <div class="grid grid-cols-2">
                                                    <div class="form-group">
                                                        <label class="form-label">Check-in *</label>
                                                        <input type="date" name="checkIn" class="form-input" required
                                                            min="<%= java.time.LocalDate.now() %>">
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="form-label">Check-out *</label>
                                                        <input type="date" name="checkOut" class="form-input" required
                                                            min="<%= java.time.LocalDate.now().plusDays(1) %>">
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label">Guests *</label>
                                                    <input type="number" name="numberOfGuests" class="form-input"
                                                        min="1" max="10" required>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label">Special Requests</label>
                                                    <textarea name="specialRequests" class="form-textarea"
                                                        placeholder="Optional notes..."></textarea>
                                                </div>
                                                <div class="flex gap-2" style="justify-content: flex-end;">
                                                    <button type="button" class="btn btn-outline"
                                                        onclick="document.getElementById('addBookingModal').style.display='none'">Cancel</button>
                                                    <button type="submit" class="btn btn-primary">Create
                                                        Booking</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- View Booking Modal -->
                                <div id="viewBookingModal"
                                    style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(0,0,0,0.45); z-index: 10000; align-items: center; justify-content: center;">
                                    <div class="card" style="max-width: 700px; width: 100%; margin: 1rem;">
                                        <div class="card-header flex justify-between items-center">
                                            <h4 class="card-title" style="margin: 0;">Booking Details</h4>
                                            <button class="btn btn-outline" type="button"
                                                onclick="closeBookingDetails()">Close</button>
                                        </div>
                                        <div class="card-content">
                                            <div class="grid grid-cols-2" style="gap: 1rem;">
                                                <div class="card" style="border-radius: 12px;">
                                                    <div class="card-header">
                                                        <h5 style="margin: 0;">Customer Details</h5>
                                                    </div>
                                                    <div class="card-content">
                                                        <p><strong>Name:</strong> <span id="viewCustomerName">-</span>
                                                        </p>
                                                        <p><strong>Guests:</strong> <span id="viewGuests">-</span></p>
                                                    </div>
                                                </div>
                                                <div class="card" style="border-radius: 12px;">
                                                    <div class="card-header">
                                                        <h5 style="margin: 0;">Room Details</h5>
                                                    </div>
                                                    <div class="card-content">
                                                        <p><strong>Room Number:</strong> <span
                                                                id="viewRoomNumber">-</span></p>
                                                        <p><strong>Room Type:</strong> <span id="viewRoomType">-</span>
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card" style="margin-top: 1rem; border-radius: 12px;">
                                                <div class="card-header">
                                                    <h5 style="margin: 0;">Booking Details</h5>
                                                </div>
                                                <div class="card-content">
                                                    <div class="grid grid-cols-2" style="gap: 0.75rem;">
                                                        <p><strong>Booking ID:</strong> #<span
                                                                id="viewBookingId">-</span></p>
                                                        <p><strong>Status:</strong> <span id="viewStatus">-</span></p>
                                                        <p><strong>Check-in:</strong> <span id="viewCheckIn">-</span>
                                                        </p>
                                                        <p><strong>Check-out:</strong> <span id="viewCheckOut">-</span>
                                                        </p>
                                                        <p><strong>Total Amount:</strong> LKR <span
                                                                id="viewAmount">-</span></p>
                                                    </div>
                                                    <p style="margin-top: 0.5rem;"><strong>Special Requests:</strong>
                                                        <span id="viewSpecialRequests">-</span>
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="flex gap-2"
                                                style="justify-content: flex-end; margin-top: 1rem;">
                                                <a id="viewInvoiceLink" class="btn btn-primary" href="#"><i
                                                        class="bi bi-download"></i> Download Invoice</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    function postBookingAction(action, params) {
                                        params = params || {};
                                        var payload = new URLSearchParams();
                                        payload.set('action', action);
                                        Object.keys(params).forEach(function (key) {
                                            if (params[key] !== undefined && params[key] !== null) {
                                                payload.set(key, String(params[key]));
                                            }
                                        });
                                        var query = payload.toString();
                                        return fetch('${pageContext.request.contextPath}/bookings?' + query, {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                                            body: query
                                        }).then(function (response) {
                                            return response.json().then(function (data) {
                                                if (!response.ok || !data.success) {
                                                    throw new Error(data.message || 'Request failed');
                                                }
                                                return data;
                                            });
                                        });
                                    }

                                    function updateStatus(bookingId, status) {
                                        var action = status === 'confirmed' ? 'confirm' : status === 'cancelled' ? 'cancel' : 'complete';
                                        if (confirm('Are you sure you want to ' + action + ' this booking?')) {
                                            postBookingAction('updateStatus', { id: bookingId, bookingId: bookingId, status: status, newStatus: status })
                                                .then(function (data) { if (data.success) location.reload(); else alert('Failed to update booking status'); })
                                                .catch(function (error) { alert(error.message || 'Failed to update booking status'); });
                                        }
                                    }

                                    function deleteBooking(bookingId) {
                                        if (!confirm('Are you sure you want to delete this booking?')) return;
                                        postBookingAction('delete', { id: bookingId, bookingId: bookingId })
                                            .then(function (data) { if (data.success) location.reload(); else alert('Failed to delete booking'); })
                                            .catch(function (error) { alert(error.message || 'Failed to delete booking'); });
                                    }

                                    function changeStatus(bookingId, selectEl) {
                                        var newStatus = selectEl.value;
                                        var prevStatus = selectEl.getAttribute('data-prev') || newStatus;
                                        if (!confirm('Change booking #' + bookingId + ' status to "' + newStatus + '"?')) {
                                            selectEl.value = prevStatus;
                                            return;
                                        }
                                        postBookingAction('updateStatus', { id: bookingId, bookingId: bookingId, status: newStatus, newStatus: newStatus })
                                            .then(function () {
                                                selectEl.setAttribute('data-prev', newStatus);
                                                selectEl.className = 'status-select status-' + newStatus;
                                                location.reload();
                                            })
                                            .catch(function (error) {
                                                alert(error.message || 'Failed to update status');
                                                selectEl.value = prevStatus;
                                            });
                                    }

                                    function openBookingDetails(button) {
                                        document.getElementById('viewBookingId').textContent = button.dataset.bookingId || '-';
                                        document.getElementById('viewCustomerName').textContent = button.dataset.customer || '-';
                                        document.getElementById('viewRoomNumber').textContent = button.dataset.roomNumber || '-';
                                        document.getElementById('viewRoomType').textContent = button.dataset.roomType || '-';
                                        document.getElementById('viewCheckIn').textContent = button.dataset.checkIn || '-';
                                        document.getElementById('viewCheckOut').textContent = button.dataset.checkOut || '-';
                                        document.getElementById('viewGuests').textContent = button.dataset.guests || '-';
                                        document.getElementById('viewAmount').textContent = button.dataset.amount || '-';
                                        document.getElementById('viewStatus').textContent = button.dataset.status || '-';
                                        document.getElementById('viewSpecialRequests').textContent = button.dataset.special || '-';
                                        document.getElementById('viewInvoiceLink').href = '${pageContext.request.contextPath}/bookings?action=invoice&id=' + (button.dataset.bookingId || '');
                                        document.getElementById('viewBookingModal').style.display = 'flex';
                                    }

                                    function closeBookingDetails() {
                                        document.getElementById('viewBookingModal').style.display = 'none';
                                    }
                                </script>
                                <script>
                                    function toggleBookingMenu() {
                                        var submenu = document.getElementById('bookingSubmenu');
                                        var chevron = document.getElementById('bookingChevron');
                                        submenu.classList.toggle('open');
                                        chevron.classList.toggle('open');
                                    }
                                    function toggleSidebar() {
                                        var sidebar = document.getElementById('sidebar');
                                        var mainContent = document.getElementById('mainContent');
                                        var toggleBtn = document.getElementById('sidebarToggle');
                                        var overlay = document.getElementById('sidebarOverlay');
                                        var isMobile = window.innerWidth <= 992;
                                        if (isMobile) {
                                            sidebar.classList.toggle('open');
                                            overlay.classList.toggle('active');
                                            toggleBtn.classList.toggle('shifted-open');
                                        } else {
                                            sidebar.classList.toggle('collapsed');
                                            mainContent.classList.toggle('expanded');
                                            toggleBtn.classList.toggle('shifted');
                                        }
                                        var icon = toggleBtn.querySelector('i');
                                        if (sidebar.classList.contains('collapsed') || (!sidebar.classList.contains('open') && isMobile)) {
                                            icon.className = 'bi bi-list';
                                        } else {
                                            icon.className = 'bi bi-x-lg';
                                        }
                                    }
                                    window.addEventListener('resize', function () {
                                        var sidebar = document.getElementById('sidebar');
                                        var mainContent = document.getElementById('mainContent');
                                        var toggleBtn = document.getElementById('sidebarToggle');
                                        var overlay = document.getElementById('sidebarOverlay');
                                        sidebar.classList.remove('collapsed', 'open');
                                        mainContent.classList.remove('expanded');
                                        toggleBtn.classList.remove('shifted', 'shifted-open');
                                        overlay.classList.remove('active');
                                        toggleBtn.querySelector('i').className = 'bi bi-list';
                                    });
                                </script>
                            </body>

                            </html>