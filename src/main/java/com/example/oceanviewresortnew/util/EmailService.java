package com.example.oceanviewresortnew.util;

import com.example.oceanviewresortnew.model.Booking;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

/**
 * Email utility for sending booking-related emails via Gmail SMTP.
 * <p>
 * IMPORTANT: You must use a Gmail App Password (not your regular password).
 * To generate one: Google Account > Security > 2-Step Verification > App
 * passwords.
 * </p>
 */
public class EmailService {

    // ── SMTP Configuration ─────────────────────────────────────────
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;
    private static final String SENDER_EMAIL = "anuradhasampath64@gmail.com";
    private static final String SENDER_PASSWORD = "YOUR_APP_PASSWORD_HERE"; // Replace with Gmail App Password

    private EmailService() {
    }

    /**
     * Sends a booking confirmation email to the customer.
     *
     * @param recipientEmail customer email address
     * @param booking        the confirmed booking (must include joined fields)
     */
    public static void sendBookingConfirmation(String recipientEmail, Booking booking) {
        if (recipientEmail == null || recipientEmail.isBlank()) {
            System.err.println("[EmailService] Cannot send email: recipient is blank.");
            return;
        }

        new Thread(() -> {
            try {
                Properties props = new Properties();
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                props.put("mail.smtp.host", SMTP_HOST);
                props.put("mail.smtp.port", String.valueOf(SMTP_PORT));

                Session session = Session.getInstance(props, new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
                    }
                });

                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(SENDER_EMAIL, "Ocean View Resort"));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
                message.setSubject("Booking Confirmed - Ocean View Resort (#" + booking.getId() + ")");
                message.setContent(buildConfirmationHtml(booking), "text/html; charset=UTF-8");

                Transport.send(message);
                System.out.println("[EmailService] Confirmation email sent to " + recipientEmail);

            } catch (Exception e) {
                System.err.println("[EmailService] Failed to send email to " + recipientEmail);
                e.printStackTrace();
            }
        }).start();
    }

    private static String buildConfirmationHtml(Booking booking) {
        String customerName = safe(booking.getUserName());
        String roomNumber = safe(booking.getRoomNumber());
        String roomType = safe(booking.getRoomType());
        String checkIn = String.valueOf(booking.getCheckInDate());
        String checkOut = String.valueOf(booking.getCheckOutDate());
        String guests = String.valueOf(booking.getNumberOfGuests());
        String amount = "LKR " + booking.getTotalAmount();
        String specialRequests = safe(booking.getSpecialRequests());

        return """
                <!DOCTYPE html>
                <html>
                <head>
                <meta charset="UTF-8">
                <style>
                  body { font-family: Arial, Helvetica, sans-serif; background: #f4f8fb; margin: 0; padding: 0; }
                  .wrap { max-width: 600px; margin: 24px auto; background: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
                  .header { background: #1298c7; padding: 28px 24px; text-align: center; }
                  .header h1 { color: #ffffff; margin: 0; font-size: 24px; }
                  .header p  { color: #ffb01a; margin: 4px 0 0; font-size: 14px; font-weight: bold; }
                  .body { padding: 24px; color: #333333; }
                  .body h2 { color: #1298c7; font-size: 18px; margin-top: 0; }
                  .badge { display: inline-block; background: #28a745; color: #fff; padding: 4px 14px; border-radius: 20px; font-size: 13px; font-weight: bold; }
                  table { width: 100%%; border-collapse: collapse; margin-top: 16px; }
                  th, td { text-align: left; padding: 10px 14px; border-bottom: 1px solid #e5e7eb; }
                  th { background: #f0f8ff; color: #1298c7; width: 38%%; font-size: 13px; }
                  td { color: #374151; font-size: 14px; }
                  .total td { font-size: 18px; font-weight: bold; color: #ffb01a; }
                  .total th { font-size: 14px; font-weight: bold; color: #1298c7; }
                  .footer { background: #f9fafb; text-align: center; padding: 18px; font-size: 12px; color: #9ca3af; }
                  .footer a { color: #1298c7; text-decoration: none; }
                </style>
                </head>
                <body>
                <div class="wrap">
                  <div class="header">
                    <h1>Ocean View Resort</h1>
                    <p>BOOKING CONFIRMATION</p>
                  </div>
                  <div class="body">
                    <h2>Hello %s,</h2>
                    <p>Great news! Your booking has been <span class="badge">Confirmed</span>.</p>
                    <p>Here are your booking details:</p>
                    <table>
                      <tr><th>Booking ID</th><td>#%d</td></tr>
                      <tr><th>Room</th><td>%s (%s)</td></tr>
                      <tr><th>Check-in</th><td>%s</td></tr>
                      <tr><th>Check-out</th><td>%s</td></tr>
                      <tr><th>Guests</th><td>%s</td></tr>
                      <tr><th>Special Requests</th><td>%s</td></tr>
                      <tr class="total"><th>Total Amount</th><td>%s</td></tr>
                    </table>
                    <p style="margin-top:20px;">If you have any questions, please don't hesitate to contact us.</p>
                    <p>We look forward to welcoming you!</p>
                  </div>
                  <div class="footer">
                    <p>Ocean View Resort &middot; info@oceanviewresort.lk &middot; +94 11 234 5678</p>
                    <p>This is an automated email. Please do not reply directly.</p>
                  </div>
                </div>
                </body>
                </html>
                """
                .formatted(
                        customerName,
                        booking.getId(),
                        roomNumber, roomType,
                        checkIn, checkOut,
                        guests,
                        specialRequests,
                        amount);
    }

    private static String safe(String value) {
        if (value == null || value.isBlank())
            return "-";
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
