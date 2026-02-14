<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"receptionist".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } RoomDAO roomDAO=new
                    RoomDAO(); List<Room> allRooms = roomDAO.getAllRooms();

                    // Count rooms by status
                    int availableCount = 0;
                    int occupiedCount = 0;
                    int maintenanceCount = 0;

                    for (Room room : allRooms) {
                    if ("available".equals(room.getStatus())) {
                    availableCount++;
                    } else if ("occupied".equals(room.getStatus())) {
                    occupiedCount++;
                    } else if ("maintenance".equals(room.getStatus())) {
                    maintenanceCount++;
                    }
                    }
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Room Status - Receptionist - Ocean View Resort</title>
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
                                            class="sidebar-link">
                                            <i class="bi bi-box-arrow-left"></i> Check-Out
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/receptionist/rooms.jsp"
                                            class="sidebar-link active">
                                            <i class="bi bi-door-open"></i> Room Status
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/receptionist/bookings.jsp"
                                            class="sidebar-link">
                                            <i class="bi bi-calendar-check"></i> Bookings
                                        </a></li>
                                </ul>
                            </aside>

                            <main style="flex: 1; padding: 2rem;">
                                <h2 class="mb-4">Room Status Management</h2>

                                <div class="row mb-4">
                                    <div class="col-md-3">
                                        <div class="card stat-card">
                                            <div class="card-content">
                                                <div class="stat-info">
                                                    <p class="stat-title">Available</p>
                                                    <h3 class="stat-value">
                                                        <%= availableCount %>
                                                    </h3>
                                                </div>
                                                <div class="stat-icon bg-success">
                                                    <i class="bi bi-check-circle"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card stat-card">
                                            <div class="card-content">
                                                <div class="stat-info">
                                                    <p class="stat-title">Occupied</p>
                                                    <h3 class="stat-value">
                                                        <%= occupiedCount %>
                                                    </h3>
                                                </div>
                                                <div class="stat-icon bg-warning">
                                                    <i class="bi bi-door-closed"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card stat-card">
                                            <div class="card-content">
                                                <div class="stat-info">
                                                    <p class="stat-title">Maintenance</p>
                                                    <h3 class="stat-value">
                                                        <%= maintenanceCount %>
                                                    </h3>
                                                </div>
                                                <div class="stat-icon bg-danger">
                                                    <i class="bi bi-tools"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card stat-card">
                                            <div class="card-content">
                                                <div class="stat-info">
                                                    <p class="stat-title">Total Rooms</p>
                                                    <h3 class="stat-value">
                                                        <%= allRooms.size() %>
                                                    </h3>
                                                </div>
                                                <div class="stat-icon bg-primary">
                                                    <i class="bi bi-building"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0">All Rooms</h5>
                                        <div>
                                            <select class="form-select form-select-sm" id="statusFilter"
                                                onchange="filterRooms()">
                                                <option value="">All Statuses</option>
                                                <option value="available">Available</option>
                                                <option value="occupied">Occupied</option>
                                                <option value="maintenance">Maintenance</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="card-content p-0">
                                        <div class="table-responsive">
                                            <table class="table" id="roomsTable">
                                                <thead>
                                                    <tr>
                                                        <th>Room Number</th>
                                                        <th>Type</th>
                                                        <th>Capacity</th>
                                                        <th>Price/Night</th>
                                                        <th>Status</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% for (Room room : allRooms) { String statusBadge="secondary" ; if
                                                        ("available".equals(room.getStatus())) { statusBadge="success" ;
                                                        } else if ("occupied".equals(room.getStatus())) {
                                                        statusBadge="warning" ; } else if
                                                        ("maintenance".equals(room.getStatus())) { statusBadge="danger"
                                                        ; } %>
                                                        <tr data-status="<%= room.getStatus() %>">
                                                            <td><strong>
                                                                    <%= room.getRoomNumber() %>
                                                                </strong></td>
                                                            <td>
                                                                <%= room.getType() %>
                                                            </td>
                                                            <td>
                                                                <%= room.getCapacity() %> guests
                                                            </td>
                                                            <td>LKR <%= String.format("%.2f", room.getPricePerNight())
                                                                    %>
                                                            </td>
                                                            <td>
                                                                <span class="badge badge-<%= statusBadge %>">
                                                                    <%= room.getStatus().substring(0, 1).toUpperCase() +
                                                                        room.getStatus().substring(1) %>
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <div class="btn-group btn-group-sm">
                                                                    <button class="btn btn-success"
                                                                        onclick="updateRoomStatus(<%= room.getId() %>, 'available')"
                                                                        <%="available" .equals(room.getStatus())
                                                                        ? "disabled" : "" %>>
                                                                        <i class="bi bi-check"></i>
                                                                    </button>
                                                                    <button class="btn btn-warning"
                                                                        onclick="updateRoomStatus(<%= room.getId() %>, 'occupied')"
                                                                        <%="occupied" .equals(room.getStatus())
                                                                        ? "disabled" : "" %>>
                                                                        <i class="bi bi-door-closed"></i>
                                                                    </button>
                                                                    <button class="btn btn-danger"
                                                                        onclick="updateRoomStatus(<%= room.getId() %>, 'maintenance')"
                                                                        <%="maintenance" .equals(room.getStatus())
                                                                        ? "disabled" : "" %>>
                                                                        <i class="bi bi-tools"></i>
                                                                    </button>
                                                                </div>
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
                            function updateRoomStatus(roomId, newStatus) {
                                const statusText = newStatus.charAt(0).toUpperCase() + newStatus.slice(1);
                                if (confirm('Change room status to ' + statusText + '?')) {
                                    alert('Room status updated to ' + statusText + '! (Backend functionality pending)');
                                    // In real implementation, this would call a servlet to update the database
                                    location.reload();
                                }
                            }

                            function filterRooms() {
                                const filter = document.getElementById('statusFilter').value;
                                const rows = document.querySelectorAll('#roomsTable tbody tr');

                                rows.forEach(row => {
                                    const status = row.getAttribute('data-status');
                                    if (filter === '' || status === filter) {
                                        row.style.display = '';
                                    } else {
                                        row.style.display = 'none';
                                    }
                                });
                            }
                        </script>
                    </body>

                    </html>