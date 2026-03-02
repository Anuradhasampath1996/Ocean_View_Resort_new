<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register - Ocean View Resort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>

    <body>
        <!-- Navbar -->
        <nav class="navbar">
            <div class="navbar-container">
                <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand logo-container">
                    <img src="${pageContext.request.contextPath}/images/logo.png" alt="Ocean View Resort"
                        class="logo-image">
                </a>
                <ul class="navbar-nav">
                    <li><a href="${pageContext.request.contextPath}/index.jsp" class="nav-link">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline">Login</a></li>
                </ul>
            </div>
        </nav>

        <section class="section">
            <div class="container container-sm">
                <div class="card" style="max-width: 600px; margin: 2rem auto;">
                    <div class="card-header text-center">
                        <h2 class="card-title">Registration Disabled</h2>
                        <p class="card-description">This is an internal company system</p>
                    </div>
                    <div class="card-content">
                        <div class="alert alert-warning">
                            New user self-registration is not available. Please contact the administrator or front
                            office to create an account.
                        </div>
                        <div class="text-center mt-3">
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary btn-lg">
                                <i class="bi bi-box-arrow-in-right"></i> Go to Login
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>