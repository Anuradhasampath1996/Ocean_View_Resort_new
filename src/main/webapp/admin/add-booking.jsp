<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.example.oceanviewresortnew.dao.BookingDAO" %>
        <%@ page import="com.example.oceanviewresortnew.model.Booking" %>
            <% String _role=(String) session.getAttribute("role"); if (_role==null || (!"admin".equals(_role) &&
                !"manager".equals(_role) && !"receptionist".equals(_role))) {
                response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } String
                successBookingIdParam=request.getParameter("bookingId"); Booking confirmedBooking=null; if
                (successBookingIdParam !=null && !successBookingIdParam.isBlank()) { try { BookingDAO bDao=new
                BookingDAO(); confirmedBooking=bDao.getBookingById(Integer.parseInt(successBookingIdParam)); } catch
                (NumberFormatException ignored) {} } %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Add Booking - Admin - Ocean View Resort</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                    <style>
                        /* Stepper */
                        .stepper {
                            display: flex;
                            align-items: flex-start;
                            margin-bottom: 2rem;
                        }

                        .step {
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            flex: 1;
                        }

                        .step-circle {
                            width: 40px;
                            height: 40px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-weight: 700;
                            font-size: 1rem;
                            border: 2px solid #dee2e6;
                            background: #fff;
                            color: #adb5bd;
                            transition: all 0.3s;
                            z-index: 1;
                        }

                        .step.active .step-circle {
                            border-color: #1298c7;
                            background: #1298c7;
                            color: #fff;
                            box-shadow: 0 0 0 4px rgba(18, 152, 199, .15);
                        }

                        .step.completed .step-circle {
                            border-color: #198754;
                            background: #198754;
                            color: #fff;
                        }

                        .step-label {
                            font-size: 0.72rem;
                            font-weight: 600;
                            color: #adb5bd;
                            margin-top: 0.5rem;
                            text-align: center;
                            text-transform: uppercase;
                            letter-spacing: 0.05em;
                            white-space: nowrap;
                        }

                        .step.active .step-label {
                            color: #1298c7;
                        }

                        .step.completed .step-label {
                            color: #198754;
                        }

                        .step-connector {
                            flex: 1;
                            height: 2px;
                            background: #dee2e6;
                            margin: 0 0.4rem;
                            margin-top: 20px;
                            transition: background 0.3s;
                        }

                        .step-connector.completed {
                            background: #198754;
                        }

                        /* Room cards */
                        .room-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
                            gap: 1.2rem;
                            margin-top: 1.25rem;
                        }

                        .room-card {
                            position: relative;
                            border: 2px solid #dee2e6;
                            border-radius: 12px;
                            cursor: pointer;
                            transition: all 0.2s;
                            background: #fff;
                            overflow: hidden;
                        }

                        .room-card-img {
                            width: 100%;
                            height: 160px;
                            object-fit: cover;
                            display: block;
                        }

                        .room-card-img-placeholder {
                            width: 100%;
                            height: 160px;
                            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: #1298c7;
                            font-size: 2.8rem;
                        }

                        .room-card-body {
                            padding: 1rem;
                        }

                        .room-selected-check {
                            position: absolute;
                            top: 8px;
                            right: 8px;
                            background: #1298c7;
                            color: #fff;
                            border-radius: 50%;
                            width: 28px;
                            height: 28px;
                            display: none;
                            align-items: center;
                            justify-content: center;
                            font-size: .9rem;
                            box-shadow: 0 2px 6px rgba(0, 0, 0, .25);
                        }

                        .room-card.selected .room-selected-check {
                            display: flex;
                        }

                        .room-card:hover {
                            border-color: #1298c7;
                            box-shadow: 0 6px 20px rgba(18, 152, 199, .2);
                            transform: translateY(-3px);
                        }

                        .room-card.selected {
                            border-color: #1298c7;
                            box-shadow: 0 6px 20px rgba(18, 152, 199, .3);
                        }

                        .room-card.selected .room-card-img-placeholder {
                            background: linear-gradient(135deg, #bae6fd, #7dd3fc);
                        }

                        .room-type-badge {
                            display: inline-block;
                            padding: 0.18rem 0.55rem;
                            border-radius: 20px;
                            font-size: 0.7rem;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: .05em;
                            background: #eaf6fb;
                            color: #1298c7;
                            margin-bottom: 0.35rem;
                        }

                        .room-price {
                            font-size: 1.1rem;
                            font-weight: 700;
                            color: #1298c7;
                            margin-top: 0.4rem;
                        }

                        .room-price span {
                            font-size: 0.73rem;
                            font-weight: 400;
                            color: #6c757d;
                        }

                        /* Customer search */
                        .customer-result {
                            padding: 0.6rem 1rem;
                            border-bottom: 1px solid #f1f3f5;
                            cursor: pointer;
                            transition: background 0.15s;
                        }

                        .customer-result:last-child {
                            border-bottom: none;
                        }

                        .customer-result:hover {
                            background: #eaf6fb;
                        }

                        .customer-search-list {
                            max-height: 220px;
                            overflow-y: auto;
                            border: 1px solid #dee2e6;
                            border-radius: 8px;
                            margin-top: 0.5rem;
                            display: none;
                        }

                        /* Summary */
                        .summary-row {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            padding: 0.5rem 0;
                            border-bottom: 1px solid #f0f2f5;
                        }

                        .summary-row:last-child {
                            border-bottom: none;
                        }

                        .summary-label {
                            color: #6c757d;
                            font-size: 0.86rem;
                        }

                        .summary-value {
                            font-weight: 600;
                            font-size: 0.86rem;
                        }

                        .summary-total-val {
                            font-weight: 700;
                            font-size: 1.15rem;
                            color: #1298c7;
                        }

                        /* Confirm */
                        .confirm-icon {
                            font-size: 4.5rem;
                            color: #198754;
                        }

                        .confirm-box {
                            text-align: center;
                            padding: 2rem 1rem 1rem;
                        }

                        /* Step panels */
                        .step-panel {
                            display: none;
                            animation: fadeIn .25s ease;
                        }

                        .step-panel.active {
                            display: block;
                        }

                        @keyframes fadeIn {
                            from {
                                opacity: 0;
                                transform: translateY(8px);
                            }

                            to {
                                opacity: 1;
                                transform: translateY(0);
                            }
                        }

                        @media print {

                            .dashboard-sidebar,
                            .dash-header,
                            .btn,
                            .stepper {
                                display: none !important;
                            }
                        }
                    </style>
                </head>

                <body>
                    <!-- Sidebar -->
                    <aside class="dashboard-sidebar" id="sidebar">
                        <div class="sidebar-header">
                            <a href="${pageContext.request.contextPath}/login.jsp" class="logo-container">
                                <img src="${pageContext.request.contextPath}/images/logo.png" alt="Ocean View Resort"
                                    class="logo-image sidebar">
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
                        <% if ("admin".equals(_role)) { %>
                            <ul class="sidebar-nav">
                                <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
                                        class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                                <li class="sidebar-accordion-item">
                                    <button type="button" class="sidebar-link sidebar-accordion-btn"
                                        onclick="toggleBookingMenu()">
                                        <i class="bi bi-calendar-check"></i> Bookings <i
                                            class="bi bi-chevron-down sidebar-chevron open" id="bookingChevron"></i>
                                    </button>
                                    <ul class="sidebar-submenu open" id="bookingSubmenu">
                                        <li><a href="${pageContext.request.contextPath}/admin/bookings.jsp"
                                                class="sidebar-link sidebar-sublink"><i class="bi bi-list-ul"></i> All
                                                Bookings</a></li>
                                        <li><a href="${pageContext.request.contextPath}/admin/add-booking.jsp"
                                                class="sidebar-link sidebar-sublink active"><i
                                                    class="bi bi-plus-circle"></i> Add Booking</a></li>
                                    </ul>
                                </li>
                                <li><a href="${pageContext.request.contextPath}/admin/rooms.jsp" class="sidebar-link"><i
                                            class="bi bi-door-open"></i> Rooms</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/customers.jsp"
                                        class="sidebar-link"><i class="bi bi-people"></i> Customers</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/staff.jsp" class="sidebar-link"><i
                                            class="bi bi-person-badge"></i> Staff</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/reports.jsp"
                                        class="sidebar-link"><i class="bi bi-bar-chart-line"></i> Reports</a></li>
                            </ul>
                            <div class="sidebar-footer">
                                <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout-btn"><i
                                        class="bi bi-box-arrow-left"></i> Logout</a>
                            </div>
                            <% } else if ("manager".equals(_role)) { %>
                                <ul class="sidebar-nav">
                                    <li><a href="${pageContext.request.contextPath}/manager/dashboard.jsp"
                                            class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                                    <li class="sidebar-accordion-item">
                                        <button type="button" class="sidebar-link sidebar-accordion-btn"
                                            onclick="toggleBookingMenu()">
                                            <i class="bi bi-calendar-check"></i> Bookings <i
                                                class="bi bi-chevron-down sidebar-chevron open" id="bookingChevron"></i>
                                        </button>
                                        <ul class="sidebar-submenu open" id="bookingSubmenu">
                                            <li><a href="${pageContext.request.contextPath}/manager/bookings.jsp"
                                                    class="sidebar-link sidebar-sublink"><i class="bi bi-list-ul"></i>
                                                    All Bookings</a></li>
                                            <li><a href="${pageContext.request.contextPath}/admin/add-booking.jsp"
                                                    class="sidebar-link sidebar-sublink active"><i
                                                        class="bi bi-plus-circle"></i> Add Booking</a></li>
                                        </ul>
                                    </li>
                                    <li><a href="${pageContext.request.contextPath}/manager/rooms.jsp"
                                            class="sidebar-link"><i class="bi bi-door-open"></i> Rooms</a></li>
                                    <li><a href="${pageContext.request.contextPath}/manager/staff.jsp"
                                            class="sidebar-link"><i class="bi bi-people"></i> Staff &amp; Guests</a>
                                    </li>
                                    <li><a href="${pageContext.request.contextPath}/manager/reports.jsp"
                                            class="sidebar-link"><i class="bi bi-bar-chart-line"></i> Reports</a></li>
                                </ul>
                                <div class="sidebar-footer">
                                    <form action="${pageContext.request.contextPath}/auth" method="post"
                                        style="margin:0;">
                                        <input type="hidden" name="action" value="logout">
                                        <button type="submit" class="sidebar-logout-btn"><i
                                                class="bi bi-box-arrow-left"></i> Logout</button>
                                    </form>
                                </div>
                                <% } else { /* receptionist */ %>
                                    <ul class="sidebar-nav">
                                        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard.jsp"
                                                class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a>
                                        </li>
                                        <li><a href="${pageContext.request.contextPath}/receptionist/rooms.jsp"
                                                class="sidebar-link"><i class="bi bi-door-open"></i> Room Status</a>
                                        </li>
                                        <li class="sidebar-accordion-item">
                                            <button type="button" class="sidebar-link sidebar-accordion-btn"
                                                onclick="toggleBookingMenu()">
                                                <i class="bi bi-calendar-check"></i> Bookings <i
                                                    class="bi bi-chevron-down sidebar-chevron open"
                                                    id="bookingChevron"></i>
                                            </button>
                                            <ul class="sidebar-submenu open" id="bookingSubmenu">
                                                <li><a href="${pageContext.request.contextPath}/receptionist/bookings.jsp"
                                                        class="sidebar-link sidebar-sublink"><i
                                                            class="bi bi-list-ul"></i> All Bookings</a></li>
                                                <li><a href="${pageContext.request.contextPath}/admin/add-booking.jsp"
                                                        class="sidebar-link sidebar-sublink active"><i
                                                            class="bi bi-plus-circle"></i> Add Booking</a></li>
                                            </ul>
                                        </li>
                                    </ul>
                                    <div class="sidebar-footer">
                                        <form action="${pageContext.request.contextPath}/auth" method="post"
                                            style="margin:0;">
                                            <input type="hidden" name="action" value="logout">
                                            <button type="submit" class="sidebar-logout-btn"><i
                                                    class="bi bi-box-arrow-left"></i> Logout</button>
                                        </form>
                                    </div>
                                    <% } %>
                    </aside>
                    <div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                    <main class="dashboard-main-content" id="mainContent">
                        <div class="container-fluid">

                            <!-- Page header -->
                            <div class="flex justify-between items-center mb-4">
                                <h2 style="margin:0;"><i class="bi bi-plus-circle me-2"></i>Add New Booking</h2>
                                <a href="<%= request.getContextPath() + (" /manager".equals("/" + _role) || "manager"
                                    .equals(_role) ? "/manager/bookings.jsp" : "receptionist" .equals(_role)
                                    ? "/receptionist/bookings.jsp" : "/admin/bookings.jsp" ) %>"
                                    class="btn btn-outline"><i class="bi bi-arrow-left"></i> All Bookings</a>
                            </div>

                            <!-- Stepper -->
                            <div class="stepper" id="stepperEl">
                                <div class="step active" id="stepItem1">
                                    <div class="step-circle">1</div>
                                    <div class="step-label">Select Room</div>
                                </div>
                                <div class="step-connector" id="conn1"></div>
                                <div class="step" id="stepItem2">
                                    <div class="step-circle">2</div>
                                    <div class="step-label">Customer</div>
                                </div>
                                <div class="step-connector" id="conn2"></div>
                                <div class="step" id="stepItem3">
                                    <div class="step-circle">3</div>
                                    <div class="step-label">Details</div>
                                </div>
                                <div class="step-connector" id="conn3"></div>
                                <div class="step" id="stepItem4">
                                    <div class="step-circle"><i class="bi bi-check2"></i></div>
                                    <div class="step-label">Confirm</div>
                                </div>
                            </div>

                            <!-- ===== STEP 1: SELECT ROOM ===== -->
                            <div class="step-panel active card" id="panel1">
                                <div class="card-header">
                                    <h4 class="card-title mb-0"><i class="bi bi-door-open me-2"></i>Select an Available
                                        Room</h4>
                                </div>
                                <div class="card-content">
                                    <div
                                        style="display:flex; gap:1rem; flex-wrap:wrap; align-items:flex-end; margin-bottom:1rem;">
                                        <div class="form-group mb-0">
                                            <label class="form-label">Check-in *</label>
                                            <input type="date" id="s1CheckIn" class="form-input" style="width:160px;">
                                        </div>
                                        <div class="form-group mb-0">
                                            <label class="form-label">Check-out *</label>
                                            <input type="date" id="s1CheckOut" class="form-input" style="width:160px;">
                                        </div>
                                        <button class="btn btn-primary" onclick="searchRooms()" style="height:42px;"><i
                                                class="bi bi-search"></i> Search Rooms</button>
                                    </div>
                                    <div id="roomsMsg" style="display:none;" class="alert"></div>
                                    <div id="roomsGrid" class="room-grid"></div>
                                    <div style="display:flex; justify-content:flex-end; margin-top:1.5rem;">
                                        <button class="btn btn-primary" onclick="goStep2()" id="btnStep1Next"
                                            style="display:none;"><i class="bi bi-arrow-right"></i> Next:
                                            Customer</button>
                                    </div>
                                </div>
                            </div>

                            <!-- ===== STEP 2: CUSTOMER ===== -->
                            <div class="step-panel card" id="panel2">
                                <div class="card-header">
                                    <h4 class="card-title mb-0"><i class="bi bi-person me-2"></i>Select Customer</h4>
                                </div>
                                <div class="card-content">
                                    <div class="flex gap-2 mb-3">
                                        <button type="button" class="btn btn-primary" id="tabExisting"
                                            onclick="showTab('existing')"><i class="bi bi-search"></i> Existing
                                            Customer</button>
                                        <button type="button" class="btn btn-outline" id="tabNew"
                                            onclick="showTab('new')"><i class="bi bi-person-plus"></i> New
                                            Customer</button>
                                    </div>

                                    <div id="panelExisting">
                                        <div class="form-group">
                                            <label class="form-label">Search by name or email</label>
                                            <input type="text" id="custSearchQ" class="form-input"
                                                placeholder="Type to search..." oninput="debounceSearch()"
                                                autocomplete="off">
                                        </div>
                                        <div id="custSearchList" class="customer-search-list"></div>
                                    </div>

                                    <div id="panelNew" style="display:none;">
                                        <div class="form-group">
                                            <label class="form-label">Full Name *</label>
                                            <input type="text" id="newName" class="form-input"
                                                placeholder="Customer full name">
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Email *</label>
                                            <input type="email" id="newEmail" class="form-input"
                                                placeholder="customer@email.com">
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Phone</label>
                                            <input type="text" id="newPhone" class="form-input"
                                                placeholder="+94 77 000 0000">
                                        </div>
                                    </div>

                                    <div id="selectedCustBox"
                                        style="display:none; background:#eaf6fb; border:1px solid #b0dff0; border-radius:8px; padding:0.7rem 1rem; margin-top:0.75rem;">
                                        <i class="bi bi-check-circle-fill" style="color:#198754;"></i>
                                        <strong id="selCustName"></strong> &nbsp;&bull;&nbsp; <span id="selCustEmail"
                                            style="color:#6c757d;font-size:.88rem;"></span>
                                    </div>

                                    <div class="flex justify-between mt-3">
                                        <button class="btn btn-outline" onclick="goStep(1)"><i
                                                class="bi bi-arrow-left"></i> Back</button>
                                        <button class="btn btn-primary" onclick="goStep3()"><i
                                                class="bi bi-arrow-right"></i> Next: Details</button>
                                    </div>
                                </div>
                            </div>

                            <!-- ===== STEP 3: DETAILS ===== -->
                            <div class="step-panel card" id="panel3">
                                <div class="card-header">
                                    <h4 class="card-title mb-0"><i class="bi bi-info-circle me-2"></i>Booking Details
                                    </h4>
                                </div>
                                <div class="card-content">
                                    <!-- Running summary -->
                                    <div
                                        style="background:#f8f9fa; border-radius:8px; padding:1rem; margin-bottom:1.5rem;">
                                        <div class="summary-row"><span class="summary-label">Room</span><span
                                                class="summary-value" id="sumRoom">-</span></div>
                                        <div class="summary-row"><span class="summary-label">Check-in →
                                                Check-out</span><span class="summary-value" id="sumDates">-</span></div>
                                        <div class="summary-row"><span class="summary-label">Customer</span><span
                                                class="summary-value" id="sumCustomer">-</span></div>
                                        <div class="summary-row"><span class="summary-label">Price / Night</span><span
                                                class="summary-value" id="sumPrice">-</span></div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Number of Guests *</label>
                                        <input type="number" id="s3Guests" class="form-input" min="1" max="10" value="1"
                                            style="max-width:130px;" oninput="calcTotal()">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Special Requests</label>
                                        <textarea id="s3Special" class="form-textarea" rows="3"
                                            placeholder="Any special arrangements, dietary needs..."></textarea>
                                    </div>
                                    <div
                                        style="background:#eaf6fb; border-radius:8px; padding:0.9rem 1rem; margin-top:1rem; display:flex; justify-content:space-between; align-items:center;">
                                        <span style="font-weight:600; font-size:.95rem;">Estimated Total</span>
                                        <span id="sumTotal" class="summary-total-val">-</span>
                                    </div>
                                    <div class="flex justify-between mt-3">
                                        <button class="btn btn-outline" onclick="goStep(2)"><i
                                                class="bi bi-arrow-left"></i> Back</button>
                                        <button class="btn btn-primary" onclick="submitBooking()" id="btnSubmit"><i
                                                class="bi bi-check-circle"></i> Confirm Booking</button>
                                    </div>
                                </div>
                            </div>

                            <!-- ===== STEP 4: CONFIRMATION ===== -->
                            <div class="step-panel card" id="panel4">
                                <div class="card-content">
                                    <div class="confirm-box">
                                        <div class="confirm-icon"><i class="bi bi-check-circle-fill"></i></div>
                                        <h3 style="margin-top:1rem; color:#198754;">Booking Confirmed!</h3>
                                        <p style="color:#6c757d;">Booking <strong>#<span id="confId">-</span></strong>
                                            has been created successfully.</p>
                                        <div class="card" style="max-width:420px; margin:1.5rem auto; text-align:left;">
                                            <div class="card-content">
                                                <div class="summary-row"><span
                                                        class="summary-label">Customer</span><span class="summary-value"
                                                        id="confCust">-</span></div>
                                                <div class="summary-row"><span class="summary-label">Room</span><span
                                                        class="summary-value" id="confRoom">-</span></div>
                                                <div class="summary-row"><span
                                                        class="summary-label">Check-in</span><span class="summary-value"
                                                        id="confCI">-</span></div>
                                                <div class="summary-row"><span
                                                        class="summary-label">Check-out</span><span
                                                        class="summary-value" id="confCO">-</span></div>
                                                <div class="summary-row"><span class="summary-label">Guests</span><span
                                                        class="summary-value" id="confGuests">-</span></div>
                                                <div class="summary-row" style="border:none;"><span
                                                        style="font-weight:700;">Total Amount</span><span id="confTotal"
                                                        class="summary-total-val">-</span></div>
                                            </div>
                                        </div>
                                        <div class="flex gap-2 justify-center flex-wrap">
                                            <a id="btnInvoice" class="btn btn-primary" href="#" target="_blank"><i
                                                    class="bi bi-download"></i> Download Invoice</a>
                                            <button class="btn btn-outline" onclick="window.print()"><i
                                                    class="bi bi-printer"></i> Print</button>
                                            <a href="<%= request.getContextPath() + (" manager".equals(_role)
                                                ? "/manager/bookings.jsp" : "receptionist" .equals(_role)
                                                ? "/receptionist/bookings.jsp" : "/admin/bookings.jsp" ) %>"
                                                class="btn btn-secondary"><i class="bi bi-list-ul"></i> All Bookings</a>
                                            <button class="btn btn-outline" onclick="resetWizard()"><i
                                                    class="bi bi-plus-circle"></i> New Booking</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div><!-- /container-fluid -->
                    </main>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        var CTX = '${pageContext.request.contextPath}';

                        var bk = {
                            roomId: null, roomNumber: null, roomType: null, price: null, capacity: null,
                            checkIn: null, checkOut: null,
                            userId: null, custName: null, custEmail: null,
                            newMode: false, newName: null, newEmail: null, newPhone: null,
                            guests: 1, special: '', total: null
                        };

                        // ---- Date setup ----
                        (function () {
                            var today = new Date();
                            var fmt = function (d) { return d.toISOString().split('T')[0]; };
                            var tomorrow = new Date(today); tomorrow.setDate(today.getDate() + 1);
                            var s1ci = document.getElementById('s1CheckIn');
                            var s1co = document.getElementById('s1CheckOut');
                            s1ci.min = fmt(today);
                            s1ci.value = fmt(today);
                            s1co.min = fmt(tomorrow);
                            s1co.value = fmt(tomorrow);
                            s1ci.addEventListener('change', function () {
                                var d = new Date(this.value); d.setDate(d.getDate() + 1);
                                s1co.min = fmt(d);
                                if (!s1co.value || s1co.value <= this.value) s1co.value = fmt(d);
                            });
                        })();

        // ---- Auto-show step 4 if confirmedBooking ----
        <% if (confirmedBooking != null) { %>
                            window.addEventListener('DOMContentLoaded', function () {
                                showStep4(<%= confirmedBooking.getId() %>, {
                                    userName: '<%= confirmedBooking.getUserName() != null ? confirmedBooking.getUserName().replace("'","\\47") : "" %>',
                roomNumber: '<%= confirmedBooking.getRoomNumber() != null ? confirmedBooking.getRoomNumber().replace("'","\\47") : "" %>',
                roomType: '<%= confirmedBooking.getRoomType() != null ? confirmedBooking.getRoomType().replace("'","\\47") : "" %>',
                checkInDate: '<%= confirmedBooking.getCheckInDate() %>',
                                    checkOutDate: '<%= confirmedBooking.getCheckOutDate() %>',
                                    numberOfGuests: <%= confirmedBooking.getNumberOfGuests() %>,
                                    totalAmount: '<%= confirmedBooking.getTotalAmount() %>'
                                });
                            });
        <% } %>

                            // ---- Stepper ----
                            function updateStepper(n) {
                                for (var i = 1; i <= 4; i++) {
                                    var el = document.getElementById('stepItem' + i);
                                    el.classList.remove('active', 'completed');
                                    if (i < n) el.classList.add('completed');
                                    else if (i === n) el.classList.add('active');
                                    if (i < 4) document.getElementById('conn' + i).classList.toggle('completed', i < n);
                                }
                            }

                        function goStep(n) {
                            document.querySelectorAll('.step-panel').forEach(function (p) { p.classList.remove('active'); });
                            document.getElementById('panel' + n).classList.add('active');
                            updateStepper(n);
                            window.scrollTo(0, 0);
                        }

                        // ---- Step 1: Room search ----
                        function searchRooms() {
                            var ci = document.getElementById('s1CheckIn').value;
                            var co = document.getElementById('s1CheckOut').value;
                            if (!ci || !co) { showMsg('Please choose check-in and check-out dates.', 'danger'); return; }
                            if (co <= ci) { showMsg('Check-out must be after check-in.', 'danger'); return; }
                            hideMsg();
                            document.getElementById('roomsGrid').innerHTML = '<div style="color:#888; padding:0.5rem;"><i class="bi bi-hourglass-split"></i> Loading available rooms&hellip;</div>';
                            document.getElementById('btnStep1Next').style.display = 'none';
                            fetch(CTX + '/bookings?action=availableRooms&checkIn=' + ci + '&checkOut=' + co)
                                .then(function (r) { return r.json(); })
                                .then(function (rooms) {
                                    var grid = document.getElementById('roomsGrid');
                                    grid.innerHTML = '';
                                    if (!rooms || rooms.length === 0) {
                                        showMsg('No rooms available for the selected dates.', 'warning');
                                        return;
                                    }
                                    rooms.forEach(function (r) {
                                        var card = document.createElement('div');
                                        card.className = 'room-card';
                                        card.innerHTML =
                                            (r.imageUrl
                                                ? '<img class="room-card-img" src="' + esc(r.imageUrl) + '" alt="Room ' + esc(r.roomNumber) + '" onerror="this.style.display=\'none\';this.nextElementSibling.style.display=\'flex\'">' +
                                                '<div class="room-card-img-placeholder" style="display:none;"><i class="bi bi-image"></i></div>'
                                                : '<div class="room-card-img-placeholder"><i class="bi bi-door-open"></i></div>') +
                                            '<div class="room-selected-check"><i class="bi bi-check2"></i></div>' +
                                            '<div class="room-card-body">' +
                                            '<div class="room-type-badge">' + esc(r.roomType) + '</div>' +
                                            '<div style="font-size:1.1rem;font-weight:700;margin:.3rem 0;">Room ' + esc(r.roomNumber) + '</div>' +
                                            '<div style="font-size:.8rem;color:#6c757d;margin:.15rem 0;"><i class="bi bi-people" style="margin-right:.3rem;"></i>' + r.capacity + ' guest(s)</div>' +
                                            (r.amenities ? '<div style="font-size:.75rem;color:#aaa;margin:.2rem 0;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">' + esc(r.amenities) + '</div>' : '') +
                                            '<div class="room-price" style="margin-top:.5rem;">LKR ' + fmt2(r.pricePerNight) + ' <span>/night</span></div>' +
                                            '</div>';
                                        card.onclick = function () { selectRoom(r, card, ci, co); };
                                        grid.appendChild(card);
                                    });
                                })
                                .catch(function () { showMsg('Failed to load rooms. Please try again.', 'danger'); document.getElementById('roomsGrid').innerHTML = ''; });
                        }

                        function selectRoom(r, card, ci, co) {
                            document.querySelectorAll('.room-card').forEach(function (c) { c.classList.remove('selected'); });
                            card.classList.add('selected');
                            bk.roomId = r.id; bk.roomNumber = r.roomNumber; bk.roomType = r.roomType;
                            bk.price = parseFloat(r.pricePerNight); bk.capacity = r.capacity;
                            bk.checkIn = ci; bk.checkOut = co;
                            document.getElementById('btnStep1Next').style.display = 'inline-block';
                        }

                        function goStep2() {
                            if (!bk.roomId) { showMsg('Please select a room.', 'warning'); return; }
                            goStep(2);
                        }

                        // ---- Step 2: Customer ----
                        var searchTimer = null;
                        function showTab(t) {
                            var isEx = t === 'existing';
                            document.getElementById('panelExisting').style.display = isEx ? 'block' : 'none';
                            document.getElementById('panelNew').style.display = isEx ? 'none' : 'block';
                            document.getElementById('tabExisting').className = isEx ? 'btn btn-primary' : 'btn btn-outline';
                            document.getElementById('tabNew').className = isEx ? 'btn btn-outline' : 'btn btn-primary';
                            bk.newMode = !isEx;
                            if (isEx) { bk.userId = null; document.getElementById('selectedCustBox').style.display = 'none'; }
                        }

                        function debounceSearch() {
                            clearTimeout(searchTimer);
                            searchTimer = setTimeout(doSearch, 320);
                        }

                        function doSearch() {
                            var q = document.getElementById('custSearchQ').value.trim();
                            var list = document.getElementById('custSearchList');
                            if (q.length < 1) { list.style.display = 'none'; return; }
                            fetch(CTX + '/users?action=searchCustomers&q=' + encodeURIComponent(q))
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    list.innerHTML = '';
                                    if (!data || data.length === 0) {
                                        list.innerHTML = '<div class="customer-result" style="color:#888;">No customers found</div>';
                                    } else {
                                        data.forEach(function (c) {
                                            var row = document.createElement('div');
                                            row.className = 'customer-result';
                                            row.innerHTML = '<strong>' + esc(c.fullName || '') + '</strong>' +
                                                (c.email ? ' <span style="color:#888;font-size:.82rem;">' + esc(c.email) + '</span>' : '') +
                                                (c.phone ? '<br><span style="font-size:.76rem;color:#aaa;">' + esc(c.phone) + '</span>' : '');
                                            row.onclick = function () { pickCustomer(c); };
                                            list.appendChild(row);
                                        });
                                    }
                                    list.style.display = 'block';
                                })
                                .catch(function () { list.style.display = 'none'; });
                        }

                        function pickCustomer(c) {
                            bk.userId = c.id; bk.custName = c.fullName; bk.custEmail = c.email || '';
                            document.getElementById('selCustName').textContent = c.fullName || '';
                            document.getElementById('selCustEmail').textContent = c.email || '';
                            document.getElementById('selectedCustBox').style.display = 'block';
                            document.getElementById('custSearchList').style.display = 'none';
                            document.getElementById('custSearchQ').value = c.fullName || '';
                        }

                        function goStep3() {
                            if (!bk.newMode && !bk.userId) { alert('Please select a customer'); return; }
                            if (bk.newMode) {
                                bk.newName = document.getElementById('newName').value.trim();
                                bk.newEmail = document.getElementById('newEmail').value.trim();
                                bk.newPhone = document.getElementById('newPhone').value.trim();
                                if (!bk.newName || !bk.newEmail) { alert('Customer name and email are required'); return; }
                                bk.custName = bk.newName; bk.custEmail = bk.newEmail;
                            }
                            document.getElementById('sumRoom').textContent = 'Room ' + bk.roomNumber + ' (' + bk.roomType + ')';
                            document.getElementById('sumDates').textContent = bk.checkIn + ' → ' + bk.checkOut;
                            document.getElementById('sumCustomer').textContent = bk.custName;
                            document.getElementById('sumPrice').textContent = 'LKR ' + fmt2(bk.price) + '/night';
                            document.getElementById('s3Guests').max = bk.capacity;
                            calcTotal();
                            goStep(3);
                        }

                        function calcTotal() {
                            var ci = new Date(bk.checkIn), co = new Date(bk.checkOut);
                            var nights = Math.max(1, Math.round((co - ci) / 86400000));
                            bk.total = (bk.price * nights).toFixed(2);
                            document.getElementById('sumTotal').textContent = 'LKR ' + fmt2(bk.total);
                        }

                        // ---- Step 4: Submit ----
                        function submitBooking() {
                            var btn = document.getElementById('btnSubmit');
                            btn.disabled = true; btn.textContent = 'Creating...';
                            bk.guests = parseInt(document.getElementById('s3Guests').value) || 1;
                            bk.special = document.getElementById('s3Special').value;

                            var p = new URLSearchParams();
                            p.set('action', 'createByStaff');
                            p.set('responseType', 'json');
                            p.set('roomId', bk.roomId);
                            p.set('checkIn', bk.checkIn);
                            p.set('checkOut', bk.checkOut);
                            p.set('numberOfGuests', bk.guests);
                            p.set('specialRequests', bk.special || '');
                            if (!bk.newMode && bk.userId) {
                                p.set('userId', bk.userId);
                            } else {
                                p.set('newCustomerName', bk.newName);
                                p.set('newCustomerEmail', bk.newEmail);
                                if (bk.newPhone) p.set('newCustomerPhone', bk.newPhone);
                            }

                            fetch(CTX + '/bookings', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: p.toString() })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        fetch(CTX + '/bookings?action=view&id=' + data.bookingId)
                                            .then(function (r2) { return r2.json(); })
                                            .then(function (b) { showStep4(data.bookingId, b); })
                                            .catch(function () { showStep4(data.bookingId, {}); });
                                    } else {
                                        alert(data.message || 'Failed to create booking. Please try again.');
                                        btn.disabled = false; btn.innerHTML = '<i class="bi bi-check-circle"></i> Confirm Booking';
                                    }
                                })
                                .catch(function () {
                                    alert('Failed to create booking. Please try again.');
                                    btn.disabled = false; btn.innerHTML = '<i class="bi bi-check-circle"></i> Confirm Booking';
                                });
                        }

                        function showStep4(id, b) {
                            document.getElementById('confId').textContent = id;
                            document.getElementById('confCust').textContent = b.userName || bk.custName || '-';
                            document.getElementById('confRoom').textContent = 'Room ' + (b.roomNumber || bk.roomNumber || '-') + ' (' + (b.roomType || bk.roomType || '-') + ')';
                            document.getElementById('confCI').textContent = b.checkInDate || bk.checkIn || '-';
                            document.getElementById('confCO').textContent = b.checkOutDate || bk.checkOut || '-';
                            document.getElementById('confGuests').textContent = b.numberOfGuests || bk.guests || '-';
                            document.getElementById('confTotal').textContent = 'LKR ' + fmt2(b.totalAmount || bk.total || 0);
                            document.getElementById('btnInvoice').href = CTX + '/bookings?action=invoice&id=' + id;
                            goStep(4);
                        }

                        function resetWizard() {
                            bk = { roomId: null, roomNumber: null, roomType: null, price: null, capacity: null, checkIn: null, checkOut: null, userId: null, custName: null, custEmail: null, newMode: false, newName: null, newEmail: null, newPhone: null, guests: 1, special: '', total: null };
                            document.getElementById('roomsGrid').innerHTML = '';
                            document.getElementById('btnStep1Next').style.display = 'none';
                            hideMsg();
                            document.getElementById('custSearchQ').value = '';
                            document.getElementById('custSearchList').style.display = 'none';
                            document.getElementById('selectedCustBox').style.display = 'none';
                            document.getElementById('s3Guests').value = 1;
                            document.getElementById('s3Special').value = '';
                            document.getElementById('btnSubmit').disabled = false;
                            document.getElementById('btnSubmit').innerHTML = '<i class="bi bi-check-circle"></i> Confirm Booking';
                            showTab('existing');
                            goStep(1);
                        }

                        // ---- Helpers ----
                        function showMsg(txt, type) {
                            var el = document.getElementById('roomsMsg');
                            el.className = 'alert alert-' + type;
                            el.textContent = txt;
                            el.style.display = 'block';
                        }
                        function hideMsg() { document.getElementById('roomsMsg').style.display = 'none'; }
                        function esc(s) { return s ? String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;') : ''; }
                        function fmt2(n) { return Number(n).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }); }

                        function toggleBookingMenu() {
                            document.getElementById('bookingSubmenu').classList.toggle('open');
                            document.getElementById('bookingChevron').classList.toggle('open');
                        }
                        function toggleSidebar() {
                            document.getElementById('sidebar').classList.toggle('open');
                            document.getElementById('sidebarOverlay').classList.toggle('active');
                        }
                    </script>
                </body>

                </html>