<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <%@ page import="java.math.BigDecimal" %>
                    <% if (session.getAttribute("role")==null || !"admin".equals(session.getAttribute("role"))) {
                        response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BookingDAO
                        bookingDAO=new BookingDAO(); UserDAO userDAO=new UserDAO(); RoomDAO roomDAO=new RoomDAO();
                        List<Booking> allBookings = bookingDAO.getAllBookings();
                        BigDecimal totalRevenue = bookingDAO.getTotalRevenue();
                        BigDecimal monthlyRevenue = bookingDAO.getMonthlyRevenue();
                        Map<String, Integer> statusCounts = bookingDAO.getBookingCountsByStatus();
                            Map<String, BigDecimal> monthlyChart = bookingDAO.getMonthlyRevenueChart();
                                Map<String, Integer> roomTypeBookings = bookingDAO.getBookingsByRoomType();

                                    int totalUsers = userDAO.getAllUsers().size();
                                    int totalRooms = roomDAO.getAllRooms().size();
                                    int availableRooms = roomDAO.getAvailableRooms().size();

                                    // Filter params
                                    String filterStatus = request.getParameter("status");
                                    String filterFrom = request.getParameter("from");
                                    String filterTo = request.getParameter("to");

                                    List<Booking> filtered = new ArrayList<>();
                                            for (Booking b : allBookings) {
                                            if (filterStatus != null && !filterStatus.isEmpty() &&
                                            !filterStatus.equals(b.getStatus())) continue;
                                            if (filterFrom != null && !filterFrom.isEmpty() && b.getCheckInDate() !=
                                            null
                                            && b.getCheckInDate().toString().compareTo(filterFrom) < 0) continue; if
                                                (filterTo !=null && !filterTo.isEmpty() && b.getCheckInDate() !=null &&
                                                b.getCheckInDate().toString().compareTo(filterTo)> 0) continue;
                                                filtered.add(b);
                                                }
                                                %>
                                                <!DOCTYPE html>
                                                <html lang="en">

                                                <head>
                                                    <meta charset="UTF-8">
                                                    <meta name="viewport"
                                                        content="width=device-width, initial-scale=1.0">
                                                    <title>Reports - Admin - Ocean View Resort</title>
                                                    <link
                                                        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                                        rel="stylesheet">
                                                    <link rel="stylesheet"
                                                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
                                                    <link rel="stylesheet"
                                                        href="${pageContext.request.contextPath}/css/style.css">
                                                    <style>
                                                        .report-stat-grid {
                                                            display: grid;
                                                            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                                                            gap: 1rem;
                                                            margin-bottom: 1.5rem;
                                                        }

                                                        .report-stat {
                                                            background: var(--card);
                                                            border: 1px solid var(--border);
                                                            border-radius: var(--radius);
                                                            padding: 1.25rem;
                                                        }

                                                        .report-stat .label {
                                                            font-size: .75rem;
                                                            color: var(--muted-foreground);
                                                            font-weight: 600;
                                                            text-transform: uppercase;
                                                            letter-spacing: .05em;
                                                            margin-bottom: .4rem;
                                                        }

                                                        .report-stat .value {
                                                            font-size: 1.7rem;
                                                            font-weight: 700;
                                                            color: var(--foreground);
                                                        }

                                                        .report-stat .sub {
                                                            font-size: .8rem;
                                                            color: var(--muted-foreground);
                                                            margin-top: .2rem;
                                                        }

                                                        .chart-bar-wrap {
                                                            display: flex;
                                                            align-items: flex-end;
                                                            gap: .5rem;
                                                            height: 120px;
                                                            margin-top: 1rem;
                                                        }

                                                        .chart-bar-col {
                                                            display: flex;
                                                            flex-direction: column;
                                                            align-items: center;
                                                            flex: 1;
                                                            height: 100%;
                                                            justify-content: flex-end;
                                                        }

                                                        .chart-bar {
                                                            background: linear-gradient(180deg, #0b99d6, #0077a8);
                                                            border-radius: 4px 4px 0 0;
                                                            width: 100%;
                                                            min-height: 4px;
                                                            transition: height .3s;
                                                        }

                                                        .chart-bar-label {
                                                            font-size: .65rem;
                                                            color: var(--muted-foreground);
                                                            margin-top: .3rem;
                                                            text-align: center;
                                                            white-space: nowrap;
                                                        }

                                                        .chart-bar-val {
                                                            font-size: .65rem;
                                                            font-weight: 600;
                                                            color: #0b99d6;
                                                            margin-bottom: .15rem;
                                                        }

                                                        .filter-bar {
                                                            display: flex;
                                                            flex-wrap: wrap;
                                                            gap: .75rem;
                                                            align-items: flex-end;
                                                            margin-bottom: 1.25rem;
                                                        }

                                                        .filter-bar .form-group {
                                                            margin: 0;
                                                        }

                                                        @media print {

                                                            .dashboard-sidebar,
                                                            .sidebar-toggle-btn,
                                                            .sidebar-overlay,
                                                            .filter-bar,
                                                            .no-print {
                                                                display: none !important;
                                                            }

                                                            .dashboard-main-content {
                                                                margin-left: 0 !important;
                                                            }
                                                        }
                                                    </style>
                                                </head>

                                                <body>
                                                    <!-- Sidebar -->
                                                    <aside class="dashboard-sidebar" id="sidebar">
                                                        <div class="sidebar-header">
                                                            <a href="${pageContext.request.contextPath}/index.jsp"
                                                                class="logo-container">
                                                                <img src="${pageContext.request.contextPath}/images/logo.png"
                                                                    alt="Ocean View Resort" class="logo-image sidebar">
                                                            </a>
                                                        </div>
                                                        <div class="sidebar-user">
                                                            <div class="sidebar-user-avatar"><i
                                                                    class="bi bi-person-fill"></i></div>
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
                                                                    class="sidebar-link"><i
                                                                        class="bi bi-speedometer2"></i> Dashboard</a>
                                                            </li>
                                                            <li class="sidebar-accordion-item">
                                                                <button type="button"
                                                                    class="sidebar-link sidebar-accordion-btn"
                                                                    onclick="toggleBookingMenu()"><i
                                                                        class="bi bi-calendar-check"></i> Bookings <i
                                                                        class="bi bi-chevron-down sidebar-chevron"
                                                                        id="bookingChevron"></i></button>
                                                                <ul class="sidebar-submenu" id="bookingSubmenu">
                                                                    <li><a href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                                                            class="sidebar-link sidebar-sublink"><i
                                                                                class="bi bi-list-ul"></i> All
                                                                            Bookings</a></li>
                                                                    <li><a href="${pageContext.request.contextPath}/admin/add-booking.jsp"
                                                                            class="sidebar-link sidebar-sublink"><i
                                                                                class="bi bi-plus-circle"></i> Add
                                                                            Booking</a></li>
                                                                </ul>
                                                            </li>
                                                            <li><a href="${pageContext.request.contextPath}/admin/rooms.jsp"
                                                                    class="sidebar-link"><i class="bi bi-door-open"></i>
                                                                    Rooms</a></li>
                                                            <li><a href="${pageContext.request.contextPath}/admin/customers.jsp"
                                                                    class="sidebar-link"><i class="bi bi-people"></i>
                                                                    Customers</a></li>
                                                            <li><a href="${pageContext.request.contextPath}/admin/staff.jsp"
                                                                    class="sidebar-link"><i
                                                                        class="bi bi-person-badge"></i> Staff</a></li>
                                                            <li><a href="${pageContext.request.contextPath}/admin/reports.jsp"
                                                                    class="sidebar-link active"><i
                                                                        class="bi bi-bar-chart-line"></i> Reports</a>
                                                            </li>
                                                        </ul>
                                                        <div class="sidebar-footer">
                                                            <a href="${pageContext.request.contextPath}/logout"
                                                                class="sidebar-logout-btn"><i
                                                                    class="bi bi-box-arrow-left"></i> Logout</a>
                                                        </div>
                                                    </aside>
                                                    <div class="sidebar-overlay" id="sidebarOverlay"
                                                        onclick="toggleSidebar()"></div>

                                                    <main class="dashboard-main-content" id="mainContent">
                                                        <div class="container-fluid">

                                                            <!-- Header -->
                                                            <div class="flex justify-between items-center mb-4">
                                                                <h2>Booking Reports</h2>
                                                                <button class="btn btn-secondary no-print"
                                                                    onclick="window.print()"><i
                                                                        class="bi bi-printer"></i> Print Report</button>
                                                            </div>

                                                            <!-- Summary Stats -->
                                                            <div class="report-stat-grid">
                                                                <div class="report-stat">
                                                                    <div class="label">Total Bookings</div>
                                                                    <div class="value">
                                                                        <%= allBookings.size() %>
                                                                    </div>
                                                                    <div class="sub">All time</div>
                                                                </div>
                                                                <div class="report-stat">
                                                                    <div class="label">Total Revenue</div>
                                                                    <div class="value">LKR <%= String.format("%,.0f",
                                                                            totalRevenue) %>
                                                                    </div>
                                                                    <div class="sub">Confirmed &amp; completed</div>
                                                                </div>
                                                                <div class="report-stat">
                                                                    <div class="label">This Month</div>
                                                                    <div class="value">LKR <%= String.format("%,.0f",
                                                                            monthlyRevenue) %>
                                                                    </div>
                                                                    <div class="sub">Revenue this month</div>
                                                                </div>
                                                                <div class="report-stat">
                                                                    <div class="label">Occupancy</div>
                                                                    <div class="value">
                                                                        <%= totalRooms> 0 ? (totalRooms -
                                                                            availableRooms) + "/" + totalRooms : "0" %>
                                                                    </div>
                                                                    <div class="sub">Rooms occupied now</div>
                                                                </div>
                                                                <div class="report-stat">
                                                                    <div class="label">Confirmed</div>
                                                                    <div class="value" style="color:#0b99d6;">
                                                                        <%= statusCounts.getOrDefault("confirmed", 0) %>
                                                                    </div>
                                                                    <div class="sub">Bookings</div>
                                                                </div>
                                                                <div class="report-stat">
                                                                    <div class="label">Pending</div>
                                                                    <div class="value" style="color:#f59e0b;">
                                                                        <%= statusCounts.getOrDefault("pending", 0) %>
                                                                    </div>
                                                                    <div class="sub">Awaiting confirmation</div>
                                                                </div>
                                                                <div class="report-stat">
                                                                    <div class="label">Completed</div>
                                                                    <div class="value" style="color:#10b981;">
                                                                        <%= statusCounts.getOrDefault("completed", 0) %>
                                                                    </div>
                                                                    <div class="sub">Checked out</div>
                                                                </div>
                                                                <div class="report-stat">
                                                                    <div class="label">Cancelled</div>
                                                                    <div class="value" style="color:#ef4444;">
                                                                        <%= statusCounts.getOrDefault("cancelled", 0) %>
                                                                    </div>
                                                                    <div class="sub">Cancellations</div>
                                                                </div>
                                                            </div>

                                                            <!-- Charts row -->
                                                            <div class="row mb-4">
                                                                <!-- Revenue chart -->
                                                                <div class="col-md-8 mb-3">
                                                                    <div class="card" style="height:100%;">
                                                                        <div class="card-header">
                                                                            <h5 class="card-title mb-0">Monthly Revenue
                                                                                (Last 6 Months)</h5>
                                                                        </div>
                                                                        <div class="card-content">
                                                                            <% if (monthlyChart.isEmpty()) { %>
                                                                                <p class="text-muted"
                                                                                    style="font-size:.9rem;">No revenue
                                                                                    data yet.</p>
                                                                                <% } else { BigDecimal
                                                                                    maxRev=monthlyChart.values().stream().max(BigDecimal::compareTo).orElse(BigDecimal.ONE);
                                                                                    if
                                                                                    (maxRev.compareTo(BigDecimal.ZERO)==0)
                                                                                    maxRev=BigDecimal.ONE; %>
                                                                                    <div class="chart-bar-wrap">
                                                                                        <% for (Map.Entry<String,
                                                                                            BigDecimal> entry :
                                                                                            monthlyChart.entrySet()) {
                                                                                            int pct =
                                                                                            entry.getValue().multiply(new
                                                                                            BigDecimal(100)).divide(maxRev,
                                                                                            0,
                                                                                            java.math.RoundingMode.HALF_UP).intValue();
                                                                                            %>
                                                                                            <div class="chart-bar-col">
                                                                                                <div
                                                                                                    class="chart-bar-val">
                                                                                                    LKR <%=
                                                                                                        String.format("%,.0f",
                                                                                                        entry.getValue())
                                                                                                        %>
                                                                                                </div>
                                                                                                <div class="chart-bar"
                                                                                                    style="height:<%= pct %>%;">
                                                                                                </div>
                                                                                                <div
                                                                                                    class="chart-bar-label">
                                                                                                    <%= entry.getKey()
                                                                                                        %>
                                                                                                </div>
                                                                                            </div>
                                                                                            <% } %>
                                                                                    </div>
                                                                                    <% } %>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <!-- Bookings by room type -->
                                                                <div class="col-md-4 mb-3">
                                                                    <div class="card" style="height:100%;">
                                                                        <div class="card-header">
                                                                            <h5 class="card-title mb-0">Bookings by Room
                                                                                Type</h5>
                                                                        </div>
                                                                        <div class="card-content">
                                                                            <% int
                                                                                maxRTCount=roomTypeBookings.values().stream().mapToInt(Integer::intValue).max().orElse(1);
                                                                                if (maxRTCount==0) maxRTCount=1; for
                                                                                (Map.Entry<String, Integer> e :
                                                                                roomTypeBookings.entrySet()) {
                                                                                int pct2 = (int)((e.getValue() * 100.0)
                                                                                / maxRTCount);
                                                                                %>
                                                                                <div style="margin-bottom:.75rem;">
                                                                                    <div
                                                                                        style="display:flex;justify-content:space-between;font-size:.85rem;margin-bottom:.25rem;">
                                                                                        <span>
                                                                                            <%= e.getKey().replace("_"," ").toUpperCase() %></span>
                                    <span style=" font-weight:600;">
                                                                                                <%= e.getValue() %>
                                                                                        </span>
                                                                                    </div>
                                                                                    <div
                                                                                        style="background:var(--muted);border-radius:4px;height:8px;">
                                                                                        <div
                                                                                            style="background:linear-gradient(90deg,#0b99d6,#0077a8);width:<%= pct2 %>%;height:8px;border-radius:4px;">
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <% } %>
                                                                                    <% if (roomTypeBookings.isEmpty()) {
                                                                                        %>
                                                                                        <p class="text-muted"
                                                                                            style="font-size:.9rem;">No
                                                                                            data yet.</p>
                                                                                        <% } %>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- Filter & Booking Table -->
                                                            <div class="card">
                                                                <div class="card-header"
                                                                    style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:.5rem;">
                                                                    <h5 class="card-title mb-0">All Bookings</h5>
                                                                    <span
                                                                        style="font-size:.85rem;color:var(--muted-foreground);">Showing
                                                                        <%= filtered.size() %> of <%= allBookings.size()
                                                                                %> bookings
                                                                    </span>
                                                                </div>
                                                                <div class="card-content">
                                                                    <!-- Filters -->
                                                                    <form method="get" class="filter-bar no-print">
                                                                        <div class="form-group">
                                                                            <label class="form-label"
                                                                                style="font-size:.8rem;">Status</label>
                                                                            <select name="status" class="form-select"
                                                                                style="min-width:140px;">
                                                                                <option value="">All Statuses</option>
                                                                                <option value="pending" <%="pending"
                                                                                    .equals(filterStatus) ? "selected"
                                                                                    : "" %>>Pending</option>
                                                                                <option value="confirmed" <%="confirmed"
                                                                                    .equals(filterStatus) ? "selected"
                                                                                    : "" %>>Confirmed</option>
                                                                                <option value="completed" <%="completed"
                                                                                    .equals(filterStatus) ? "selected"
                                                                                    : "" %>>Completed</option>
                                                                                <option value="cancelled" <%="cancelled"
                                                                                    .equals(filterStatus) ? "selected"
                                                                                    : "" %>>Cancelled</option>
                                                                            </select>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="form-label"
                                                                                style="font-size:.8rem;">Check-in
                                                                                From</label>
                                                                            <input type="date" name="from"
                                                                                class="form-input"
                                                                                value="<%= filterFrom != null ? filterFrom : "" %>">
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="form-label"
                                                                                style="font-size:.8rem;">Check-in
                                                                                To</label>
                                                                            <input type="date" name="to"
                                                                                class="form-input"
                                                                                value="<%= filterTo != null ? filterTo : "" %>">
                                                                        </div>
                                                                        <button type="submit" class="btn btn-primary"
                                                                            style="align-self:flex-end;"><i
                                                                                class="bi bi-funnel"></i>
                                                                            Filter</button>
                                                                        <a href="${pageContext.request.contextPath}/admin/reports.jsp"
                                                                            class="btn btn-secondary"
                                                                            style="align-self:flex-end;">Clear</a>
                                                                    </form>

                                                                    <!-- Revenue summary for current filter -->
                                                                    <% BigDecimal filteredRevenue=BigDecimal.ZERO; for
                                                                        (Booking b : filtered) { if
                                                                        (("confirmed".equals(b.getStatus())
                                                                        || "completed" .equals(b.getStatus())) &&
                                                                        b.getTotalAmount() !=null)
                                                                        filteredRevenue=filteredRevenue.add(b.getTotalAmount());
                                                                        } %>
                                                                        <div
                                                                            style="display:flex;gap:1.5rem;margin-bottom:1rem;padding:.75rem 1rem;background:var(--muted);border-radius:var(--radius);font-size:.875rem;">
                                                                            <span><strong>
                                                                                    <%= filtered.size() %>
                                                                                </strong> bookings shown</span>
                                                                            <span><strong>LKR <%= String.format("%,.0f",
                                                                                        filteredRevenue) %></strong>
                                                                                revenue (confirmed + completed)</span>
                                                                        </div>

                                                                        <div class="table-container">
                                                                            <table class="table">
                                                                                <thead>
                                                                                    <tr>
                                                                                        <th>#</th>
                                                                                        <th>Customer</th>
                                                                                        <th>Room</th>
                                                                                        <th>Type</th>
                                                                                        <th>Check-in</th>
                                                                                        <th>Check-out</th>
                                                                                        <th>Guests</th>
                                                                                        <th>Amount (LKR)</th>
                                                                                        <th>Status</th>
                                                                                        <th>Booked On</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody>
                                                                                    <% if (filtered.isEmpty()) { %>
                                                                                        <tr>
                                                                                            <td colspan="10"
                                                                                                style="text-align:center;color:var(--muted-foreground);padding:2rem;">
                                                                                                No bookings match the
                                                                                                selected filters.</td>
                                                                                        </tr>
                                                                                        <% } %>
                                                                                            <% for (Booking b :
                                                                                                filtered) { %>
                                                                                                <tr>
                                                                                                    <td>#<%= b.getId()
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= b.getUserName()
                                                                                                            !=null ?
                                                                                                            b.getUserName()
                                                                                                            : "-" %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= b.getRoomNumber()
                                                                                                            !=null ?
                                                                                                            b.getRoomNumber()
                                                                                                            : "-" %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= b.getRoomType()
                                                                                                            !=null ?
                                                                                                            b.getRoomType().replace("_"," ").toUpperCase() : "
                                                                                                            -" %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= b.getCheckInDate()
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= b.getCheckOutDate()
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= b.getNumberOfGuests()
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= String.format("%,.0f",
                                                                                                            b.getTotalAmount())
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <% String
                                                                                                            st=b.getStatus();
                                                                                                            %>
                                                                                                            <% if
                                                                                                                ("confirmed".equals(st))
                                                                                                                { %>
                                                                                                                <span
                                                                                                                    class="badge badge-success">Confirmed</span>
                                                                                                                <% } else
                                                                                                                    if
                                                                                                                    ("pending".equals(st))
                                                                                                                    { %>
                                                                                                                    <span
                                                                                                                        class="badge badge-warning">Pending</span>
                                                                                                                    <% } else
                                                                                                                        if
                                                                                                                        ("completed".equals(st))
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <span
                                                                                                                            class="badge badge-primary">Completed</span>
                                                                                                                        <% } else
                                                                                                                            {
                                                                                                                            %>
                                                                                                                            <span
                                                                                                                                class="badge badge-danger">Cancelled</span>
                                                                                                                            <% }
                                                                                                                                %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= b.getCreatedAt()
                                                                                                            !=null ?
                                                                                                            b.getCreatedAt().toString().substring(0,10)
                                                                                                            : "-" %>
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