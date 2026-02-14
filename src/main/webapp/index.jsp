<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ocean View Resort - Luxury Accommodation by the Sea</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>

    <body>
        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg navbar-light sticky-top">
            <div class="container-fluid navbar-container">
                <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">
                    <i class="bi bi-water"></i> Ocean View Resort
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item"><a href="#home" class="nav-link active">Home</a></li>
                        <li class="nav-item"><a href="#rooms" class="nav-link">Rooms</a></li>
                        <li class="nav-item"><a href="#amenities" class="nav-link">Amenities</a></li>
                        <li class="nav-item"><a href="#contact" class="nav-link">Contact</a></li>
                        <% if (session.getAttribute("user") !=null) { %>
                            <li class="nav-item">
                                <a href="${pageContext.request.contextPath}/<%= session.getAttribute(" role")
                                    %>/dashboard.jsp" class="btn btn-primary ms-2">Dashboard</a>
                            </li>
                            <li class="nav-item">
                                <form action="${pageContext.request.contextPath}/auth" method="post"
                                    style="display: inline;">
                                    <input type="hidden" name="action" value="logout">
                                    <button type="submit" class="btn btn-ghost ms-2">Logout</button>
                                </form>
                            </li>
                            <% } else { %>
                                <li class="nav-item">
                                    <a href="${pageContext.request.contextPath}/login.jsp"
                                        class="btn btn-outline ms-2">Login</a>
                                </li>
                                <li class="nav-item">
                                    <a href="${pageContext.request.contextPath}/register.jsp"
                                        class="btn btn-primary ms-2">Register</a>
                                </li>
                                <% } %>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Hero Section -->
        <section class="hero" id="home">
            <div class="hero-content">
                <h1>Welcome to Paradise</h1>
                <p>Experience luxury and tranquility at Ocean View Resort</p>
                <div class="flex gap-4" style="justify-content: center;">
                    <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary btn-lg">Book
                        Now</a>
                    <a href="#rooms" class="btn btn-secondary btn-lg">Explore Rooms</a>
                </div>
            </div>
        </section>

        <!-- Features Section -->
        <section class="section">
            <div class="container">
                <div class="section-title">
                    <h2>Why Choose Ocean View Resort?</h2>
                    <p class="text-muted">Experience the perfect blend of luxury and comfort</p>
                </div>
                <div class="grid grid-cols-4">
                    <div class="card">
                        <div class="card-content text-center">
                            <i class="bi bi-water" style="font-size: 3rem; color: hsl(var(--ocean-blue));"></i>
                            <h4 class="mt-3">Ocean Front</h4>
                            <p class="text-muted">Stunning views of the pristine ocean from every room</p>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-content text-center">
                            <i class="bi bi-star-fill" style="font-size: 3rem; color: hsl(var(--ocean-blue));"></i>
                            <h4 class="mt-3">5-Star Service</h4>
                            <p class="text-muted">World-class hospitality and personalized attention</p>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-content text-center">
                            <i class="bi bi-cup-hot" style="font-size: 3rem; color: hsl(var(--ocean-blue));"></i>
                            <h4 class="mt-3">Fine Dining</h4>
                            <p class="text-muted">Award-winning restaurants with ocean views</p>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-content text-center">
                            <i class="bi bi-heart-pulse" style="font-size: 3rem; color: hsl(var(--ocean-blue));"></i>
                            <h4 class="mt-3">Spa & Wellness</h4>
                            <p class="text-muted">Rejuvenate your body and mind at our luxury spa</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Rooms Section -->
        <section class="section" id="rooms" style="background-color: hsl(var(--muted));">
            <div class="container">
                <div class="section-title">
                    <h2>Our Rooms</h2>
                    <p class="text-muted">Choose from our selection of luxurious accommodations</p>
                </div>
                <div class="grid grid-cols-3">
                    <!-- Standard Room -->
                    <div class="card room-card">
                        <img src="https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=400&h=300&fit=crop"
                            alt="Standard Room" class="room-image">
                        <div class="card-content">
                            <span class="room-type">Standard Room</span>
                            <h4 class="mt-2">Comfort & Style</h4>
                            <p class="text-muted mt-2">Perfect for couples seeking a comfortable stay with modern
                                amenities.</p>
                            <div class="flex items-center justify-between mt-3">
                                <div class="room-price">LKR 15,000<span class="text-muted"
                                        style="font-size: 0.875rem;">/night</span></div>
                                <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary">Book
                                    Now</a>
                            </div>
                        </div>
                    </div>

                    <!-- Deluxe Room -->
                    <div class="card room-card">
                        <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop"
                            alt="Deluxe Room" class="room-image">
                        <div class="card-content">
                            <span class="room-type">Deluxe Room</span>
                            <h4 class="mt-2">Extra Space & Luxury</h4>
                            <p class="text-muted mt-2">Spacious rooms with premium furnishings and enhanced amenities.
                            </p>
                            <div class="flex items-center justify-between mt-3">
                                <div class="room-price">LKR 25,000<span class="text-muted"
                                        style="font-size: 0.875rem;">/night</span></div>
                                <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary">Book
                                    Now</a>
                            </div>
                        </div>
                    </div>

                    <!-- Ocean View Suite -->
                    <div class="card room-card">
                        <img src="https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=400&h=300&fit=crop"
                            alt="Ocean View Suite" class="room-image">
                        <div class="card-content">
                            <span class="room-type">Ocean View Suite</span>
                            <h4 class="mt-2">Ultimate Luxury</h4>
                            <p class="text-muted mt-2">Breathtaking ocean views from your private balcony suite.</p>
                            <div class="flex items-center justify-between mt-3">
                                <div class="room-price">LKR 45,000<span class="text-muted"
                                        style="font-size: 0.875rem;">/night</span></div>
                                <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary">Book
                                    Now</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Amenities Section -->
        <section class="section" id="amenities">
            <div class="container">
                <div class="section-title">
                    <h2>Resort Amenities</h2>
                    <p class="text-muted">Everything you need for a perfect vacation</p>
                </div>
                <div class="grid grid-cols-2">
                    <div class="card">
                        <div class="card-content">
                            <div class="flex gap-4">
                                <i class="bi bi-wifi" style="font-size: 2rem; color: hsl(var(--ocean-blue));"></i>
                                <div>
                                    <h5>Free High-Speed WiFi</h5>
                                    <p class="text-muted">Stay connected throughout the resort</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-content">
                            <div class="flex gap-4">
                                <i class="bi bi-p-circle" style="font-size: 2rem; color: hsl(var(--ocean-blue));"></i>
                                <div>
                                    <h5>Free Parking</h5>
                                    <p class="text-muted">Complimentary valet parking service</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-content">
                            <div class="flex gap-4">
                                <i class="bi bi-bicycle" style="font-size: 2rem; color: hsl(var(--ocean-blue));"></i>
                                <div>
                                    <h5>Fitness Center</h5>
                                    <p class="text-muted">State-of-the-art gym equipment</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-content">
                            <div class="flex gap-4">
                                <i class="bi bi-cup-straw" style="font-size: 2rem; color: hsl(var(--ocean-blue));"></i>
                                <div>
                                    <h5>Pool Bar</h5>
                                    <p class="text-muted">Refreshments served poolside</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Contact Section -->
        <section class="section" id="contact" style="background-color: hsl(var(--muted));">
            <div class="container container-sm">
                <div class="section-title">
                    <h2>Get In Touch</h2>
                    <p class="text-muted">We'd love to hear from you</p>
                </div>
                <div class="card">
                    <div class="card-content">
                        <form>
                            <div class="form-group">
                                <label class="form-label">Name</label>
                                <input type="text" class="form-input" placeholder="Your name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-input" placeholder="your@email.com">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Message</label>
                                <textarea class="form-textarea" placeholder="Your message"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary w-full">Send Message</button>
                        </form>
                    </div>
                </div>
                <div class="mt-4 text-center">
                    <p class="text-muted">
                        <i class="bi bi-geo-alt"></i> 123 Ocean Drive, Paradise Island<br>
                        <i class="bi bi-telephone"></i> +1 (555) 123-4567<br>
                        <i class="bi bi-envelope"></i> info@oceanviewresort.com
                    </p>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-section">
                        <h3>Ocean View Resort</h3>
                        <p>Your gateway to paradise. Experience luxury, comfort, and breathtaking ocean views.</p>
                    </div>
                    <div class="footer-section">
                        <h3>Quick Links</h3>
                        <ul>
                            <li><a href="#home">Home</a></li>
                            <li><a href="#rooms">Rooms</a></li>
                            <li><a href="#amenities">Amenities</a></li>
                            <li><a href="#contact">Contact</a></li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h3>Legal</h3>
                        <ul>
                            <li><a href="#">Privacy Policy</a></li>
                            <li><a href="#">Terms of Service</a></li>
                            <li><a href="#">Cancellation Policy</a></li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h3>Connect With Us</h3>
                        <div class="flex gap-2 mt-2">
                            <a href="#" class="btn btn-ghost"><i class="bi bi-facebook"></i></a>
                            <a href="#" class="btn btn-ghost"><i class="bi bi-instagram"></i></a>
                            <a href="#" class="btn btn-ghost"><i class="bi bi-twitter"></i></a>
                        </div>
                    </div>
                </div>
                <div class="footer-bottom">
                    <p>&copy; 2026 Ocean View Resort. All rights reserved.</p>
                </div>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Smooth scrolling for anchor links
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }
                });
            });
        </script>
    </body>

    </html>