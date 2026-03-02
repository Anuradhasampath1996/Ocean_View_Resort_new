<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"admin".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BookingDAO bookingDAO=new
                    BookingDAO(); UserDAO userDAO=new UserDAO(); RoomDAO roomDAO=new RoomDAO(); List<Booking>
                    allBookings = bookingDAO.getAllBookings();
                    List<User> allUsers = userDAO.getAllUsers(); List<Room> availableRooms =
                            roomDAO.getAvailableRooms();
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
                            </head>

                            <body>
                                <!-- Navbar -->
                                <nav class="navbar navbar-expand-lg navbar-light sticky-top">
                                    <div class="container-fluid navbar-container">
                                        <a href="${pageContext.request.contextPath}/index.jsp"
                                            class="navbar-brand logo-container">
                                            <img src="${pageContext.request.contextPath}/images/logo.png"
                                                alt="Ocean View Resort" class="logo-image">
                                        </a>
                                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                                            data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                                            aria-label="Toggle navigation">
                                            <span class="navbar-toggler-icon"></span>
                                        </button>
                                        <div class="collapse navbar-collapse" id="navbarNav">
                                            <ul class="navbar-nav ms-auto">
                                                <li class="nav-item"><a
                                                        href="${pageContext.request.contextPath}/admin/dashboard.jsp"
                                                        class="nav-link"><i class="bi bi-speedometer2"></i>
                                                        Dashboard</a></li>
                                                <li class="nav-item"><a
                                                        href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                                        class="nav-link active"><i class="bi bi-calendar-check"></i>
                                                        Bookings</a></li>
                                                <li class="nav-item"><a
                                                        href="${pageContext.request.contextPath}/admin/rooms.jsp"
                                                        class="nav-link"><i class="bi bi-door-open"></i> Rooms</a></li>
                                                <li class="nav-item"><a
                                                        href="${pageContext.request.contextPath}/admin/customers.jsp"
                                                        class="nav-link"><i class="bi bi-people"></i> Customers</a></li>
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
                                        <div
                                            style="padding: 1.5rem; border-bottom: 1px solid #e5e7eb; text-align: center;">
                                            <a href="${pageContext.request.contextPath}/index.jsp"
                                                class="logo-container">
                                                <img src="${pageContext.request.contextPath}/images/logo.png"
                                                    alt="Ocean View Resort" class="logo-image sidebar">
                                            </a>
                                        </div>
                                        <ul class="sidebar-nav">
                                            <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
                                                    class="sidebar-link">
                                                    <i class="bi bi-speedometer2"></i> Dashboard
                                                </a></li>
                                            <li><a href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                                    class="sidebar-link active">
                                                    <i class="bi bi-calendar-check"></i> Bookings
                                                </a></li>
                                            <li><a href="${pageContext.request.contextPath}/admin/rooms.jsp"
                                                    class="sidebar-link">
                                                    <i class="bi bi-door-open"></i> Rooms
                                                </a></li>
                                            <li><a href="${pageContext.request.contextPath}/admin/customers.jsp"
                                                    class="sidebar-link">
                                                    <i class="bi bi-people"></i> Customers
                                                </a></li>
                                        </ul>
                                    </aside>

                                    <!-- Main Content -->
                                    <main style="flex: 1; padding: 2rem;">
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
                                                    <% if ("booking_created".equals(request.getParameter("success"))) {
                                                        %>
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
                                                                                    %>
                                                                                    <tr>
                                                                                        <td>#<%= booking.getId() %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%= booking.getUserName() %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%= booking.getRoomNumber()
                                                                                                %> (<%=
                                                                                                    booking.getRoomType()
                                                                                                    %>)
                                                                                        </td>
                                                                                        <td>
                                                                                            <%= booking.getCheckInDate()
                                                                                                %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%= booking.getCheckOutDate()
                                                                                                %>
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
                                                                                        </td>
                                                                                        <td>
                                                                                            <a class="btn btn-outline"
                                                                                                style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                                                href="${pageContext.request.contextPath}/bookings?action=invoice&id=<%= booking.getId() %>">
                                                                                                Invoice
                                                                                            </a>
                                                                                            <button
                                                                                                class="btn btn-secondary"
                                                                                                style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                                                onclick="editBookingStatus(<%= booking.getId() %>, '<%= booking.getStatus() %>')">
                                                                                                Edit
                                                                                            </button>
                                                                                            <% if
                                                                                                ("pending".equals(booking.getStatus()))
                                                                                                { %>
                                                                                                <button
                                                                                                    class="btn btn-primary"
                                                                                                    style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                                                    onclick="updateStatus(<%= booking.getId() %>, 'confirmed')">
                                                                                                    Confirm
                                                                                                </button>
                                                                                                <% } %>
                                                                                                    <% if
                                                                                                        ("confirmed".equals(booking.getStatus()))
                                                                                                        { %>
                                                                                                        <button
                                                                                                            class="btn btn-secondary"
                                                                                                            style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                                                            onclick="updateStatus(<%= booking.getId() %>, 'completed')">
                                                                                                            Complete
                                                                                                        </button>
                                                                                                        <% } %>
                                                                                                            <% if
                                                                                                                (!"cancelled".equals(booking.getStatus())
                                                                                                                &&
                                                                                                                !"completed".equals(booking.getStatus()))
                                                                                                                { %>
                                                                                                                <button
                                                                                                                    class="btn btn-warning"
                                                                                                                    style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                                                                    onclick="updateStatus(<%= booking.getId() %>, 'cancelled')">
                                                                                                                    Cancel
                                                                                                                </button>
                                                                                                                <% } %>
                                                                                                                    <button
                                                                                                                        class="btn btn-danger"
                                                                                                                        style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                                                                        onclick="deleteBooking(<%= booking.getId() %>)">
                                                                                                                        Delete
                                                                                                                    </button>
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

                                    <div id="addBookingModal"
                                        style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(0,0,0,0.45); z-index: 9999; align-items: center; justify-content: center;">
                                        <div class="card" style="max-width: 620px; width: 100%; margin: 1rem;">
                                            <div class="card-header flex justify-between items-center">
                                                <h4 class="card-title" style="margin: 0;">Add New Booking</h4>
                                                <button class="btn btn-outline" type="button"
                                                    onclick="document.getElementById('addBookingModal').style.display='none'">Close</button>
                                            </div>
                                            <div class="card-content">
                                                <form action="${pageContext.request.contextPath}/bookings"
                                                    method="post">
                                                    <input type="hidden" name="action" value="createByStaff">

                                                    <div class="form-group">
                                                        <label class="form-label">Customer *</label>
                                                        <select name="userId" class="form-select" required>
                                                            <option value="">Select customer</option>
                                                            <% for (User user : allUsers) { if
                                                                ("customer".equals(user.getRole())) { %>
                                                                <option value="<%= user.getId() %>">
                                                                    <%= user.getFullName() %> (<%= user.getUsername() %>
                                                                            )
                                                                </option>
                                                                <% } } %>
                                                        </select>
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Room *</label>
                                                        <select name="roomId" class="form-select" required>
                                                            <option value="">Select available room</option>
                                                            <% for (Room room : availableRooms) { %>
                                                                <option value="<%= room.getId() %>">
                                                                    Room <%= room.getRoomNumber() %> - <%=
                                                                            room.getRoomType() %> (LKR <%=
                                                                                room.getPricePerNight() %>/night)
                                                                </option>
                                                                <% } %>
                                                        </select>
                                                    </div>

                                                    <div class="grid grid-cols-2">
                                                        <div class="form-group">
                                                            <label class="form-label">Check-in *</label>
                                                            <input type="date" name="checkIn" class="form-input"
                                                                required min="<%= java.time.LocalDate.now() %>">
                                                        </div>
                                                        <div class="form-group">
                                                            <label class="form-label">Check-out *</label>
                                                            <input type="date" name="checkOut" class="form-input"
                                                                required
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

                                    <script
                                        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                    <script>
                                        function postBookingAction(action, params = {}) {
                                            const payload = new URLSearchParams();
                                            payload.set('action', action);

                                            Object.keys(params).forEach((key) => {
                                                if (params[key] !== undefined && params[key] !== null) {
                                                    payload.set(key, String(params[key]));
                                                }
                                            });

                                            const query = payload.toString();
                                            return fetch('${pageContext.request.contextPath}/bookings?' + query, {
                                                method: 'POST',
                                                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                                                body: query
                                            }).then(async (response) => {
                                                let payload = null;
                                                try {
                                                    payload = await response.json();
                                                } catch {
                                                    payload = { success: false, message: 'Invalid server response' };
                                                }

                                                if (!response.ok || !payload.success) {
                                                    throw new Error(payload.message || 'Request failed');
                                                }
                                                return payload;
                                            });
                                        }

                                        function updateStatus(bookingId, status) {
                                            const action = status === 'confirmed' ? 'confirm' :
                                                status === 'cancelled' ? 'cancel' : 'complete';
                                            const message = `Are you sure you want to ${action} this booking?`;

                                            if (confirm(message)) {
                                                postBookingAction('updateStatus', {
                                                    id: bookingId,
                                                    bookingId: bookingId,
                                                    status: status,
                                                    newStatus: status
                                                })
                                                    .then(data => {
                                                        if (data.success) {
                                                            location.reload();
                                                        } else {
                                                            alert('Failed to update booking status');
                                                        }
                                                    })
                                                    .catch((error) => alert(error.message || 'Failed to update booking status'));
                                            }
                                        }

                                        function deleteBooking(bookingId) {
                                            if (!confirm('Are you sure you want to delete this booking?')) {
                                                return;
                                            }

                                            postBookingAction('delete', {
                                                id: bookingId,
                                                bookingId: bookingId
                                            })
                                                .then(data => {
                                                    if (data.success) {
                                                        location.reload();
                                                    } else {
                                                        alert('Failed to delete booking');
                                                    }
                                                })
                                                .catch((error) => alert(error.message || 'Failed to delete booking'));
                                        }

                                        function editBookingStatus(bookingId, currentStatus) {
                                            const nextStatus = prompt(
                                                'Set booking status (pending, confirmed, completed, cancelled):',
                                                currentStatus
                                            );

                                            if (!nextStatus) {
                                                return;
                                            }

                                            const status = nextStatus.trim().toLowerCase();
                                            const allowedStatuses = ['pending', 'confirmed', 'completed', 'cancelled'];
                                            if (!allowedStatuses.includes(status)) {
                                                alert('Invalid status. Use: pending, confirmed, completed, cancelled');
                                                return;
                                            }

                                            postBookingAction('updateStatus', {
                                                id: bookingId,
                                                bookingId: bookingId,
                                                status: status,
                                                newStatus: status
                                            })
                                                .then(() => location.reload())
                                                .catch((error) => alert(error.message || 'Failed to edit booking status'));
                                        }
                                    </script>
                            </body>

                            </html>