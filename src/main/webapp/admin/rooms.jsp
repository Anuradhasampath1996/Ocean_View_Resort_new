<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"admin".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } RoomDAO roomDAO=new
                    RoomDAO(); List<Room> allRooms = roomDAO.getAllRooms();
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Manage Rooms - Admin - Ocean View Resort</title>
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
                                                class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                                        <li class="nav-item"><a
                                                href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                                class="nav-link"><i class="bi bi-calendar-check"></i> Bookings</a></li>
                                        <li class="nav-item"><a
                                                href="${pageContext.request.contextPath}/admin/rooms.jsp"
                                                class="nav-link active"><i class="bi bi-door-open"></i> Rooms</a></li>
                                        <li class="nav-item"><a
                                                href="${pageContext.request.contextPath}/admin/customers.jsp"
                                                class="nav-link"><i class="bi bi-people"></i> Customers</a></li>
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
                                    <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
                                            class="sidebar-link">
                                            <i class="bi bi-speedometer2"></i> Dashboard
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                            class="sidebar-link">
                                            <i class="bi bi-calendar-check"></i> Bookings
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/admin/rooms.jsp"
                                            class="sidebar-link active">
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
                                        <h2>Manage Rooms</h2>
                                        <button class="btn btn-primary" onclick="showAddRoomModal()">
                                            <i class="bi bi-plus-circle"></i> Add New Room
                                        </button>
                                    </div>

                                    <% if (request.getParameter("success") !=null) { %>
                                        <div class="alert alert-success">
                                            <% if ("added".equals(request.getParameter("success"))) { %>
                                                Room added successfully!
                                                <% } else if ("updated".equals(request.getParameter("success"))) { %>
                                                    Room updated successfully!
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
                                                                    <th>Room Number</th>
                                                                    <th>Type</th>
                                                                    <th>Price/Night</th>
                                                                    <th>Capacity</th>
                                                                    <th>Status</th>
                                                                    <th>Actions</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% for (Room room : allRooms) { %>
                                                                    <tr>
                                                                        <td>#<%= room.getId() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= room.getRoomNumber() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= room.getRoomType().replace("_", " "
                                                                                ).toUpperCase() %>
                                                                        </td>
                                                                        <td>LKR <%= room.getPricePerNight() %>
                                                                        </td>
                                                                        <td>
                                                                            <%= room.getCapacity() %> guests
                                                                        </td>
                                                                        <td>
                                                                            <% if ("available".equals(room.getStatus()))
                                                                                { %>
                                                                                <span
                                                                                    class="badge badge-success">Available</span>
                                                                                <% } else if
                                                                                    ("occupied".equals(room.getStatus()))
                                                                                    { %>
                                                                                    <span
                                                                                        class="badge badge-warning">Occupied</span>
                                                                                    <% } else { %>
                                                                                        <span
                                                                                            class="badge badge-danger">Maintenance</span>
                                                                                        <% } %>
                                                                        </td>
                                                                        <td>
                                                                            <button class="btn btn-outline"
                                                                                style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                                onclick="editRoom(<%= room.getId() %>, '<%= room.getRoomNumber() %>', '<%= room.getRoomType() %>', <%= room.getPricePerNight() %>, <%= room.getCapacity() %>, '<%= room.getStatus() %>')">
                                                                                Edit
                                                                            </button>
                                                                            <select class="form-select"
                                                                                style="display: inline; width: auto; padding: 0.25rem 0.5rem; font-size: 0.875rem;"
                                                                                onchange="updateRoomStatus(<%= room.getId() %>, this.value)">
                                                                                <option value="available" <%="available"
                                                                                    .equals(room.getStatus())
                                                                                    ? "selected" : "" %>>Available
                                                                                </option>
                                                                                <option value="occupied" <%="occupied"
                                                                                    .equals(room.getStatus())
                                                                                    ? "selected" : "" %>>Occupied
                                                                                </option>
                                                                                <option value="maintenance"
                                                                                    <%="maintenance"
                                                                                    .equals(room.getStatus())
                                                                                    ? "selected" : "" %>>Maintenance
                                                                                </option>
                                                                            </select>
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

                        <!-- Add/Edit Room Modal -->
                        <div id="roomModal"
                            style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center; overflow-y: auto; padding: 2rem;">
                            <div class="card" style="max-width: 600px; margin: auto;">
                                <div class="card-header">
                                    <h4 class="card-title" id="modalTitle">Add New Room</h4>
                                </div>
                                <div class="card-content">
                                    <form id="roomForm" action="${pageContext.request.contextPath}/rooms" method="post">
                                        <input type="hidden" name="action" id="formAction" value="add">
                                        <input type="hidden" name="id" id="roomId">

                                        <div class="form-group">
                                            <label class="form-label">Room Number *</label>
                                            <input type="text" name="roomNumber" id="roomNumber" class="form-input"
                                                required>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">Room Type *</label>
                                            <select name="roomType" id="roomType" class="form-select" required>
                                                <option value="standard">Standard</option>
                                                <option value="deluxe">Deluxe</option>
                                                <option value="suite">Suite</option>
                                                <option value="ocean_view">Ocean View</option>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">Price per Night *</label>
                                            <input type="number" name="price" id="price" class="form-input" required
                                                min="0" step="0.01">
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">Capacity *</label>
                                            <input type="number" name="capacity" id="capacity" class="form-input"
                                                required min="1" max="10">
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">Description</label>
                                            <textarea name="description" id="description"
                                                class="form-textarea"></textarea>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">Amenities</label>
                                            <input type="text" name="amenities" id="amenities" class="form-input"
                                                placeholder="WiFi, TV, AC...">
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">Image URL</label>
                                            <input type="url" name="imageUrl" id="imageUrl" class="form-input">
                                        </div>

                                        <div class="form-group" id="statusField" style="display: none;">
                                            <label class="form-label">Status</label>
                                            <select name="status" id="status" class="form-select">
                                                <option value="available">Available</option>
                                                <option value="occupied">Occupied</option>
                                                <option value="maintenance">Maintenance</option>
                                            </select>
                                        </div>

                                        <div class="flex gap-2">
                                            <button type="button" class="btn btn-secondary"
                                                onclick="closeRoomModal()">Cancel</button>
                                            <button type="submit" class="btn btn-primary" style="flex: 1;">Save
                                                Room</button>
                                        </div>
                                    </form>
                                </div>
                            </div>


                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                            <script>
                                function showAddRoomModal() {
                                    document.getElementById('modalTitle').textContent = 'Add New Room';
                                    document.getElementById('formAction').value = 'add';
                                    document.getElementById('roomForm').reset();
                                    document.getElementById('statusField').style.display = 'none';
                                    document.getElementById('roomModal').style.display = 'flex';
                                }

                                function editRoom(id, number, type, price, capacity, status) {
                                    document.getElementById('modalTitle').textContent = 'Edit Room';
                                    document.getElementById('formAction').value = 'update';
                                    document.getElementById('roomId').value = id;
                                    document.getElementById('roomNumber').value = number;
                                    document.getElementById('roomType').value = type;
                                    document.getElementById('price').value = price;
                                    document.getElementById('capacity').value = capacity;
                                    document.getElementById('status').value = status;
                                    document.getElementById('statusField').style.display = 'block';
                                    document.getElementById('roomModal').style.display = 'flex';
                                }

                                function closeRoomModal() {
                                    document.getElementById('roomModal').style.display = 'none';
                                }

                                function updateRoomStatus(roomId, status) {
                                    fetch('${pageContext.request.contextPath}/rooms', {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                        body: `action=updateStatus&id=${roomId}&status=${status}`
                                    })
                                        .then(response => response.json())
                                        .then(data => {
                                            if (data.success) {
                                                location.reload();
                                            } else {
                                                alert('Failed to update room status');
                                            }
                                        });
                                }
                            </script>
                    </body>

                    </html>