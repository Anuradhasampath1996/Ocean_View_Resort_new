<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"manager".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BookingDAO bookingDAO=new
                    BookingDAO(); UserDAO userDAO=new UserDAO(); RoomDAO roomDAO=new RoomDAO(); List<Booking>
                    allBookings = bookingDAO.getAllBookings();
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Manage Bookings - Manager - Ocean View Resort</title>
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
                                                href="${pageContext.request.contextPath}/manager/dashboard.jsp"
                                                class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                                        <li class="nav-item"><a
                                                href="${pageContext.request.contextPath}/manager/bookings.jsp"
                                                class="nav-link active"><i class="bi bi-calendar-check"></i>
                                                Bookings</a></li>
                                        <li class="nav-item"><a
                                                href="${pageContext.request.contextPath}/manager/rooms.jsp"
                                                class="nav-link"><i class="bi bi-door-open"></i> Rooms</a></li>
                                        <li class="nav-item"><a
                                                href="${pageContext.request.contextPath}/manager/staff.jsp"
                                                class="nav-link"><i class="bi bi-people"></i> Staff</a></li>
                                        <li class="nav-item"><a
                                                href="${pageContext.request.contextPath}/manager/reports.jsp"
                                                class="nav-link"><i class="bi bi-file-earmark-bar-graph"></i>
                                                Reports</a></li>
                                        <li class="nav-item"><span class="nav-link"><i class="bi bi-person-circle"></i>
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
                                <div style="padding: 1.5rem; border-bottom: 1px solid #e5e7eb; text-align: center;">
                                    <a href="${pageContext.request.contextPath}/index.jsp" class="logo-container">
                                        <img src="${pageContext.request.contextPath}/images/logo.png"
                                            alt="Ocean View Resort" class="logo-image sidebar">
                                    </a>
                                </div>
                                <ul class="sidebar-nav">
                                    <li><a href="${pageContext.request.contextPath}/manager/dashboard.jsp"
                                            class="sidebar-link">
                                            <i class="bi bi-speedometer2"></i> Dashboard
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/manager/bookings.jsp"
                                            class="sidebar-link active">
                                            <i class="bi bi-calendar-check"></i> Bookings
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/manager/rooms.jsp"
                                            class="sidebar-link">
                                            <i class="bi bi-door-open"></i> Rooms
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/manager/staff.jsp"
                                            class="sidebar-link">
                                            <i class="bi bi-people"></i> Staff & Guests
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/manager/reports.jsp"
                                            class="sidebar-link">
                                            <i class="bi bi-file-earmark-bar-graph"></i> Reports
                                        </a></li>
                                </ul>
                            </aside>

                            <!-- Main Content -->
                            <main style="flex: 1; padding: 2rem;">
                                <h2 class="mb-4">Manage Bookings</h2>

                                <div class="card">
                                    <div class="card-content p-0">
                                        <div class="table-responsive">
                                            <table class="table">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Customer</th>
                                                        <th>Room</th>
                                                        <th>Check-In</th>
                                                        <th>Check-Out</th>
                                                        <th>Guests</th>
                                                        <th>Amount</th>
                                                        <th>Status</th>
                                                        <th>Actions</th>
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
                                                                <%= room !=null ? room.getRoomNumber() + " (" +
                                                                    room.getRoomType() + ")" : "Unknown" %>
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
                                                            <td>LKR <%= String.format("%.2f",
                                                                    booking.getTotalAmount().doubleValue()) %>
                                                            </td>
                                                            <td>
                                                                <span class="badge badge-<%= statusBadge %>">
                                                                    <%= booking.getStatus().substring(0,
                                                                        1).toUpperCase() +
                                                                        booking.getStatus().substring(1) %>
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <button class="btn btn-secondary"
                                                                    style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                    onclick="editBookingStatus(<%= booking.getId() %>, '<%= booking.getStatus() %>')">
                                                                    Edit
                                                                </button>
                                                                <% if ("pending".equals(booking.getStatus())) { %>
                                                                    <button class="btn btn-primary"
                                                                        style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                        onclick="updateStatus(<%= booking.getId() %>, 'confirmed')">
                                                                        Confirm
                                                                    </button>
                                                                    <% } %>
                                                                        <% if ("confirmed".equals(booking.getStatus()))
                                                                            { %>
                                                                            <button class="btn btn-secondary"
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
                                                                                    <button class="btn btn-warning"
                                                                                        style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                                        onclick="updateStatus(<%= booking.getId() %>, 'cancelled')">
                                                                                        Cancel
                                                                                    </button>
                                                                                    <% } %>
                                                                                        <button class="btn btn-danger"
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
                            </main>
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