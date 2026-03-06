<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"admin".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } RoomDAO roomDAO=new
                    RoomDAO(); RoomTypeDAO roomTypeDAO=new RoomTypeDAO(); List<Room> allRooms = roomDAO.getAllRooms();
                    List<RoomType> allRoomTypes = roomTypeDAO.getAllRoomTypes();
                        String tabParam = request.getParameter("tab");
                        boolean showTypes = "types".equals(tabParam);
                        String roomsTabClass = showTypes ? "d-none" : "";
                        String typesTabClass = showTypes ? "" : "d-none";
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
                            <!-- Sidebar -->
                            <aside class="dashboard-sidebar" id="sidebar">
                                <div class="sidebar-header">
                                    <a href="${pageContext.request.contextPath}/login.jsp" class="logo-container">
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
                                            class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                                    <li class="sidebar-accordion-item">
                                        <button type="button" class="sidebar-link sidebar-accordion-btn"
                                            onclick="toggleBookingMenu()"><i class="bi bi-calendar-check"></i> Bookings
                                            <i class="bi bi-chevron-down sidebar-chevron"
                                                id="bookingChevron"></i></button>
                                        <ul class="sidebar-submenu" id="bookingSubmenu">
                                            <li><a href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                                    class="sidebar-link sidebar-sublink"><i class="bi bi-list-ul"></i>
                                                    All Bookings</a></li>
                                            <li><a href="${pageContext.request.contextPath}/admin/add-booking.jsp"
                                                    class="sidebar-link sidebar-sublink"><i
                                                        class="bi bi-plus-circle"></i> Add Booking</a></li>
                                        </ul>
                                    </li>
                                    <li><a href="${pageContext.request.contextPath}/admin/rooms.jsp"
                                            class="sidebar-link active"><i class="bi bi-door-open"></i> Rooms</a></li>
                                    <li><a href="${pageContext.request.contextPath}/admin/customers.jsp"
                                            class="sidebar-link"><i class="bi bi-people"></i> Customers</a></li>
                                    <li><a href="${pageContext.request.contextPath}/admin/staff.jsp"
                                            class="sidebar-link"><i class="bi bi-person-badge"></i> Staff</a></li>
                                    <li><a href="${pageContext.request.contextPath}/admin/reports.jsp"
                                            class="sidebar-link"><i class="bi bi-bar-chart-line"></i> Reports</a></li>
                                </ul>
                                <div class="sidebar-footer">
                                    <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout-btn"><i
                                            class="bi bi-box-arrow-left"></i> Logout</a>
                                </div>
                            </aside>
                            <div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <!-- Main Content -->
                            <main class="dashboard-main-content" id="mainContent">
                                <div class="container-fluid">

                                    <!-- Page Header -->
                                    <div class="flex justify-between items-center mb-4">
                                        <h2>Manage Rooms</h2>
                                        <div class="flex gap-2">
                                            <button class="btn btn-secondary" onclick="showTab('types')"><i
                                                    class="bi bi-tags"></i> Room Types</button>
                                            <button class="btn btn-primary"
                                                onclick="showTab('rooms'); showAddRoomModal()"><i
                                                    class="bi bi-plus-circle"></i> Add New Room</button>
                                        </div>
                                    </div>

                                    <!-- Alerts -->
                                    <% if (request.getParameter("success") !=null) { %>
                                        <div class="alert alert-success">
                                            <% if ("added".equals(request.getParameter("success"))) { %>Room added
                                                successfully!
                                                <% } else if ("updated".equals(request.getParameter("success"))) { %>
                                                    Room updated successfully!
                                                    <% } else if ("type_added".equals(request.getParameter("success")))
                                                        { %>Room type added successfully!
                                                        <% } else if
                                                            ("type_updated".equals(request.getParameter("success"))) {
                                                            %>Room type updated successfully!
                                                            <% } else if
                                                                ("type_deleted".equals(request.getParameter("success")))
                                                                { %>Room type deleted successfully!
                                                                <% } %>
                                        </div>
                                        <% } %>
                                            <% if (request.getParameter("error") !=null) { %>
                                                <div class="alert alert-danger">Operation failed. Please try again.
                                                </div>
                                                <% } %>

                                                    <!-- ===== TAB: ROOMS ===== -->
                                                    <div id="tab-rooms" class="<%= roomsTabClass %>">
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
                                                                            <% for (Room room : allRooms) { String
                                                                                safeDesc=room.getDescription() !=null ?
                                                                                room.getDescription().replace("&","&amp;").replace("<","&lt;").replace(">
                                                                                ","&gt;").replace("\"","&quot;") : "";
                                                                                String safeAmen = room.getAmenities() !=
                                                                                null ?
                                                                                room.getAmenities().replace("&","&amp;").replace("
                                                                                <","&lt;").replace(">
                                                                                    ","&gt;").replace("\"","&quot;") :
                                                                                    "";
                                                                                    String safeViewImg =
                                                                                    room.getImageUrl() != null ?
                                                                                    room.getImageUrl().replace("\"","&quot;")
                                                                                    : "";
                                                                                    %>
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
                                                                                        <td>LKR <%=
                                                                                                room.getPricePerNight()
                                                                                                %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%= room.getCapacity() %>
                                                                                                guests
                                                                                        </td>
                                                                                        <td>
                                                                                            <% if
                                                                                                ("available".equals(room.getStatus()))
                                                                                                { %><span
                                                                                                    class="badge badge-success">Available</span>
                                                                                                <% } else if
                                                                                                    ("occupied".equals(room.getStatus()))
                                                                                                    { %><span
                                                                                                        class="badge badge-warning">Occupied</span>
                                                                                                    <% } else { %><span
                                                                                                            class="badge badge-danger">Maintenance</span>
                                                                                                        <% } %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <button
                                                                                                class="btn btn-secondary"
                                                                                                style="padding:0.25rem 0.75rem;font-size:0.875rem;"
                                                                                                data-number="<%= room.getRoomNumber() %>"
                                                                                                data-type="<%= room.getRoomType().replace('_',' ').toUpperCase() %>"
                                                                                                data-price="<%= room.getPricePerNight() %>"
                                                                                                data-capacity="<%= room.getCapacity() %>"
                                                                                                data-status="<%= room.getStatus() %>"
                                                                                                data-desc="<%= safeDesc %>"
                                                                                                data-amenities="<%= safeAmen %>"
                                                                                                data-image="<%= safeViewImg %>"
                                                                                                onclick="viewRoom(this)"><i
                                                                                                    class="bi bi-eye"></i>
                                                                                                View</button>
                                                                                            <button
                                                                                                class="btn btn-outline"
                                                                                                style="padding:0.25rem 0.75rem;font-size:0.875rem;"
                                                                                                onclick="editRoom(<%= room.getId() %>, '<%= room.getRoomNumber() %>', '<%= room.getRoomType() %>', <%= room.getPricePerNight() %>, <%= room.getCapacity() %>, '<%= room.getStatus() %>', '<%= room.getImageUrl() != null ? room.getImageUrl() : "" %>')">Edit</button>
                                                                                            <select class="form-select"
                                                                                                style="display:inline;width:auto;padding:0.25rem 0.5rem;font-size:0.875rem;"
                                                                                                onchange="updateRoomStatus(<%= room.getId() %>, this.value)">
                                                                                                <option
                                                                                                    value="available"
                                                                                                    <%="available"
                                                                                                    .equals(room.getStatus())
                                                                                                    ? "selected" : "" %>
                                                                                                    >Available</option>
                                                                                                <option value="occupied"
                                                                                                    <%="occupied"
                                                                                                    .equals(room.getStatus())
                                                                                                    ? "selected" : "" %>
                                                                                                    >Occupied</option>
                                                                                                <option
                                                                                                    value="maintenance"
                                                                                                    <%="maintenance"
                                                                                                    .equals(room.getStatus())
                                                                                                    ? "selected" : "" %>
                                                                                                    >Maintenance
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

                                                    <!-- ===== TAB: ROOM TYPES ===== -->
                                                    <div id="tab-types" class="<%= typesTabClass %>">
                                                        <div class="flex justify-between items-center mb-3">
                                                            <h5 class="mb-0">Room Types</h5>
                                                            <button class="btn btn-primary btn-sm"
                                                                onclick="showAddTypeModal()"><i
                                                                    class="bi bi-plus-circle"></i> Add Room
                                                                Type</button>
                                                        </div>
                                                        <div class="card">
                                                            <div class="card-content p-0">
                                                                <table class="table">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>#</th>
                                                                            <th>Name (internal)</th>
                                                                            <th>Display Name</th>
                                                                            <th>Actions</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <% for (RoomType rt : allRoomTypes) { %>
                                                                            <tr>
                                                                                <td>
                                                                                    <%= rt.getId() %>
                                                                                </td>
                                                                                <td><code><%= rt.getName() %></code>
                                                                                </td>
                                                                                <td>
                                                                                    <%= rt.getDisplayName() %>
                                                                                </td>
                                                                                <td>
                                                                                    <button class="btn btn-outline"
                                                                                        style="padding:0.25rem 0.75rem;font-size:0.875rem;"
                                                                                        onclick="editType(<%= rt.getId() %>, '<%= rt.getName() %>', '<%= rt.getDisplayName() %>')">Edit</button>
                                                                                    <button class="btn btn-danger"
                                                                                        style="padding:0.25rem 0.75rem;font-size:0.875rem;"
                                                                                        onclick="deleteType(<%= rt.getId() %>, '<%= rt.getDisplayName() %>')">Delete</button>
                                                                                </td>
                                                                            </tr>
                                                                            <% } %>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>

                                </div><!-- /container -->
                            </main>

                            <!-- ===== ADD/EDIT ROOM MODAL ===== -->
                            <div id="roomModal"
                                style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);z-index:9999;align-items:center;justify-content:center;overflow-y:auto;padding:2rem;">
                                <div class="card" style="max-width:900px;width:100%;margin:auto;">
                                    <div class="card-header">
                                        <h4 class="card-title" id="modalTitle">Add New Room</h4>
                                    </div>
                                    <div class="card-content">
                                        <form id="roomForm" action="${pageContext.request.contextPath}/rooms"
                                            method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="action" id="formAction" value="add">
                                            <input type="hidden" name="id" id="roomId">
                                            <input type="hidden" name="existingImageUrl" id="existingImageUrl">

                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="form-label">Room Number *</label>
                                                        <input type="text" name="roomNumber" id="roomNumber"
                                                            class="form-input" required>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="form-label">Room Type *</label>
                                                        <select name="roomType" id="roomType" class="form-select"
                                                            required>
                                                            <% for (RoomType rt : allRoomTypes) { %>
                                                                <option value="<%= rt.getName() %>">
                                                                    <%= rt.getDisplayName() %>
                                                                </option>
                                                                <% } %>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="form-label">Price per Night (LKR) *</label>
                                                        <input type="number" name="price" id="price" class="form-input"
                                                            required min="0" step="0.01">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="form-label">Capacity *</label>
                                                        <input type="number" name="capacity" id="capacity"
                                                            class="form-input" required min="1" max="20">
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">Description</label>
                                                <textarea name="description" id="description" class="form-textarea"
                                                    rows="3"></textarea>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">Amenities</label>
                                                <input type="text" name="amenities" id="amenities" class="form-input"
                                                    placeholder="WiFi, TV, AC, Mini Bar...">
                                            </div>

                                            <!-- Image: Upload or URL -->
                                            <div class="form-group">
                                                <label class="form-label">Room Image</label>
                                                <div class="mb-2">
                                                    <div class="form-check form-check-inline">
                                                        <input class="form-check-input" type="radio" name="imageMode"
                                                            id="modeUpload" value="upload" checked
                                                            onchange="toggleImageMode()">
                                                        <label class="form-check-label" for="modeUpload">Upload
                                                            Image</label>
                                                    </div>
                                                    <div class="form-check form-check-inline">
                                                        <input class="form-check-input" type="radio" name="imageMode"
                                                            id="modeUrl" value="url" onchange="toggleImageMode()">
                                                        <label class="form-check-label" for="modeUrl">Image URL</label>
                                                    </div>
                                                </div>
                                                <div id="uploadSection">
                                                    <input type="file" name="imageFile" id="imageFile"
                                                        class="form-control" accept="image/*"
                                                        onchange="previewImage(this)">
                                                    <small class="text-muted">Max 5MB. JPG, PNG, WEBP supported.</small>
                                                    <div id="imagePreviewWrap" class="mt-2" style="display:none;">
                                                        <img id="imagePreview" src="" alt="Preview"
                                                            style="max-height:150px;border-radius:8px;border:1px solid #ddd;">
                                                    </div>
                                                    <div id="existingImageWrap" class="mt-2" style="display:none;">
                                                        <small class="text-muted">Current image:</small><br>
                                                        <img id="existingImagePreview" src="" alt="Current"
                                                            style="max-height:100px;border-radius:8px;border:1px solid #ddd;margin-top:4px;">
                                                    </div>
                                                </div>
                                                <div id="urlSection" style="display:none;">
                                                    <input type="url" name="imageUrl" id="imageUrl" class="form-input"
                                                        placeholder="https://...">
                                                </div>
                                            </div>

                                            <div class="form-group" id="statusField" style="display:none;">
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
                                                <button type="submit" class="btn btn-primary" style="flex:1;">Save
                                                    Room</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- ===== ADD/EDIT ROOM TYPE MODAL ===== -->
                            <div id="typeModal"
                                style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);z-index:9999;align-items:center;justify-content:center;padding:2rem;">
                                <div class="card" style="max-width:480px;width:100%;margin:auto;">
                                    <div class="card-header">
                                        <h4 class="card-title" id="typeModalTitle">Add Room Type</h4>
                                    </div>
                                    <div class="card-content">
                                        <form id="typeForm" action="${pageContext.request.contextPath}/room-types"
                                            method="post">
                                            <input type="hidden" name="action" id="typeAction" value="add">
                                            <input type="hidden" name="id" id="typeId">
                                            <div class="form-group">
                                                <label class="form-label">Display Name * <small
                                                        class="text-muted">(shown to users, e.g. "Ocean
                                                        View")</small></label>
                                                <input type="text" name="displayName" id="typeDisplayName"
                                                    class="form-input" required placeholder="Ocean View">
                                            </div>
                                            <div class="form-group">
                                                <label class="form-label">Internal Name * <small
                                                        class="text-muted">(auto-filled from display
                                                        name)</small></label>
                                                <input type="text" name="name" id="typeName" class="form-input" required
                                                    placeholder="ocean_view">
                                            </div>
                                            <div class="flex gap-2">
                                                <button type="button" class="btn btn-secondary"
                                                    onclick="closeTypeModal()">Cancel</button>
                                                <button type="submit" class="btn btn-primary" style="flex:1;">Save
                                                    Type</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- ===== VIEW ROOM MODAL ===== -->
                            <div id="viewRoomModal"
                                style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.6);z-index:9999;align-items:center;justify-content:center;overflow-y:auto;padding:2rem;">
                                <div class="card" style="max-width:720px;width:100%;margin:auto;">
                                    <div class="card-header"
                                        style="display:flex;align-items:center;justify-content:space-between;">
                                        <h4 class="card-title mb-0">Room Details</h4>
                                        <button type="button" onclick="closeViewModal()"
                                            style="background:none;border:none;font-size:1.4rem;cursor:pointer;color:#666;line-height:1;">&times;</button>
                                    </div>
                                    <div class="card-content" style="padding:0;">
                                        <div id="viewRoomImage" style="display:none;">
                                            <img id="viewRoomImg" src="" alt="Room Image"
                                                style="width:100%;max-height:300px;object-fit:cover;border-radius:0;">
                                        </div>
                                        <div style="padding:1.5rem;">
                                            <div class="row"
                                                style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;margin-bottom:1rem;">
                                                <div>
                                                    <div
                                                        style="font-size:0.75rem;color:#888;font-weight:600;text-transform:uppercase;letter-spacing:.05em;">
                                                        Room Number</div>
                                                    <div id="viewNumber" style="font-size:1.1rem;font-weight:700;">
                                                    </div>
                                                </div>
                                                <div>
                                                    <div
                                                        style="font-size:0.75rem;color:#888;font-weight:600;text-transform:uppercase;letter-spacing:.05em;">
                                                        Room Type</div>
                                                    <div id="viewType" style="font-size:1rem;font-weight:600;"></div>
                                                </div>
                                                <div>
                                                    <div
                                                        style="font-size:0.75rem;color:#888;font-weight:600;text-transform:uppercase;letter-spacing:.05em;">
                                                        Price / Night</div>
                                                    <div id="viewPrice" style="font-size:1rem;font-weight:600;"></div>
                                                </div>
                                                <div>
                                                    <div
                                                        style="font-size:0.75rem;color:#888;font-weight:600;text-transform:uppercase;letter-spacing:.05em;">
                                                        Capacity</div>
                                                    <div id="viewCapacity" style="font-size:1rem;"></div>
                                                </div>
                                            </div>
                                            <div style="margin-bottom:1rem;">
                                                <div
                                                    style="font-size:0.75rem;color:#888;font-weight:600;text-transform:uppercase;letter-spacing:.05em;">
                                                    Status</div>
                                                <div id="viewStatus"></div>
                                            </div>
                                            <div id="viewDescBlock" style="margin-bottom:1rem;display:none;">
                                                <div
                                                    style="font-size:0.75rem;color:#888;font-weight:600;text-transform:uppercase;letter-spacing:.05em;margin-bottom:.4rem;">
                                                    Description</div>
                                                <div id="viewDesc" style="font-size:0.9rem;line-height:1.6;"></div>
                                            </div>
                                            <div id="viewAmenBlock" style="display:none;">
                                                <div
                                                    style="font-size:0.75rem;color:#888;font-weight:600;text-transform:uppercase;letter-spacing:.05em;margin-bottom:.4rem;">
                                                    Amenities</div>
                                                <div id="viewAmen" style="display:flex;flex-wrap:wrap;gap:.4rem;"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                            <script>
                                // ---- Tab switching ----
                                function showTab(tab) {
                                    document.getElementById('tab-rooms').classList.toggle('d-none', tab !== 'rooms');
                                    document.getElementById('tab-types').classList.toggle('d-none', tab !== 'types');
                                }

                                // ---- View Room Modal ----
                                function viewRoom(btn) {
                                    const d = btn.dataset;
                                    document.getElementById('viewNumber').textContent = d.number;
                                    document.getElementById('viewType').textContent = d.type;
                                    document.getElementById('viewPrice').textContent = 'LKR ' + d.price;
                                    document.getElementById('viewCapacity').textContent = d.capacity + ' guests';
                                    const statusEl = document.getElementById('viewStatus');
                                    const sc = d.status === 'available' ? 'badge-success' : d.status === 'occupied' ? 'badge-warning' : 'badge-danger';
                                    const sl = d.status.charAt(0).toUpperCase() + d.status.slice(1);
                                    statusEl.innerHTML = '<span class="badge ' + sc + '">' + sl + '</span>';
                                    const descBlock = document.getElementById('viewDescBlock');
                                    if (d.desc && d.desc.trim()) {
                                        document.getElementById('viewDesc').textContent = d.desc;
                                        descBlock.style.display = 'block';
                                    } else { descBlock.style.display = 'none'; }
                                    const amenBlock = document.getElementById('viewAmenBlock');
                                    if (d.amenities && d.amenities.trim()) {
                                        const amenEl = document.getElementById('viewAmen');
                                        amenEl.innerHTML = d.amenities.split(',').map(a => '<span style="background:#e8f4fd;color:#0b99d6;padding:.2rem .6rem;border-radius:999px;font-size:.8rem;font-weight:500;">' + a.trim() + '</span>').join('');
                                        amenBlock.style.display = 'block';
                                    } else { amenBlock.style.display = 'none'; }
                                    const imgWrap = document.getElementById('viewRoomImage');
                                    if (d.image && d.image.trim()) {
                                        document.getElementById('viewRoomImg').src = d.image;
                                        imgWrap.style.display = 'block';
                                    } else { imgWrap.style.display = 'none'; }
                                    document.getElementById('viewRoomModal').style.display = 'flex';
                                }
                                function closeViewModal() {
                                    document.getElementById('viewRoomModal').style.display = 'none';
                                }

                                // ---- Room Modal ----
                                function showAddRoomModal() {
                                    document.getElementById('modalTitle').textContent = 'Add New Room';
                                    document.getElementById('formAction').value = 'add';
                                    document.getElementById('roomForm').reset();
                                    document.getElementById('statusField').style.display = 'none';
                                    document.getElementById('existingImageWrap').style.display = 'none';
                                    document.getElementById('imagePreviewWrap').style.display = 'none';
                                    document.getElementById('roomModal').style.display = 'flex';
                                }

                                function editRoom(id, number, type, price, capacity, status, imageUrl) {
                                    document.getElementById('modalTitle').textContent = 'Edit Room';
                                    document.getElementById('formAction').value = 'update';
                                    document.getElementById('roomId').value = id;
                                    document.getElementById('roomNumber').value = number;
                                    document.getElementById('roomType').value = type;
                                    document.getElementById('price').value = price;
                                    document.getElementById('capacity').value = capacity;
                                    document.getElementById('status').value = status;
                                    document.getElementById('statusField').style.display = 'block';
                                    document.getElementById('existingImageUrl').value = imageUrl;
                                    document.getElementById('imagePreviewWrap').style.display = 'none';
                                    if (imageUrl) {
                                        document.getElementById('existingImageWrap').style.display = 'block';
                                        document.getElementById('existingImagePreview').src = imageUrl;
                                    } else {
                                        document.getElementById('existingImageWrap').style.display = 'none';
                                    }
                                    document.getElementById('roomModal').style.display = 'flex';
                                }

                                function closeRoomModal() {
                                    document.getElementById('roomModal').style.display = 'none';
                                }

                                function toggleImageMode() {
                                    const isUpload = document.getElementById('modeUpload').checked;
                                    document.getElementById('uploadSection').style.display = isUpload ? 'block' : 'none';
                                    document.getElementById('urlSection').style.display = isUpload ? 'none' : 'block';
                                }

                                function previewImage(input) {
                                    if (input.files && input.files[0]) {
                                        const reader = new FileReader();
                                        reader.onload = e => {
                                            document.getElementById('imagePreview').src = e.target.result;
                                            document.getElementById('imagePreviewWrap').style.display = 'block';
                                            document.getElementById('existingImageWrap').style.display = 'none';
                                        };
                                        reader.readAsDataURL(input.files[0]);
                                    }
                                }

                                function updateRoomStatus(roomId, status) {
                                    fetch('${pageContext.request.contextPath}/rooms', {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                        body: 'action=updateStatus&id=' + roomId + '&status=' + status
                                    })
                                        .then(r => r.json())
                                        .then(data => { if (data.success) location.reload(); else alert('Failed to update status'); });
                                }

                                // ---- Room Type Modal ----
                                function showAddTypeModal() {
                                    document.getElementById('typeModalTitle').textContent = 'Add Room Type';
                                    document.getElementById('typeAction').value = 'add';
                                    document.getElementById('typeForm').reset();
                                    document.getElementById('typeModal').style.display = 'flex';
                                }

                                function editType(id, name, displayName) {
                                    document.getElementById('typeModalTitle').textContent = 'Edit Room Type';
                                    document.getElementById('typeAction').value = 'update';
                                    document.getElementById('typeId').value = id;
                                    document.getElementById('typeName').value = name;
                                    document.getElementById('typeDisplayName').value = displayName;
                                    document.getElementById('typeModal').style.display = 'flex';
                                }

                                function closeTypeModal() {
                                    document.getElementById('typeModal').style.display = 'none';
                                }

                                function deleteType(id, name) {
                                    if (!confirm('Delete room type "' + name + '"? Rooms assigned this type will keep the value but it will no longer appear in dropdowns.')) return;
                                    fetch('${pageContext.request.contextPath}/room-types', {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                        body: 'action=delete&id=' + id
                                    })
                                        .then(r => r.json())
                                        .then(data => { if (data.success) location.href = '${pageContext.request.contextPath}/admin/rooms.jsp?tab=types&success=type_deleted'; else alert('Failed to delete type'); });
                                }

                                // Auto-fill internal name from display name
                                document.getElementById('typeDisplayName').addEventListener('input', function () {
                                    if (document.getElementById('typeAction').value === 'add') {
                                        document.getElementById('typeName').value = this.value.trim().toLowerCase().replace(/\s+/g, '_');
                                    }
                                });

                                // ---- Sidebar ----
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