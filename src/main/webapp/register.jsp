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
                <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">
                    <i class="bi bi-water"></i> Ocean View Resort
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
                        <h2 class="card-title">Create Account</h2>
                        <p class="card-description">Join Ocean View Resort</p>
                    </div>
                    <div class="card-content">
                        <% if (request.getAttribute("error") !=null) { %>
                            <div class="alert alert-error">
                                <%= request.getAttribute("error") %>
                            </div>
                            <% } %>

                                <form action="${pageContext.request.contextPath}/auth" method="post"
                                    onsubmit="return validateForm()">
                                    <input type="hidden" name="action" value="register">

                                    <div class="form-group">
                                        <label class="form-label">Full Name *</label>
                                        <input type="text" name="fullName" id="fullName" class="form-input"
                                            placeholder="John Doe" required>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">Username *</label>
                                        <input type="text" name="username" id="username" class="form-input"
                                            placeholder="johndoe" required minlength="3">
                                        <small class="text-muted">At least 3 characters</small>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">Email *</label>
                                        <input type="email" name="email" id="email" class="form-input"
                                            placeholder="john@example.com" required>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">Phone</label>
                                        <input type="tel" name="phone" id="phone" class="form-input"
                                            placeholder="+1 (555) 123-4567">
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">Password *</label>
                                        <input type="password" name="password" id="password" class="form-input"
                                            placeholder="Enter password" required minlength="6">
                                        <small class="text-muted">At least 6 characters</small>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">Confirm Password *</label>
                                        <input type="password" name="confirmPassword" id="confirmPassword"
                                            class="form-input" placeholder="Confirm password" required>
                                    </div>

                                    <div class="form-group">
                                        <label style="display: flex; align-items: center; cursor: pointer;">
                                            <input type="checkbox" required style="margin-right: 0.5rem;">
                                            <span class="text-muted" style="font-size: 0.875rem;">I agree to the Terms
                                                of Service and Privacy Policy</span>
                                        </label>
                                    </div>

                                    <button type="submit" class="btn btn-primary w-full btn-lg">
                                        <i class="bi bi-person-plus"></i> Create Account
                                    </button>
                                </form>

                                <div class="text-center mt-3">
                                    <p class="text-muted">Already have an account? <a
                                            href="${pageContext.request.contextPath}/login.jsp"
                                            style="color: hsl(var(--ocean-blue));">Login here</a></p>
                                </div>
                    </div>
                </div>
            </div>
        </section>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function validateForm() {
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirmPassword').value;

                if (password !== confirmPassword) {
                    alert('Passwords do not match!');
                    return false;
                }

                if (password.length < 6) {
                    alert('Password must be at least 6 characters long!');
                    return false;
                }

                return true;
            }
        </script>
    </body>

    </html>