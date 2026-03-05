package com.example.oceanviewresortnew.dao;

import com.example.oceanviewresortnew.model.RoomType;
import com.example.oceanviewresortnew.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeDAO {

    public List<RoomType> getAllRoomTypes() {
        List<RoomType> types = new ArrayList<>();
        String query = "SELECT * FROM room_types ORDER BY display_name";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                types.add(extract(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return types;
    }

    public RoomType getRoomTypeById(int id) {
        String query = "SELECT * FROM room_types WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return extract(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addRoomType(RoomType roomType) {
        String query = "INSERT INTO room_types (name, display_name) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, roomType.getName());
            stmt.setString(2, roomType.getDisplayName());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateRoomType(RoomType roomType) {
        String query = "UPDATE room_types SET name = ?, display_name = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, roomType.getName());
            stmt.setString(2, roomType.getDisplayName());
            stmt.setInt(3, roomType.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteRoomType(int id) {
        String query = "DELETE FROM room_types WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private RoomType extract(ResultSet rs) throws SQLException {
        return new RoomType(rs.getInt("id"), rs.getString("name"), rs.getString("display_name"));
    }
}
