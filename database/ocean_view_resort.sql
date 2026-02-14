-- Ocean View Resort Database Schema
-- Created: February 14, 2026

-- Create Database
CREATE DATABASE IF NOT EXISTS ocean_view_resort;
USE ocean_view_resort;

-- Disable foreign key checks for clean import
SET FOREIGN_KEY_CHECKS=0;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS users;

-- Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role ENUM('admin', 'manager', 'receptionist', 'customer') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Rooms Table
CREATE TABLE rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(20) UNIQUE NOT NULL,
    room_type ENUM('standard', 'deluxe', 'suite', 'ocean_view') NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    capacity INT NOT NULL,
    description TEXT,
    amenities TEXT,
    image_url VARCHAR(500),
    status ENUM('available', 'occupied', 'maintenance') DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_room_type (room_type),
    INDEX idx_status (status),
    INDEX idx_price (price_per_night)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bookings Table
CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_guests INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_room_id (room_id),
    INDEX idx_status (status),
    INDEX idx_dates (check_in_date, check_out_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert Admin User (password: admin123)
INSERT INTO users (username, password, email, full_name, phone, role) VALUES
('admin', '$2a$10$biSX742it6VNLlHwwD65n.ofyS2iBIh2dbgW5ddaIyNWidqJO.2Ba', 'admin@oceanviewresort.com', 'Administrator', '+1-555-0000', 'admin');

-- Insert Manager User (password: manager123)
INSERT INTO users (username, password, email, full_name, phone, role) VALUES
('manager', '$2a$10$ciS5sYeBRrlTZThe1Zm9eeGXU2RXWLjf8QOIGCHfNsEor5NgSZeUS', 'manager@oceanviewresort.com', 'Hotel Manager', '+1-555-2000', 'manager');

-- Insert Receptionist User (password: reception123)
INSERT INTO users (username, password, email, full_name, phone, role) VALUES
('receptionist', '$2a$10$7g79hCMKpqV0fKGLQ9antuLK9CljXKsEuhzEWiSIL041Gswf3G5v2', 'reception@oceanviewresort.com', 'Front Desk Receptionist', '+1-555-3000', 'receptionist');

-- Insert Sample Customer (password: customer123)
INSERT INTO users (username, password, email, full_name, phone, role) VALUES
('john_doe', '$2a$10$/MaxQc7PWhknGqQT6SDlIuyn8y2sXuOvrr5uV4rSw2z78wDdp1lWK', 'john@example.com', 'John Doe', '+1-555-1234', 'customer'),
('jane_smith', '$2a$10$/MaxQc7PWhknGqQT6SDlIuyn8y2sXuOvrr5uV4rSw2z78wDdp1lWK', 'jane@example.com', 'Jane Smith', '+1-555-5678', 'customer');

-- Insert Sample Rooms
INSERT INTO rooms (room_number, room_type, price_per_night, capacity, description, amenities, image_url, status) VALUES
-- Standard Rooms
('101', 'standard', 15000.00, 2, 'Comfortable standard room with modern amenities and city view', 'WiFi, TV, Air Conditioning, Mini Bar, Coffee Maker', 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800', 'available'),
('102', 'standard', 15000.00, 2, 'Cozy standard room perfect for couples', 'WiFi, TV, Air Conditioning, Mini Bar, Coffee Maker', 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800', 'available'),
('103', 'standard', 150.00, 2, 'Standard room with comfortable bedding', 'WiFi, TV, Air Conditioning, Mini Bar, Coffee Maker', 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800', 'available'),
('104', 'standard', 150.00, 2, 'Well-appointed standard room', 'WiFi, TV, Air Conditioning, Mini Bar, Coffee Maker', 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800', 'available'),
('105', 'standard', 150.00, 2, 'Standard room with garden view', 'WiFi, TV, Air Conditioning, Mini Bar, Coffee Maker', 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800', 'available'),

-- Deluxe Rooms
('201', 'deluxe', 25000.00, 3, 'Spacious deluxe room with premium furnishings and enhanced amenities', 'WiFi, Smart TV, Air Conditioning, Premium Mini Bar, Nespresso Machine, Bathrobe, Safe', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800', 'available'),
('202', 'deluxe', 25000.00, 3, 'Elegant deluxe room with sitting area', 'WiFi, Smart TV, Air Conditioning, Premium Mini Bar, Nespresso Machine, Bathrobe, Safe', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800', 'available'),
('203', 'deluxe', 25000.00, 3, 'Luxury deluxe room with modern design', 'WiFi, Smart TV, Air Conditioning, Premium Mini Bar, Nespresso Machine, Bathrobe, Safe', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800', 'available'),
('204', 'deluxe', 25000.00, 3, 'Premium deluxe room with work desk', 'WiFi, Smart TV, Air Conditioning, Premium Mini Bar, Nespresso Machine, Bathrobe, Safe', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800', 'available'),
('205', 'deluxe', 25000.00, 3, 'Deluxe room with balcony', 'WiFi, Smart TV, Air Conditioning, Premium Mini Bar, Nespresso Machine, Bathrobe, Safe', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800', 'available'),

-- Suites
('301', 'suite', 35000.00, 4, 'Luxurious suite with separate living area and bedroom', 'WiFi, 2 Smart TVs, Air Conditioning, Full Mini Bar, Nespresso Machine, Bathrobe, Safe, Whirlpool Tub', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800', 'available'),
('302', 'suite', 35000.00, 4, 'Executive suite with premium amenities', 'WiFi, 2 Smart TVs, Air Conditioning, Full Mini Bar, Nespresso Machine, Bathrobe, Safe, Whirlpool Tub', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800', 'available'),
('303', 'suite', 35000.00, 4, 'Grand suite with dining area', 'WiFi, 2 Smart TVs, Air Conditioning, Full Mini Bar, Nespresso Machine, Bathrobe, Safe, Whirlpool Tub', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800', 'available'),

-- Ocean View Rooms
('401', 'ocean_view', 45000.00, 2, 'Breathtaking ocean views from your private balcony suite', 'WiFi, Smart TV, Air Conditioning, Premium Mini Bar, Nespresso Machine, Bathrobe, Safe, Ocean View Balcony, Telescope', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800', 'available'),
('402', 'ocean_view', 45000.00, 2, 'Stunning ocean view room with sunset views', 'WiFi, Smart TV, Air Conditioning, Premium Mini Bar, Nespresso Machine, Bathrobe, Safe, Ocean View Balcony, Telescope', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800', 'available'),
('403', 'ocean_view', 45000.00, 2, 'Premium ocean view with panoramic windows', 'WiFi, Smart TV, Air Conditioning, Premium Mini Bar, Nespresso Machine, Bathrobe, Safe, Ocean View Balcony, Telescope', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800', 'available'),
('404', 'ocean_view', 45000.00, 2, 'Romantic ocean view room for couples', 'WiFi, Smart TV, Air Conditioning, Premium Mini Bar, Nespresso Machine, Bathrobe, Safe, Ocean View Balcony, Telescope', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800', 'available'),
('405', 'ocean_view', 450.00, 2, 'Corner ocean view with dual balconies', 'WiFi, Smart TV, Air Conditioning, Premium Mini Bar, Nespresso Machine, Bathrobe, Safe, Ocean View Balcony, Telescope', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800', 'available');

-- Insert Sample Bookings
INSERT INTO bookings (user_id, room_id, check_in_date, check_out_date, number_of_guests, total_amount, status, special_requests) VALUES
(2, 1, '2026-02-20', '2026-02-25', 2, 75000.00, 'confirmed', 'Late check-in preferred'),
(2, 6, '2026-03-01', '2026-03-05', 2, 100000.00, 'pending', 'Higher floor preferred'),
(3, 14, '2026-02-18', '2026-02-22', 2, 180000.00, 'confirmed', 'Anniversary celebration, please arrange flowers');

-- Create Views for Analytics
CREATE OR REPLACE VIEW booking_summary AS
SELECT 
    b.id,
    u.full_name AS customer_name,
    u.email AS customer_email,
    r.room_number,
    r.room_type,
    b.check_in_date,
    b.check_out_date,
    DATEDIFF(b.check_out_date, b.check_in_date) AS nights,
    b.number_of_guests,
    b.total_amount,
    b.status,
    b.created_at AS booking_date
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN rooms r ON b.room_id = r.id;

CREATE OR REPLACE VIEW room_availability AS
SELECT 
    r.id,
    r.room_number,
    r.room_type,
    r.price_per_night,
    r.capacity,
    r.status,
    COUNT(CASE WHEN b.status IN ('pending', 'confirmed') 
          AND b.check_out_date >= CURDATE() THEN 1 END) AS upcoming_bookings
FROM rooms r
LEFT JOIN bookings b ON r.id = b.room_id
GROUP BY r.id, r.room_number, r.room_type, r.price_per_night, r.capacity, r.status;

CREATE OR REPLACE VIEW revenue_summary AS
SELECT 
    DATE_FORMAT(created_at, '%Y-%m') AS month,
    COUNT(*) AS total_bookings,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS average_booking_value
FROM bookings
WHERE status IN ('confirmed', 'completed')
GROUP BY DATE_FORMAT(created_at, '%Y-%m')
ORDER BY month DESC;

-- Create Stored Procedures
DELIMITER //

-- Procedure to check room availability
CREATE PROCEDURE check_room_availability(
    IN p_room_id INT,
    IN p_check_in DATE,
    IN p_check_out DATE,
    OUT p_is_available BOOLEAN
)
BEGIN
    DECLARE conflict_count INT;
    
    SELECT COUNT(*) INTO conflict_count
    FROM bookings
    WHERE room_id = p_room_id
    AND status IN ('pending', 'confirmed')
    AND (
        (check_in_date BETWEEN p_check_in AND p_check_out)
        OR (check_out_date BETWEEN p_check_in AND p_check_out)
        OR (check_in_date <= p_check_in AND check_out_date >= p_check_out)
    );
    
    SET p_is_available = (conflict_count = 0);
END //

-- Procedure to get available rooms
CREATE PROCEDURE get_available_rooms(
    IN p_check_in DATE,
    IN p_check_out DATE,
    IN p_room_type VARCHAR(20)
)
BEGIN
    SELECT r.*
    FROM rooms r
    WHERE r.status = 'available'
    AND (p_room_type IS NULL OR r.room_type = p_room_type)
    AND r.id NOT IN (
        SELECT room_id
        FROM bookings
        WHERE status IN ('pending', 'confirmed')
        AND (
            (check_in_date BETWEEN p_check_in AND p_check_out)
            OR (check_out_date BETWEEN p_check_in AND p_check_out)
            OR (check_in_date <= p_check_in AND check_out_date >= p_check_out)
        )
    )
    ORDER BY r.price_per_night;
END //

-- Procedure to get booking statistics
CREATE PROCEDURE get_booking_statistics()
BEGIN
    SELECT 
        'Total Bookings' AS metric,
        COUNT(*) AS value
    FROM bookings
    
    UNION ALL
    
    SELECT 
        'Confirmed Bookings',
        COUNT(*)
    FROM bookings
    WHERE status = 'confirmed'
    
    UNION ALL
    
    SELECT 
        'Pending Bookings',
        COUNT(*)
    FROM bookings
    WHERE status = 'pending'
    
    UNION ALL
    
    SELECT 
        'Total Revenue',
        SUM(total_amount)
    FROM bookings
    WHERE status IN ('confirmed', 'completed')
    
    UNION ALL
    
    SELECT 
        'Available Rooms',
        COUNT(*)
    FROM rooms
    WHERE status = 'available';
END //

DELIMITER ;

-- Create Triggers
DELIMITER //

-- Trigger to update room status when booking is confirmed
CREATE TRIGGER after_booking_confirm
AFTER UPDATE ON bookings
FOR EACH ROW
BEGIN
    IF NEW.status = 'confirmed' AND OLD.status = 'pending' THEN
        IF NEW.check_in_date = CURDATE() THEN
            UPDATE rooms SET status = 'occupied' WHERE id = NEW.room_id;
        END IF;
    END IF;
    
    IF NEW.status = 'cancelled' AND OLD.status IN ('pending', 'confirmed') THEN
        UPDATE rooms SET status = 'available' WHERE id = NEW.room_id;
    END IF;
END //

DELIMITER ;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS=1;

-- Display success message
SELECT 'Database created successfully!' AS status,
       'ocean_view_resort' AS database_name,
       (SELECT COUNT(*) FROM users) AS total_users,
       (SELECT COUNT(*) FROM rooms) AS total_rooms,
       (SELECT COUNT(*) FROM bookings) AS total_bookings;
