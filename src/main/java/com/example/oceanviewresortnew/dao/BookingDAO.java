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
