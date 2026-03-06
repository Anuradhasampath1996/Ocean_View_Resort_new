package com.example.oceanviewresortnew.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.sql.Date;

import static org.junit.jupiter.api.Assertions.*;

/**
 * JUnit 5 tests for the {@link Booking} model.
 * Verifies constructors, getters/setters, and valid status transitions.
 */
public class BookingModelTest {

    private Booking booking;

    @BeforeEach
    public void setUp() {
        booking = new Booking(
                1,
                10,
                5,
                Date.valueOf("2026-04-01"),
                Date.valueOf("2026-04-04"),
                2,
                new BigDecimal("15000.00"),
                "pending");
    }

    // ─── Constructor & getters ───────────────────────────────────────

    @Test
    @DisplayName("Full constructor should populate all fields correctly")
    public void testConstructorAndGetters() {
        assertEquals(1, booking.getId());
        assertEquals(10, booking.getUserId());
        assertEquals(5, booking.getRoomId());
        assertEquals(Date.valueOf("2026-04-01"), booking.getCheckInDate());
        assertEquals(Date.valueOf("2026-04-04"), booking.getCheckOutDate());
        assertEquals(2, booking.getNumberOfGuests());
        assertEquals(new BigDecimal("15000.00"), booking.getTotalAmount());
        assertEquals("pending", booking.getStatus());
    }

    @Test
    @DisplayName("Default constructor should produce a booking with zero id")
    public void testDefaultConstructor() {
        Booking empty = new Booking();
        assertEquals(0, empty.getId());
        assertNull(empty.getStatus());
        assertNull(empty.getTotalAmount());
    }

    // ─── Setters ─────────────────────────────────────────────────────

    @Test
    @DisplayName("setStatus should update the booking status")
    public void testSetStatus() {
        booking.setStatus("confirmed");
        assertEquals("confirmed", booking.getStatus());
    }

    @Test
    @DisplayName("setTotalAmount should update the total amount")
    public void testSetTotalAmount() {
        booking.setTotalAmount(new BigDecimal("20000.00"));
        assertEquals(new BigDecimal("20000.00"), booking.getTotalAmount());
    }

    @Test
    @DisplayName("setNumberOfGuests should update guest count")
    public void testSetNumberOfGuests() {
        booking.setNumberOfGuests(4);
        assertEquals(4, booking.getNumberOfGuests());
    }

    @Test
    @DisplayName("setSpecialRequests should store special request text")
    public void testSetSpecialRequests() {
        booking.setSpecialRequests("Sea-view room preferred");
        assertEquals("Sea-view room preferred", booking.getSpecialRequests());
    }

    // ─── Valid status values ─────────────────────────────────────────

    @Test
    @DisplayName("Booking status 'pending' should be accepted")
    public void testStatusPending() {
        booking.setStatus("pending");
        assertEquals("pending", booking.getStatus());
    }

    @Test
    @DisplayName("Booking status 'confirmed' should be accepted")
    public void testStatusConfirmed() {
        booking.setStatus("confirmed");
        assertEquals("confirmed", booking.getStatus());
    }

    @Test
    @DisplayName("Booking status 'cancelled' should be accepted")
    public void testStatusCancelled() {
        booking.setStatus("cancelled");
        assertEquals("cancelled", booking.getStatus());
    }

    @Test
    @DisplayName("Booking status 'completed' should be accepted")
    public void testStatusCompleted() {
        booking.setStatus("completed");
        assertEquals("completed", booking.getStatus());
    }

    // ─── Date handling ───────────────────────────────────────────────

    @Test
    @DisplayName("Check-out date should be after check-in date")
    public void testCheckOutAfterCheckIn() {
        assertTrue(
                booking.getCheckOutDate().after(booking.getCheckInDate()),
                "Check-out date must be after check-in date");
    }

    @Test
    @DisplayName("Setting same check-in and check-out dates is allowed by the model")
    public void testSameDayDates() {
        Date same = Date.valueOf("2026-06-15");
        booking.setCheckInDate(same);
        booking.setCheckOutDate(same);
        assertEquals(booking.getCheckInDate(), booking.getCheckOutDate());
    }
}
