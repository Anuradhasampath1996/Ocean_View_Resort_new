<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"admin".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } UserDAO userDAO=new
                    UserDAO(); List<User> allUsers = userDAO.getAllUsers();
                    String successParam = request.getParameter("success");
                    String errorParam = request.getParameter("error");
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Manage Staff - Admin - Ocean View Resort</title>
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
                                        onclick="toggleBookingMenu()"><i class="bi bi-calendar-check"></i> Bookings <i
                                            class="bi bi-chevron-down sidebar-chevron" id="bookingChevron"></i></button>
                                    <ul class="sidebar-submenu" id="bookingSubmenu">
                                        <li><a href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                                class="sidebar-link sidebar-sublink"><i class="bi bi-list-ul"></i> All
                                                Bookings</a></li>
                                        <li><a href="${pageContext.request.contextPath}/admin/add-booking.jsp"
                                                class="sidebar-link sidebar-sublink"><i class="bi bi-plus-circle"></i>
                                                Add Booking</a></li>
                                    </ul>
                                </li>
                                <li><a href="${pageContext.request.contextPath}/admin/rooms.jsp" class="sidebar-link"><i
                                            class="bi bi-door-open"></i> Rooms</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/customers.jsp"
                                        class="sidebar-link"><i class="bi bi-people"></i> Customers</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/staff.jsp"
                                        class="sidebar-link active"><i class="bi bi-person-badge"></i> Staff</a></li>
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
                                    <h2>Manage Staff</h2>
                                    <button class="btn btn-primary" onclick="showAddStaffModal()"><i
                                            class="bi bi-plus-circle"></i> Add Staff</button>
                                </div>

                                <!-- Alerts -->
                                <% if (successParam !=null) { %>
                                    <div class="alert alert-success">
                                        <% if ("added".equals(successParam)) { %>Staff account created successfully!
                                            <% } else if ("updated".equals(successParam)) { %>Staff account updated
                                                successfully!
                                                <% } else if ("deleted".equals(successParam)) { %>Staff account deleted
                                                    successfully!
                                                    <% } else { %>Operation completed successfully!<% } %>
                                    </div>
                                    <% } %>
                                        <% if (errorParam !=null) { %>
                                            <div class="alert alert-danger">
                                                <% if ("add_failed".equals(errorParam)) { %>Failed to create staff.
                                                    Username or email may already be taken.
                                                    <% } else if ("update_failed".equals(errorParam)) { %>Failed to
                                                        update staff account.
                                                        <% } else if ("invalid_role".equals(errorParam)) { %>Invalid
                                                            role specified.
                                                            <% } else { %>Operation failed. Please try again.<% } %>
                                            </div>
                                            <% } %>

                                                <!-- Staff Table -->
                                                <div class="card">
                                                    <div class="card-content p-0">
                                                        <div class="table-container">
                                                            <table class="table">
                                                                <thead>
                                                                    <tr>
                                                                        <th>ID</th>
                                                                        <th>Full Name</th>
                                                                        <th>Username</th>
                                                                        <th>Email</th>
                                                                        <th>Phone</th>
                                                                        <th>Role</th>
                                                                        <th>Created</th>
                                                                        <th>Actions</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <% for (User user : allUsers) { String
                                                                        r=user.getRole(); if ("customer".equals(r))
                                                                        continue; String safeFN=user.getFullName()
                                                                        !=null ?
                                                                        user.getFullName().replace("\"","&quot;") : "" ;
                                                                        String safeUN=user.getUsername() !=null ?
                                                                        user.getUsername().replace("\"","&quot;") : "" ;
                                                                        String safeEM=user.getEmail() !=null ?
                                                                        user.getEmail().replace("\"","&quot;") : "" ;
                                                                        String safePH=user.getPhone() !=null ?
                                                                        user.getPhone().replace("\"","&quot;") : "" ; %>
                                                                        <tr>
                                                                            <td>#<%= user.getId() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= user.getFullName() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= user.getUsername() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= user.getEmail() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= user.getPhone() !=null ?
                                                                                    user.getPhone() : "-" %>
                                                                            </td>
                                                                            <td>
                                                                                <% if ("admin".equals(r)) { %><span
                                                                                        class="badge badge-primary">Admin</span>
                                                                                    <% } else if ("manager".equals(r)) {
                                                                                        %><span
                                                                                            class="badge badge-warning">Manager</span>
                                                                                        <% } else { %><span
                                                                                                class="badge badge-secondary">Receptionist</span>
                                                                                            <% } %>
                                                                            </td>
                                                                            <td>
                                                                                <%= user.getCreatedAt() !=null ?
                                                                                    user.getCreatedAt().toString().substring(0,10)
                                                                                    : "-" %>
                                                                            </td>
                                                                            <td>
                                                                                <button class="btn btn-secondary"
                                                                                    style="padding:0.25rem 0.6rem;font-size:0.8rem;"
                                                                                    onclick="viewStaff('<%= safeFN %>','<%= safeUN %>','<%= safeEM %>','<%= safePH %>','<%= r %>')">
                                                                                    <i class="bi bi-eye"></i>
                                                                                    View</button>
                                                                                <button class="btn btn-outline"
                                                                                    style="padding:0.25rem 0.6rem;font-size:0.8rem;"
                                                                                    onclick="editStaff(<%= user.getId() %>,'<%= safeFN %>','<%= safeUN %>','<%= safeEM %>','<%= safePH %>','<%= r %>')">
                                                                                    <i class="bi bi-pencil"></i>
                                                                                    Edit</button>
                                                                                <% if (!"admin".equals(r)) { %>
                                                                                    <button class="btn btn-danger"
                                                                                        style="padding:0.25rem 0.6rem;font-size:0.8rem;"
                                                                                        onclick="deleteStaff(<%= user.getId() %>,'<%= safeFN %>')">
                                                                                        <i class="bi bi-trash"></i>
                                                                                        Delete</button>
                                                                                    <% } %>
                                                                            </td>
                                                                        </tr>
                                                                        <% } %>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Stats -->
                                                <div class="grid grid-cols-3 mt-4">
                                                    <div class="card stat-card">
                                                        <div class="stat-value">
                                                            <%= allUsers.stream().filter(u ->
                                                                "admin".equals(u.getRole())).count() %>
                                                        </div>
                                                        <div class="stat-label">Admins</div>
                                                    </div>
                                                    <div class="card stat-card">
                                                        <div class="stat-value">
                                                            <%= allUsers.stream().filter(u ->
                                                                "manager".equals(u.getRole())).count() %>
                                                        </div>
                                                        <div class="stat-label">Managers</div>
                                                    </div>
                                                    <div class="card stat-card">
                                                        <div class="stat-value">
                                                            <%= allUsers.stream().filter(u ->
                                                                "receptionist".equals(u.getRole())).count() %>
                                                        </div>
                                                        <div class="stat-label">Receptionists</div>
                                                    </div>
                                                </div>

                            </div><!-- /container -->
                        </main>

                        <!-- ===== VIEW MODAL ===== -->
                        <div id="viewStaffModal"
                            style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.6);z-index:9999;align-items:center;justify-content:center;padding:2rem;">
                            <div class="card" style="max-width:480px;width:100%;margin:auto;">
                                <div class="card-header"
                                    style="display:flex;align-items:center;justify-content:space-between;">
                                    <h4 class="card-title mb-0">Staff Details</h4>
                                    <button type="button" onclick="closeViewStaffModal()"
                                        style="background:none;border:none;font-size:1.4rem;cursor:pointer;color:#666;line-height:1;">&times;</button>
                                </div>
                                <div class="card-content">
                                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;">
                                        <div>
                                            <div
                                                style="font-size:.75rem;color:#888;font-weight:600;text-transform:uppercase;">
                                                Full Name</div>
                                            <div id="vs_fullName" style="font-weight:700;"></div>
                                        </div>
                                        <div>
                                            <div
                                                style="font-size:.75rem;color:#888;font-weight:600;text-transform:uppercase;">
                                                Username</div>
                                            <div id="vs_username"></div>
                                        </div>
                                        <div>
                                            <div
                                                style="font-size:.75rem;color:#888;font-weight:600;text-transform:uppercase;">
                                                Email</div>
                                            <div id="vs_email"></div>
                                        </div>
                                        <div>
                                            <div
                                                style="font-size:.75rem;color:#888;font-weight:600;text-transform:uppercase;">
                                                Phone</div>
                                            <div id="vs_phone"></div>
                                        </div>
                                        <div>
                                            <div
                                                style="font-size:.75rem;color:#888;font-weight:600;text-transform:uppercase;">
                                                Role</div>
                                            <div id="vs_role"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ===== EDIT MODAL ===== -->
                        <div id="editStaffModal"
                            style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.6);z-index:9999;align-items:center;justify-content:center;overflow-y:auto;padding:2rem;">
                            <div class="card" style="max-width:520px;width:100%;margin:auto;">
                                <div class="card-header"
                                    style="display:flex;align-items:center;justify-content:space-between;">
                                    <h4 class="card-title mb-0">Edit Staff</h4>
                                    <button type="button" onclick="closeEditStaffModal()"
                                        style="background:none;border:none;font-size:1.4rem;cursor:pointer;color:#666;">&times;</button>
                                </div>
                                <div class="card-content">
                                    <form action="${pageContext.request.contextPath}/users" method="post">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="source" value="staff">
                                        <input type="hidden" name="id" id="es_id">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group"><label class="form-label">Full Name
                                                        *</label><input type="text" name="fullName" id="es_fullName"
                                                        class="form-input" required></div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group"><label class="form-label">Username
                                                        *</label><input type="text" name="username" id="es_username"
                                                        class="form-input" required></div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group"><label class="form-label">Email *</label><input
                                                        type="email" name="email" id="es_email" class="form-input"
                                                        required></div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group"><label class="form-label">Phone</label><input
                                                        type="text" name="phone" id="es_phone" class="form-input"></div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Role *</label>
                                            <select name="role" id="es_role" class="form-select" required>
                                                <option value="manager">Manager</option>
                                                <option value="receptionist">Receptionist</option>
                                                <option value="admin">Admin</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">New Password <small class="text-muted">(leave
                                                    blank to keep current)</small></label>
                                            <input type="password" name="password" id="es_password" class="form-input"
                                                placeholder="••••••••">
                                        </div>
                                        <div class="flex gap-2">
                                            <button type="button" class="btn btn-secondary"
                                                onclick="closeEditStaffModal()">Cancel</button>
                                            <button type="submit" class="btn btn-primary" style="flex:1;">Save
                                                Changes</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- ===== ADD STAFF MODAL ===== -->
                        <div id="addStaffModal"
                            style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.6);z-index:9999;align-items:center;justify-content:center;overflow-y:auto;padding:2rem;">
                            <div class="card" style="max-width:520px;width:100%;margin:auto;">
                                <div class="card-header"
                                    style="display:flex;align-items:center;justify-content:space-between;">
                                    <h4 class="card-title mb-0">Add Staff Account</h4>
                                    <button type="button" onclick="closeAddStaffModal()"
                                        style="background:none;border:none;font-size:1.4rem;cursor:pointer;color:#666;">&times;</button>
                                </div>
                                <div class="card-content">
                                    <form action="${pageContext.request.contextPath}/users" method="post">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="source" value="staff">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group"><label class="form-label">Full Name
                                                        *</label><input type="text" name="fullName" class="form-input"
                                                        required></div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group"><label class="form-label">Username
                                                        *</label><input type="text" name="username" class="form-input"
                                                        required></div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group"><label class="form-label">Email *</label><input
                                                        type="email" name="email" class="form-input" required></div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group"><label class="form-label">Phone</label><input
                                                        type="text" name="phone" class="form-input"></div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Role *</label>
                                            <select name="role" class="form-select" required>
                                                <option value="manager">Manager</option>
                                                <option value="receptionist">Receptionist</option>
                                                <option value="admin">Admin</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Password *</label>
                                            <input type="password" name="password" class="form-input" required
                                                placeholder="••••••••">
                                        </div>
                                        <div class="flex gap-2">
                                            <button type="button" class="btn btn-secondary"
                                                onclick="closeAddStaffModal()">Cancel</button>
                                            <button type="submit" class="btn btn-primary" style="flex:1;">Create
                                                Account</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            function viewStaff(fullName, username, email, phone, role) {
                                document.getElementById('vs_fullName').textContent = fullName || '-';
                                document.getElementById('vs_username').textContent = username || '-';
                                document.getElementById('vs_email').textContent = email || '-';
                                document.getElementById('vs_phone').textContent = phone || '-';
                                const labels = { manager: 'Manager', receptionist: 'Receptionist', admin: 'Admin' };
                                const badges = { manager: 'badge-warning', receptionist: 'badge-secondary', admin: 'badge-primary' };
                                document.getElementById('vs_role').innerHTML = '<span class="badge ' + (badges[role] || 'badge-secondary') + '">' + (labels[role] || role) + '</span>';
                                document.getElementById('viewStaffModal').style.display = 'flex';
                            }
                            function closeViewStaffModal() { document.getElementById('viewStaffModal').style.display = 'none'; }

                            function editStaff(id, fullName, username, email, phone, role) {
                                document.getElementById('es_id').value = id;
                                document.getElementById('es_fullName').value = fullName;
                                document.getElementById('es_username').value = username;
                                document.getElementById('es_email').value = email;
                                document.getElementById('es_phone').value = phone;
                                document.getElementById('es_role').value = role;
                                document.getElementById('es_password').value = '';
                                document.getElementById('editStaffModal').style.display = 'flex';
                            }
                            function closeEditStaffModal() { document.getElementById('editStaffModal').style.display = 'none'; }

                            function showAddStaffModal() { document.getElementById('addStaffModal').style.display = 'flex'; }
                            function closeAddStaffModal() { document.getElementById('addStaffModal').style.display = 'none'; }

                            function deleteStaff(id, name) {
                                if (!confirm('Delete staff "' + name + '"? This cannot be undone.')) return;
                                fetch('${pageContext.request.contextPath}/users', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: 'action=delete&id=' + id
                                })
                                    .then(r => r.json())
                                    .then(data => {
                                        if (data.success) location.href = '${pageContext.request.contextPath}/admin/staff.jsp?success=deleted';
                                        else alert(data.message || 'Failed to delete staff');
                                    });
                            }

                            function toggleBookingMenu() {
                                var submenu = document.getElementById('bookingSubmenu');
                                var chevron = document.getElementById('bookingChevron');
                                submenu.classList.toggle('open');
                                chevron.classList.toggle('open');
                            }
                            function toggleSidebar() {
                                var sidebar = document.getElementById('sidebar');
                                var mainContent = document.getElementById('mainContent');
                                var overlay = document.getElementById('sidebarOverlay');
                                sidebar.classList.toggle('open');
                                overlay.classList.toggle('active');
                            }
                        </script>
                    </body>

                    </html>