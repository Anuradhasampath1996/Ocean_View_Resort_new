package com.example.oceanviewresortnew.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

/**
 * JUnit 5 test class for {@link PricingUtil}.
 * Covers normal stays, same-day checkout, multi-week stays,
 * invalid date ordering, and null/blank input guards.
 */
public class PricingUtilTest {

    // ─── calculateTotalPrice(String, String, double) ────────────────

    /**
     * Test a) Normal 3-night stay.
     * Check-in: 2025-01-01, Check-out: 2025-01-04 → 3 nights × Rs.5000 = Rs.15000
     */
    @Test
    @DisplayName("Normal 3-night stay at Rs.5000/night should total Rs.15000")
    public void testNormalStay() {
        double result = PricingUtil.calculateTotalPrice("2025-01-01", "2025-01-04", 5000.0);
        assertEquals(15000.0, result, "3-night stay at Rs.5000/night should total Rs.15000");
    }

    /**
     * Test b) Same-day checkout (0 nights) should default to 1-night minimum
     * charge.
     * Check-in: 2025-06-10, Check-out: 2025-06-10 → defaults to 1 night × Rs.8000 =
     * Rs.8000
     */
    @Test
    @DisplayName("Same-day checkout should default to 1-night minimum charge")
    public void testSameDayCheckout() {
        double result = PricingUtil.calculateTotalPrice("2025-06-10", "2025-06-10", 8000.0);
        assertEquals(8000.0, result, "Same-day checkout should default to 1 night (minimum charge)");
    }

    /**
     * Test c) Checkout before check-in should throw IllegalArgumentException.
     */
    @Test
    @DisplayName("Checkout before check-in should throw IllegalArgumentException")
    public void testInvalidDates() {
        assertThrows(IllegalArgumentException.class,
                () -> PricingUtil.calculateTotalPrice("2025-03-10", "2025-03-05", 6000.0),
                "Checkout before check-in should throw IllegalArgumentException");
    }

    /**
     * Test d) Single-night stay.
     * Rs.12000/night × 1 night = Rs.12000
     */
    @Test
    @DisplayName("1-night stay should return the nightly rate as total")
    public void testOneNightStay() {
        double result = PricingUtil.calculateTotalPrice("2025-12-24", "2025-12-25", 12000.0);
        assertEquals(12000.0, result, "1-night stay should equal the nightly rate");
    }

    /**
     * Test e) Long 7-night stay.
     * Rs.9500/night × 7 nights = Rs.66500
     */
    @Test
    @DisplayName("7-night stay at Rs.9500/night should total Rs.66500")
    public void testWeekLongStay() {
        double result = PricingUtil.calculateTotalPrice("2026-01-01", "2026-01-08", 9500.0);
        assertEquals(66500.0, result, "7-night stay at Rs.9500/night should total Rs.66500");
    }

    // ─── calculateTotalPrice(String, String, BigDecimal) ────────────

    /**
     * Test f) BigDecimal overload — ensures no precision loss.
     * Rs.3333.33/night × 3 nights = Rs.9999.99
     */
    @Test
    @DisplayName("BigDecimal overload should preserve precision")
    public void testBigDecimalPrecision() {
        BigDecimal price = new BigDecimal("3333.33");
        BigDecimal expected = new BigDecimal("9999.99");
        BigDecimal result = PricingUtil.calculateTotalPrice("2025-05-01", "2025-05-04", price);
        assertEquals(expected, result, "BigDecimal calculation should not lose precision");
    }

    // ─── calculateNights ────────────────────────────────────────────

    /**
     * Test g) calculateNights for a normal 5-night stay.
     */
    @Test
    @DisplayName("calculateNights should return 5 for a 5-night window")
    public void testCalculateNights() {
        long nights = PricingUtil.calculateNights("2025-08-10", "2025-08-15");
        assertEquals(5L, nights, "2025-08-10 to 2025-08-15 should be 5 nights");
    }

    /**
     * Test h) calculateNights same-day should return 1 (minimum).
     */
    @Test
    @DisplayName("calculateNights same-day should return 1 (minimum charge)")
    public void testCalculateNightsSameDay() {
        long nights = PricingUtil.calculateNights("2025-08-10", "2025-08-10");
        assertEquals(1L, nights, "Same-day checkout should count as 1 chargeable night");
    }

    // ─── Input validation guards ─────────────────────────────────────

    /**
     * Test i) Null check-in date should throw.
     */
    @Test
    @DisplayName("Null check-in date should throw IllegalArgumentException")
    public void testNullCheckInDate() {
        assertThrows(IllegalArgumentException.class, () -> PricingUtil.calculateTotalPrice(null, "2025-03-10", 5000.0));
    }

    /**
     * Test j) Blank check-out date should throw.
     */
    @Test
    @DisplayName("Blank check-out date should throw IllegalArgumentException")
    public void testBlankCheckOutDate() {
        assertThrows(IllegalArgumentException.class, () -> PricingUtil.calculateTotalPrice("2025-03-10", "  ", 5000.0));
    }

    /**
     * Test k) Negative price should throw.
     */
    @Test
    @DisplayName("Negative price per night should throw IllegalArgumentException")
    public void testNegativePrice() {
        assertThrows(IllegalArgumentException.class, () -> PricingUtil.calculateTotalPrice("2025-03-10", "2025-03-15",
                new BigDecimal("-1000")));
    }

    /**
     * Test l) Zero price per night (free nights) should return zero total.
     */
    @Test
    @DisplayName("Zero price per night should return zero total")
    public void testZeroPricePerNight() {
        double result = PricingUtil.calculateTotalPrice("2025-03-10", "2025-03-13", 0.0);
        assertEquals(0.0, result, "Zero price per night should always total zero");
    }
}
