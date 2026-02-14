<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.*" %>
        <%@ page import="com.example.oceanviewresortnew.model.*" %>
            <%@ page import="java.util.*" %>
                <% if (session.getAttribute("role")==null || !"manager".equals(session.getAttribute("role"))) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } UserDAO userDAO=new
                    UserDAO(); BookingDAO bookingDAO=new BookingDAO(); List<User> allUsers = userDAO.getAllUsers();

                    int staffCount = 0;
                    int customerCount = 0;
                    for (User u : allUsers) {
                    if ("customer".equals(u.getRole())) {
                    customerCount++;
                    } else {
                    staffCount++;
                    }
                    }
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Staff & Guests - Manager - Ocean View Resort</title>
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
                                <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">
                                    <i class="bi bi-water"></i> Ocean View Resort
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
                                                class="nav-link"><i class="bi bi-calendar-check"></i> Bookings</a></li>
                                        <li class="nav-item"><a
                                                href="${pageContext.request.contextPath}/manager/rooms.jsp"
                                                class="nav-link"><i class="bi bi-door-open"></i> Rooms</a></li>
                                        <li class="nav-item"><a
                                                href="${pageContext.request.contextPath}/manager/staff.jsp"
                                                class="nav-link active"><i class="bi bi-people"></i> Staff</a></li>
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
                                    <li><a href="${pageContext.request.contextPath}/manager/dashboard.jsp"
                                            class="sidebar-link">
                                            <i class="bi bi-speedometer2"></i> Dashboard
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/manager/bookings.jsp"
                                            class="sidebar-link">
                                            <i class="bi bi-calendar-check"></i> Bookings
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/manager/rooms.jsp"
                                            class="sidebar-link">
                                            <i class="bi bi-door-open"></i> Rooms
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/manager/staff.jsp"
                                            class="sidebar-link active">
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
                                <i class="bi bi-file-earmark-bar-graph"></i> Reports
                                </a></li>
                                </ul>
                                </aside>

                                <main style="flex: 1; padding: 2rem;">
                                    <h2 class="mb-4">Staff & Guests Management</h2>

                                    <div class="grid grid-cols-2 gap-4 mb-6">
                                        <div class="stats-card">
                                            <div class="stats-icon" style="background-color: hsl(var(--ocean-blue));">
                                                <i class="bi bi-person-badge"></i>
                                            </div>
                                            <div>
                                                <div class="stats-value">
                                                    <%= staffCount %>
                                                </div>
                                                <div class="stats-label">Staff Members</div>
                                            </div>
                                        </div>

                                        <div class="stats-card">
                                            <div class="stats-icon" style="background-color: hsl(var(--success));">
                                                <i class="bi bi-people"></i>
                                            </div>
                                            <div>
                                                <div class="stats-value">
                                                    <%= customerCount %>
                                                </div>
                                                <div class="stats-label">Registered Guests</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">All Users</h3>
                                        </div>
                                        <div class="card-content p-0">
                                            <div class="table-responsive">
                                                <table class="table">
                                                    <thead>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Name</th>
                                                            <th>Username</th>
                                                            <th>Email</th>
                                                            <th>Phone</th>
                                                            <th>Role</th>
                                                            <th>Bookings</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% for (User user : allUsers) { String roleBadge="secondary" ;
                                                            if ("admin".equals(user.getRole())) { roleBadge="danger" ; }
                                                            else if ("manager".equals(user.getRole())) {
                                                            roleBadge="primary" ; } else if
                                                            ("receptionist".equals(user.getRole())) { roleBadge="info" ;
                                                            } else { roleBadge="success" ; } int
                                                            userBookings=bookingDAO.getBookingsByUserId(user.getId()).size();
                                                            %>
                                                            <tr>
                                                                <td>
                                                                    <%= user.getId() %>
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
                                                                    <%= user.getPhone() !=null ? user.getPhone() : "-"
                                                                        %>
                                                                </td>
                                                                <td>
                                                                    <span class="badge badge-<%= roleBadge %>">
                                                                        <%= user.getRole().substring(0, 1).toUpperCase()
                                                                            + user.getRole().substring(1) %>
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <%= userBookings %>
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
                    </body>

                    </html>