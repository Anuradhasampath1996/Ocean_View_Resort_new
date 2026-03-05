<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login - Ocean View Resort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>

    <body
        style="min-height:100vh; display:flex; align-items:center; justify-content:center; background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%);">

        <section style="width:100%;">
            <div class="container container-sm">
                <div class="card"
                    style="max-width: 500px; margin: 2rem auto; box-shadow: 0 8px 32px rgba(18,152,199,0.15);">
                    <div class="card-header text-center" style="padding-top: 2rem;">
                        <div style="margin-bottom: 1rem;">
                            <img src="${pageContext.request.contextPath}/images/logo.png" alt="Ocean View Resort"
                                style="max-height: 80px; max-width: 220px; object-fit: contain;">
                        </div>
                        <h2 class="card-title">Welcome Back</h2>
                        <p class="card-description">Staff Login</p>
                    </div>
                    <div class="card-content">
                        <% if (request.getAttribute("error") !=null) { %>
                            <div class="alert alert-error">
                                <%= request.getAttribute("error") %>
                            </div>
                            <% } %>

                                <% if (request.getAttribute("success") !=null) { %>
                                    <div class="alert alert-success">
                                        <%= request.getAttribute("success") %>
                                    </div>
                                    <% } %>

                                        <form action="${pageContext.request.contextPath}/auth" method="post">
                                            <input type="hidden" name="action" value="login">

                                            <div class="form-group">
                                                <label class="form-label">Username</label>
                                                <input type="text" name="username" class="form-input"
                                                    placeholder="Enter your username" required>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">Password</label>
                                                <input type="password" name="password" class="form-input"
                                                    placeholder="Enter your password" required>
                                            </div>

                                            <button type="submit" class="btn btn-primary w-full btn-lg">
                                                <i class="bi bi-box-arrow-in-right"></i> Login
                                            </button>
                                        </form>

                                        <div class="text-center mt-3">
                                            <p class="text-muted">Need an account? Please contact your system
                                                administrator.</p>
                                        </div>

                                        <div class="mt-4 p-3"
                                            style="background-color: hsl(var(--muted)); border-radius: var(--radius);">
                                            <p class="text-muted" style="font-size: 0.875rem; margin-bottom: 0.5rem;">
                                                <strong>Demo Credentials:</strong>
                                            </p>
                                            <p class="text-muted"
                                                style="font-size: 0.875rem; margin: 0; line-height: 1.8;">
                                                <strong>Admin:</strong> admin / admin123<br>
                                                <strong>Manager:</strong> manager / manager123<br>
                                                <strong>Receptionist:</strong> receptionist / reception123
                                            </p>
                                        </div>
                    </div>
                </div>
            </div>
        </section>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>