<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"admin".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BookingDAO bookingDAO=new
                    BookingDAO(); RoomDAO roomDAO=new RoomDAO(); UserDAO userDAO=new UserDAO(); int
                    totalBookings=bookingDAO.getTotalBookingsCount(); List<Room> allRooms = roomDAO.getAllRooms();
                    List<User> allUsers = userDAO.getAllUsers();
                        List<Booking> recentBookings = bookingDAO.getAllBookings();

                            int availableRooms = 0;
                            for (Room room : allRooms) {
                            if ("available".equals(room.getStatus())) {
                            availableRooms++;
                            }
                            }
                            %>
                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Admin Dashboard - Ocean View Resort</title>
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
                                                class="sidebar-link active"><i class="bi bi-speedometer2"></i>
                                                Dashboard</a></li>
                                        <li class="sidebar-accordion-item">
                                            <button type="button" class="sidebar-link sidebar-accordion-btn"
                                                onclick="toggleBookingMenu()"><i class="bi bi-calendar-check"></i>
                                                Bookings <i class="bi bi-chevron-down sidebar-chevron"
                                                    id="bookingChevron"></i></button>
                                            <ul class="sidebar-submenu" id="bookingSubmenu">
                                                <li><a href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                                        class="sidebar-link sidebar-sublink"><i
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
                                        <h2 class="mb-4">Dashboard Overview</h2>

                                        <!-- Stats Cards -->
                                        <div class="grid grid-cols-4 mb-4">
                                            <div class="card stat-card">
                                                <div class="stat-value">
                                                    <%= totalBookings %>
                                                </div>
                                                <div class="stat-label">Total Bookings</div>
                                            </div>
                                            <div class="card stat-card">
                                                <div class="stat-value">
                                                    <%= allRooms.size() %>
                                                </div>
                                                <div class="stat-label">Total Rooms</div>
                                            </div>
                                            <div class="card stat-card">
                                                <div class="stat-value">
                                                    <%= availableRooms %>
                                                </div>
                                                <div class="stat-label">Available Rooms</div>
                                            </div>
                                            <div class="card stat-card">
                                                <div class="stat-value">
                                                    <%= allUsers.size() %>
                                                </div>
                                                <div class="stat-label">Total Users</div>
                                            </div>
                                        </div>

                                        <!-- Recent Bookings -->
                                        <div class="card">
                                            <div class="card-header">
                                                <h4 class="card-title">Recent Bookings</h4>
                                            </div>
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
                                                                <th>Amount</th>
                                                                <th>Status</th>
                                                                <th>Invoice</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% int count=0; for (Booking booking : recentBookings) { if
                                                                (count++>= 10) break;
                                                                %>
                                                                <tr>
                                                                    <td>#<%= booking.getId() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= booking.getUserName() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= booking.getRoomNumber() %> (<%=
                                                                                booking.getRoomType() %>)
                                                                    </td>
                                                                    <td>
                                                                        <%= booking.getCheckInDate() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= booking.getCheckOutDate() %>
                                                                    </td>
                                                                    <td>LKR <%= booking.getTotalAmount().doubleValue()
                                                                            %>
                                                                    </td>
                                                                    <td>
                                                                        <% if ("confirmed".equals(booking.getStatus()))
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
                                                                                    <% } else { %>
                                                                                        <span
                                                                                            class="badge badge-secondary">
                                                                                            <%= booking.getStatus() %>
                                                                                        </span>
                                                                                        <% } %>
                                                                    </td>
                                                                    <td>
                                                                        <a class="btn btn-outline"
                                                                            style="padding: 0.25rem 0.75rem; font-size: 0.875rem;"
                                                                            href="${pageContext.request.contextPath}/bookings?action=invoice&id=<%= booking.getId() %>">
                                                                            Download
                                                                        </a>
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                            <div class="card-footer">
                                                <a href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                                    class="btn btn-primary">View All Bookings</a>
                                            </div>
                                        </div>
                                    </div>
                                </main>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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