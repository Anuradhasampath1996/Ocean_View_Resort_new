package com.example.oceanviewresortnew.util;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * Utility class for booking price calculations.
 * Extracts and centralises the pricing logic used across servlets.
 */
public class PricingUtil {

    private PricingUtil() {
    }

    /**
     * Calculates the total price for a stay.
     *
     * <ul>
     * <li>Same-day checkout (0 nights) is treated as a minimum 1-night charge.</li>
     * <li>A checkout date before the check-in date throws
     * {@link IllegalArgumentException}.</li>
     * </ul>
     *
     * @param checkInDate   check-in date in {@code "yyyy-MM-dd"} format
     * @param checkOutDate  check-out date in {@code "yyyy-MM-dd"} format
     * @param pricePerNight nightly room rate (must be &gt;= 0)
     * @return total amount for the stay
     * @throws IllegalArgumentException if dates are null/blank, cannot be parsed,
     *                                  checkout is before check-in, or price is
     *                                  negative
     */
    public static BigDecimal calculateTotalPrice(String checkInDate,
            String checkOutDate,
            BigDecimal pricePerNight) {
        if (checkInDate == null || checkInDate.isBlank()) {
            throw new IllegalArgumentException("Check-in date must not be blank");
        }
        if (checkOutDate == null || checkOutDate.isBlank()) {
            throw new IllegalArgumentException("Check-out date must not be blank");
        }
        if (pricePerNight == null || pricePerNight.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Price per night must be zero or positive");
        }

        LocalDate in = LocalDate.parse(checkInDate);
        LocalDate out = LocalDate.parse(checkOutDate);

        if (out.isBefore(in)) {
            throw new IllegalArgumentException(
                    "Check-out date (" + checkOutDate + ") cannot be before check-in date (" + checkInDate + ")");
        }

        long nights = ChronoUnit.DAYS.between(in, out);

        // Same-day checkout: apply minimum 1-night charge
        if (nights == 0) {
            nights = 1;
        }

        return pricePerNight.multiply(BigDecimal.valueOf(nights));
    }

    /**
     * Convenience overload that accepts primitive {@code double} prices and returns
     * a {@code double}.
     *
     * @param checkInDate   check-in date in {@code "yyyy-MM-dd"} format
     * @param checkOutDate  check-out date in {@code "yyyy-MM-dd"} format
     * @param pricePerNight nightly room rate
     * @return total amount as a {@code double}
     */
    public static double calculateTotalPrice(String checkInDate,
            String checkOutDate,
            double pricePerNight) {
        return calculateTotalPrice(checkInDate, checkOutDate,
                BigDecimal.valueOf(pricePerNight)).doubleValue();
    }

    /**
     * Returns the number of chargeable nights for a stay.
     * Same-day checkout returns 1 (minimum charge applies).
     *
     * @param checkInDate  check-in date in {@code "yyyy-MM-dd"} format
     * @param checkOutDate check-out date in {@code "yyyy-MM-dd"} format
     * @return number of nights (minimum 1)
     */
    public static long calculateNights(String checkInDate, String checkOutDate) {
        if (checkInDate == null || checkOutDate == null) {
            throw new IllegalArgumentException("Dates must not be null");
        }
        LocalDate in = LocalDate.parse(checkInDate);
        LocalDate out = LocalDate.parse(checkOutDate);
        if (out.isBefore(in)) {
            throw new IllegalArgumentException("Check-out cannot be before check-in");
        }
        long nights = ChronoUnit.DAYS.between(in, out);
        return nights == 0 ? 1 : nights;
    }
}
