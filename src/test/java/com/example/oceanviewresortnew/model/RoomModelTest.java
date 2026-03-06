package com.example.oceanviewresortnew.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

/**
 * JUnit 5 tests for the {@link Room} model.
 * Verifies constructors, getters/setters, and valid status values.
 */
public class RoomModelTest {

    private Room room;

    @BeforeEach
    public void setUp() {
        room = new Room(
                1,
                "101",
                "ocean_view",
                new BigDecimal("12000.00"),
                2,
                "Beachfront ocean view room",
                "available");
    }

    // ─── Constructor & getters ────────────────────────────────────────

    @Test
    @DisplayName("Full constructor should populate all fields correctly")
    public void testConstructorAndGetters() {
        assertEquals(1, room.getId());
        assertEquals("101", room.getRoomNumber());
        assertEquals("ocean_view", room.getRoomType());
        assertEquals(new BigDecimal("12000.00"), room.getPricePerNight());
        assertEquals(2, room.getCapacity());
        assertEquals("Beachfront ocean view room", room.getDescription());
        assertEquals("available", room.getStatus());
    }

    @Test
    @DisplayName("Default constructor should produce a room with zero id and null fields")
    public void testDefaultConstructor() {
        Room empty = new Room();
        assertEquals(0, empty.getId());
        assertNull(empty.getRoomNumber());
        assertNull(empty.getStatus());
    }

    // ─── Setters ──────────────────────────────────────────────────────

    @Test
    @DisplayName("setPricePerNight should update the room price")
    public void testSetPricePerNight() {
        room.setPricePerNight(new BigDecimal("15000.00"));
        assertEquals(new BigDecimal("15000.00"), room.getPricePerNight());
    }

    @Test
    @DisplayName("setStatus should update room status")
    public void testSetStatus() {
        room.setStatus("occupied");
        assertEquals("occupied", room.getStatus());
    }

    @Test
    @DisplayName("setCapacity should update max guest count")
    public void testSetCapacity() {
        room.setCapacity(4);
        assertEquals(4, room.getCapacity());
    }

    @Test
    @DisplayName("setAmenities should store amenity text")
    public void testSetAmenities() {
        room.setAmenities("WiFi, Air Conditioning, Mini Bar");
        assertEquals("WiFi, Air Conditioning, Mini Bar", room.getAmenities());
    }

    @Test
    @DisplayName("setImageUrl should store image path")
    public void testSetImageUrl() {
        room.setImageUrl("/images/rooms/101.jpg");
        assertEquals("/images/rooms/101.jpg", room.getImageUrl());
    }

    // ─── Valid status values ──────────────────────────────────────────

    @Test
    @DisplayName("Room status 'available' should be accepted")
    public void testStatusAvailable() {
        room.setStatus("available");
        assertEquals("available", room.getStatus());
    }

    @Test
    @DisplayName("Room status 'occupied' should be accepted")
    public void testStatusOccupied() {
        room.setStatus("occupied");
        assertEquals("occupied", room.getStatus());
    }

    @Test
    @DisplayName("Room status 'maintenance' should be accepted")
    public void testStatusMaintenance() {
        room.setStatus("maintenance");
        assertEquals("maintenance", room.getStatus());
    }

    // ─── Room types ───────────────────────────────────────────────────

    @Test
    @DisplayName("Room type 'standard' should be stored correctly")
    public void testRoomTypeStandard() {
        room.setRoomType("standard");
        assertEquals("standard", room.getRoomType());
    }

    @Test
    @DisplayName("Room type 'deluxe' should be stored correctly")
    public void testRoomTypeDeluxe() {
        room.setRoomType("deluxe");
        assertEquals("deluxe", room.getRoomType());
    }

    @Test
    @DisplayName("Room type 'suite' should be stored correctly")
    public void testRoomTypeSuite() {
        room.setRoomType("suite");
        assertEquals("suite", room.getRoomType());
    }

    // ─── Price validation logic ───────────────────────────────────────

    @Test
    @DisplayName("Price per night should not be negative in a valid room")
    public void testPriceNotNegative() {
        assertTrue(
                room.getPricePerNight().compareTo(BigDecimal.ZERO) >= 0,
                "Price per night must be zero or positive");
    }

    @Test
    @DisplayName("Capacity should be at least 1 in a valid room")
    public void testCapacityPositive() {
        assertTrue(room.getCapacity() >= 1, "Room capacity must be at least 1");
    }
}
