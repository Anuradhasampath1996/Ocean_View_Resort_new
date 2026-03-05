package com.example.oceanviewresortnew.dao;

import com.example.oceanviewresortnew.model.Booking;
import com.example.oceanviewresortnew.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public boolean createBooking(Booking booking) {
        String query = "INSERT INTO bookings (user_id, room_id, check_in_date, check_out_date, number_of_guests, total_amount, status, special_requests) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getRoomId());
            stmt.setDate(3, booking.getCheckInDate());
            stmt.setDate(4, booking.getCheckOutDate());
            stmt.setInt(5, booking.getNumberOfGuests());
            stmt.setBigDecimal(6, booking.getTotalAmount());
            stmt.setString(7, booking.getStatus());
            stmt.setString(8, booking.getSpecialRequests());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int createBookingGetId(Booking booking) {
        String query = "INSERT INTO bookings (user_id, room_id, check_in_date, check_out_date, number_of_guests, total_amount, status, special_requests) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getRoomId());
            stmt.setDate(3, booking.getCheckInDate());
            stmt.setDate(4, booking.getCheckOutDate());
            stmt.setInt(5, booking.getNumberOfGuests());
            stmt.setBigDecimal(6, booking.getTotalAmount());
            stmt.setString(7, booking.getStatus());
            stmt.setString(8, booking.getSpecialRequests());
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet keys = stmt.getGeneratedKeys();
                if (keys.next())
                    return keys.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String query = "SELECT b.*, u.full_name as user_name, r.room_number, r.room_type " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN rooms r ON b.room_id = r.id " +
                "ORDER BY b.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> bookings = new ArrayList<>();
        String query = "SELECT b.*, u.full_name as user_name, r.room_number, r.room_type " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN rooms r ON b.room_id = r.id " +
                "WHERE b.user_id = ? " +
                "ORDER BY b.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public Booking getBookingById(int id) {
        String query = "SELECT b.*, u.full_name as user_name, r.room_number, r.room_type " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN rooms r ON b.room_id = r.id " +
                "WHERE b.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractBookingFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        String query = "UPDATE bookings SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, status);
            stmt.setInt(2, bookingId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteBooking(int bookingId) {
        String query = "DELETE FROM bookings WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, bookingId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isRoomAvailable(int roomId, Date checkIn, Date checkOut) {
        String query = "SELECT COUNT(*) FROM bookings " +
                "WHERE room_id = ? " +
                "AND status IN ('pending', 'confirmed') " +
                "AND ((check_in_date BETWEEN ? AND ?) " +
                "OR (check_out_date BETWEEN ? AND ?) " +
                "OR (check_in_date <= ? AND check_out_date >= ?))";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, roomId);
            stmt.setDate(2, checkIn);
            stmt.setDate(3, checkOut);
            stmt.setDate(4, checkIn);
            stmt.setDate(5, checkOut);
            stmt.setDate(6, checkIn);
            stmt.setDate(7, checkOut);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalBookingsCount() {
        String query = "SELECT COUNT(*) FROM bookings";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public java.math.BigDecimal getTotalRevenue() {
        String query = "SELECT COALESCE(SUM(total_amount),0) FROM bookings WHERE status IN ('confirmed','completed')";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next())
                return rs.getBigDecimal(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }

    public java.math.BigDecimal getMonthlyRevenue() {
        String query = "SELECT COALESCE(SUM(total_amount),0) FROM bookings WHERE status IN ('confirmed','completed') AND MONTH(created_at)=MONTH(CURDATE()) AND YEAR(created_at)=YEAR(CURDATE())";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next())
                return rs.getBigDecimal(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }

    public java.util.Map<String, Integer> getBookingCountsByStatus() {
        java.util.Map<String, Integer> map = new java.util.LinkedHashMap<>();
        map.put("pending", 0);
        map.put("confirmed", 0);
        map.put("completed", 0);
        map.put("cancelled", 0);
        String query = "SELECT status, COUNT(*) as cnt FROM bookings GROUP BY status";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next())
                map.put(rs.getString("status"), rs.getInt("cnt"));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    public java.util.Map<String, java.math.BigDecimal> getMonthlyRevenueChart() {
        java.util.Map<String, java.math.BigDecimal> map = new java.util.LinkedHashMap<>();
        String query = "SELECT DATE_FORMAT(created_at,'%b %Y') as month, COALESCE(SUM(total_amount),0) as rev " +
                "FROM bookings WHERE status IN ('confirmed','completed') AND created_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) "
                +
                "GROUP BY YEAR(created_at), MONTH(created_at) ORDER BY YEAR(created_at), MONTH(created_at)";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next())
                map.put(rs.getString("month"), rs.getBigDecimal("rev"));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    public java.util.Map<String, Integer> getBookingsByRoomType() {
        java.util.Map<String, Integer> map = new java.util.LinkedHashMap<>();
        String query = "SELECT r.room_type, COUNT(*) as cnt FROM bookings b JOIN rooms r ON b.room_id=r.id GROUP BY r.room_type ORDER BY cnt DESC";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next())
                map.put(rs.getString("room_type"), rs.getInt("cnt"));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    private Booking extractBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setId(rs.getInt("id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setRoomId(rs.getInt("room_id"));
        booking.setCheckInDate(rs.getDate("check_in_date"));
        booking.setCheckOutDate(rs.getDate("check_out_date"));
        booking.setNumberOfGuests(rs.getInt("number_of_guests"));
        booking.setTotalAmount(rs.getBigDecimal("total_amount"));
        booking.setStatus(rs.getString("status"));
        booking.setSpecialRequests(rs.getString("special_requests"));
        booking.setCreatedAt(rs.getTimestamp("created_at"));

        // Extract joined fields
        booking.setUserName(rs.getString("user_name"));
        booking.setRoomNumber(rs.getString("room_number"));
        booking.setRoomType(rs.getString("room_type"));

        return booking;
    }
}
