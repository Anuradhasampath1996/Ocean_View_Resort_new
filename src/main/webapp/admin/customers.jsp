<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"admin".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } UserDAO userDAO=new
                    UserDAO(); BookingDAO bookingDAO=new BookingDAO(); List<User> allUsers = userDAO.getAllUsers();
                    String successParam = request.getParameter("success");
                    String errorParam = request.getParameter("error");
                    long totalCustomers = allUsers.stream().filter(u -> "customer".equals(u.getRole())).count();
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Manage Customers - Admin - Ocean View Resort</title>
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
                                        class="sidebar-link active"><i class="bi bi-people"></i> Customers</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/staff.jsp" class="sidebar-link"><i
                                            class="bi bi-person-badge"></i> Staff</a></li>
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
                                    <h2>Manage Customers</h2>
                                    <button class="btn btn-primary" onclick="showAddModal()"><i
                                            class="bi bi-plus-circle"></i> Add Customer</button>
                                </div>

                                <!-- Alerts -->
                                <% if (successParam !=null) { %>
                                    <div class="alert alert-success">
                                        <% if ("added".equals(successParam)) { %>Customer record created successfully!
                                            <% } else if ("updated".equals(successParam)) { %>Customer record updated
                                                successfully!
                                                <% } else if ("deleted".equals(successParam)) { %>Customer record
                                                    deleted successfully!
                                                    <% } else { %>Operation completed successfully!<% } %>
                                    </div>
                                    <% } %>
                                        <% if (errorParam !=null) { %>
                                            <div class="alert alert-danger">
                                                <% if ("add_failed".equals(errorParam)) { %>Failed to create customer.
                                                    Email may already be registered.
                                                    <% } else if ("update_failed".equals(errorParam)) { %>Failed to
                                                        update customer record.
                                                        <% } else { %>Operation failed. Please try again.<% } %>
                                            </div>
                                            <% } %>

                                                <!-- Stats -->
                                                <div class="grid grid-cols-2 mb-4" style="max-width:500px;">
                                                    <div class="card stat-card">
                                                        <div class="stat-value">
                                                            <%= totalCustomers %>
                                                        </div>
                                                        <div class="stat-label">Total Customers</div>
                                                    </div>
                                                    <div class="card stat-card">
                                                        <div class="stat-value">
                                                            <%= bookingDAO.getAllBookings().size() %>
                                                        </div>
                                                        <div class="stat-label">Total Bookings</div>
                                                    </div>
                                                </div>

                                                <!-- Customers Table -->
                                                <div class="card">
                                                    <div class="card-content p-0">
                                                        <div class="table-container">
                                                            <table class="table">
                                                                <thead>
                                                                    <tr>
                                                                        <th>ID</th>
                                                                        <th>Full Name</th>
                                                                        <th>Email</th>
                                                                        <th>Phone</th>
                                                                        <th>Bookings</th>
                                                                        <th>Registered</th>
                                                                        <th>Actions</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <% for (User user : allUsers) { if
                                                                        (!"customer".equals(user.getRole())) continue;
                                                                        int
                                                                        bookingCount=bookingDAO.getBookingsByUserId(user.getId()).size();
                                                                        String safeFN=user.getFullName() !=null ?
                                                                        user.getFullName().replace("\"","&quot;") : "" ;
                                                                        String safeEM=user.getEmail() !=null ?
                                                                        user.getEmail().replace("\"","&quot;") : "" ;
                                                                        String safePH=user.getPhone() !=null ?
                                                                        user.getPhone().replace("\"","&quot;") : "" ; %>
                                                                        <tr>
                                                                            <td>#<%= user.getId() %>
                                                                            </td>
                                                                            <td><strong>
                                                                                    <%= user.getFullName() %>
                                                                                </strong></td>
                                                                            <td>
                                                                                <%= user.getEmail() !=null ?
                                                                                    user.getEmail() : "-" %>
                                                                            </td>
                                                                            <td>
                                                                                <%= user.getPhone() !=null ?
                                                                                    user.getPhone() : "-" %>
                                                                            </td>
                                                                            <td><span class="badge badge-secondary">
                                                                                    <%= bookingCount %>
                                                                                </span></td>
                                                                            <td>
                                                                                <%= user.getCreatedAt() !=null ?
                                                                                    user.getCreatedAt().toString().substring(0,10)
                                                                                    : "-" %>
                                                                            </td>
                                                                            <td>
                                                                                <button class="btn btn-secondary"
                                                                                    style="padding:0.25rem 0.6rem;font-size:0.8rem;"
                                                                                    onclick="viewCustomer('<%= safeFN %>','<%= safeEM %>','<%= safePH %>','<%= bookingCount %>')">
                                                                                    <i class="bi bi-eye"></i>
                                                                                    View</button>
                                                                                <button class="btn btn-outline"
                                                                                    style="padding:0.25rem 0.6rem;font-size:0.8rem;"
                                                                                    onclick="editCustomer(<%= user.getId() %>,'<%= safeFN %>','<%= safeEM %>','<%= safePH %>')">
                                                                                    <i class="bi bi-pencil"></i>
                                                                                    Edit</button>
                                                                                <button class="btn btn-danger"
                                                                                    style="padding:0.25rem 0.6rem;font-size:0.8rem;"
                                                                                    onclick="deleteCustomer(<%= user.getId() %>,'<%= safeFN %>')">
                                                                                    <i class="bi bi-trash"></i>
                                                                                    Delete</button>
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

                        <!-- ===== VIEW MODAL ===== -->
                        <div id="viewModal"
                            style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.6);z-index:9999;align-items:center;justify-content:center;padding:2rem;">
                            <div class="card" style="max-width:460px;width:100%;margin:auto;">
                                <div class="card-header"
                                    style="display:flex;align-items:center;justify-content:space-between;">
                                    <h4 class="card-title mb-0">Customer Details</h4>
                                    <button type="button" onclick="closeViewModal()"
                                        style="background:none;border:none;font-size:1.4rem;cursor:pointer;color:#666;line-height:1;">&times;</button>
                                </div>
                                <div class="card-content">
                                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;">
                                        <div style="grid-column:1/-1;">
                                            <div
                                                style="font-size:.75rem;color:#888;font-weight:600;text-transform:uppercase;">
                                                Full Name</div>
                                            <div id="vc_name" style="font-weight:700;font-size:1.1rem;"></div>
                                        </div>
                                        <div>
                                            <div
                                                style="font-size:.75rem;color:#888;font-weight:600;text-transform:uppercase;">
                                                Email</div>
                                            <div id="vc_email"></div>
                                        </div>
                                        <div>
                                            <div
                                                style="font-size:.75rem;color:#888;font-weight:600;text-transform:uppercase;">
                                                Phone</div>
                                            <div id="vc_phone"></div>
                                        </div>
                                        <div>
                                            <div
                                                style="font-size:.75rem;color:#888;font-weight:600;text-transform:uppercase;">
                                                Total Bookings</div>
                                            <div id="vc_bookings"
                                                style="font-weight:700;font-size:1.2rem;color:var(--ocean-blue);"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ===== EDIT MODAL ===== -->
                        <div id="editModal"
                            style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.6);z-index:9999;align-items:center;justify-content:center;overflow-y:auto;padding:2rem;">
                            <div class="card" style="max-width:500px;width:100%;margin:auto;">
                                <div class="card-header"
                                    style="display:flex;align-items:center;justify-content:space-between;">
                                    <h4 class="card-title mb-0">Edit Customer</h4>
                                    <button type="button" onclick="closeEditModal()"
                                        style="background:none;border:none;font-size:1.4rem;cursor:pointer;color:#666;">&times;</button>
                                </div>
                                <div class="card-content">
                                    <form action="${pageContext.request.contextPath}/users" method="post">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="source" value="customer">
                                        <input type="hidden" name="role" value="customer">
                                        <input type="hidden" name="id" id="ec_id">
                                        <input type="hidden" name="username" id="ec_username_hidden" value="">
                                        <div class="form-group">
                                            <label class="form-label">Full Name *</label>
                                            <input type="text" name="fullName" id="ec_fullName" class="form-input"
                                                required>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Email *</label>
                                            <input type="email" name="email" id="ec_email" class="form-input" required>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Phone</label>
                                            <input type="text" name="phone" id="ec_phone" class="form-input">
                                        </div>
                                        <div class="flex gap-2 mt-3">
                                            <button type="button" class="btn btn-secondary"
                                                onclick="closeEditModal()">Cancel</button>
                                            <button type="submit" class="btn btn-primary" style="flex:1;">Save
                                                Changes</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- ===== ADD CUSTOMER MODAL ===== -->
                        <div id="addModal"
                            style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.6);z-index:9999;align-items:center;justify-content:center;overflow-y:auto;padding:2rem;">
                            <div class="card" style="max-width:500px;width:100%;margin:auto;">
                                <div class="card-header"
                                    style="display:flex;align-items:center;justify-content:space-between;">
                                    <h4 class="card-title mb-0">Add Customer</h4>
                                    <button type="button" onclick="closeAddModal()"
                                        style="background:none;border:none;font-size:1.4rem;cursor:pointer;color:#666;">&times;</button>
                                </div>
                                <div class="card-content">
                                    <form action="${pageContext.request.contextPath}/users" method="post">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="source" value="customer">
                                        <input type="hidden" name="role" value="customer">
                                        <div class="form-group">
                                            <label class="form-label">Full Name *</label>
                                            <input type="text" name="fullName" class="form-input" required
                                                placeholder="Enter customer full name">
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Email *</label>
                                            <input type="email" name="email" class="form-input" required
                                                placeholder="customer@email.com">
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Phone</label>
                                            <input type="text" name="phone" class="form-input"
                                                placeholder="+94 77 123 4567">
                                        </div>
                                        <div class="flex gap-2 mt-3">
                                            <button type="button" class="btn btn-secondary"
                                                onclick="closeAddModal()">Cancel</button>
                                            <button type="submit" class="btn btn-primary" style="flex:1;">Add
                                                Customer</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            function viewCustomer(name, email, phone, bookings) {
                                document.getElementById('vc_name').textContent = name || '-';
                                document.getElementById('vc_email').textContent = email || '-';
                                document.getElementById('vc_phone').textContent = phone || '-';
                                document.getElementById('vc_bookings').textContent = bookings;
                                document.getElementById('viewModal').style.display = 'flex';
                            }
                            function closeViewModal() { document.getElementById('viewModal').style.display = 'none'; }

                            function editCustomer(id, fullName, email, phone) {
                                document.getElementById('ec_id').value = id;
                                document.getElementById('ec_fullName').value = fullName;
                                document.getElementById('ec_email').value = email;
                                document.getElementById('ec_phone').value = phone;
                                document.getElementById('editModal').style.display = 'flex';
                            }
                            function closeEditModal() { document.getElementById('editModal').style.display = 'none'; }

                            function showAddModal() { document.getElementById('addModal').style.display = 'flex'; }
                            function closeAddModal() { document.getElementById('addModal').style.display = 'none'; }

                            function deleteCustomer(id, name) {
                                if (!confirm('Delete customer "' + name + '"? This cannot be undone.')) return;
                                fetch('${pageContext.request.contextPath}/users', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: 'action=delete&id=' + id
                                })
                                    .then(r => r.json())
                                    .then(data => {
                                        if (data.success) location.href = '${pageContext.request.contextPath}/admin/customers.jsp?success=deleted';
                                        else alert(data.message || 'Failed to delete customer');
                                    });
                            }

                            function toggleBookingMenu() {
                                var submenu = document.getElementById('bookingSubmenu');
                                var chevron = document.getElementById('bookingChevron');
                                submenu.classList.toggle('open');
                                chevron.classList.toggle('open');
                            }
                            function toggleSidebar() {
                                document.getElementById('sidebar').classList.toggle('open');
                                document.getElementById('sidebarOverlay').classList.toggle('active');
                            }
                        </script>
                    </body>

                    </html>