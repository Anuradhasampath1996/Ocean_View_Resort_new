# Ocean View Resort - Database Setup Instructions

## Prerequisites

- XAMPP installed and running
- MySQL service started in XAMPP

## Setup Instructions

### Option 1: Using phpMyAdmin (Recommended for XAMPP)

1. Open your web browser and go to: `http://localhost/phpmyadmin`

2. Click on "Import" tab at the top

3. Click "Choose File" and select the SQL file:
   `database/ocean_view_resort.sql`

4. Scroll down and click "Go" button

5. Wait for the import to complete - you should see a success message

6. Click on "ocean_view_resort" database in the left sidebar to verify tables are created

### Option 2: Using MySQL Command Line

1. Open Command Prompt or PowerShell

2. Navigate to MySQL bin directory:

   ```
   cd "C:\xampp\mysql\bin"
   ```

3. Login to MySQL:

   ```
   mysql -u root -p
   ```

   (Press Enter if no password is set)

4. Run the SQL file:

   ```
   source "C:\Users\anura\Desktop\icbt assignments\Advanced Programming\project\Ocean-View-Resort_new\Ocean-View-Resort-new\database\ocean_view_resort.sql"
   ```

5. Exit MySQL:
   ```
   exit
   ```

## Default Login Credentials

### Admin Account

- Username: `admin`
- Password: `admin123`
- Email: `admin@oceanviewresort.com`

### Customer Accounts

- Username: `john_doe`
- Password: `customer123`
- Email: `john@example.com`

- Username: `jane_smith`
- Password: `customer123`
- Email: `jane@example.com`

## Database Structure

### Tables Created:

- `users` - Stores user accounts (admin and customers)
- `rooms` - Stores room information
- `bookings` - Stores booking records

### Sample Data:

- 3 users (1 admin, 2 customers)
- 18 rooms across 4 categories:
  - 5 Standard Rooms ($150/night)
  - 5 Deluxe Rooms ($250/night)
  - 3 Suites ($350/night)
  - 5 Ocean View Rooms ($450/night)
- 3 sample bookings

### Views Created:

- `booking_summary` - Complete booking information with customer and room details
- `room_availability` - Room availability status with upcoming bookings
- `revenue_summary` - Monthly revenue statistics

### Stored Procedures:

- `check_room_availability` - Check if a room is available for specific dates
- `get_available_rooms` - Get list of available rooms for date range
- `get_booking_statistics` - Get overall booking statistics

## Verification

After importing, verify by running this query in phpMyAdmin SQL tab:

```sql
USE ocean_view_resort;
SELECT 'Database Setup Complete!' AS message;
SHOW TABLES;
```

You should see 3 tables: `bookings`, `rooms`, `users`

## Troubleshooting

### Error: "Database already exists"

- Drop the existing database first:
  ```sql
  DROP DATABASE IF EXISTS ocean_view_resort;
  ```
- Then re-run the import

### Error: "Access denied"

- Check if MySQL is running in XAMPP
- Verify your MySQL root password (default is usually empty)
- Update connection settings in:
  `src/main/java/com/example/oceanviewresortnew/util/DatabaseConnection.java`

### Connection Issues from Java

- Make sure MySQL is running on port 3306 (default)
- Update DatabaseConnection.java if using different credentials:
  ```java
  private static final String USER = "root";
  private static final String PASSWORD = ""; // or your password
  ```

## Next Steps

After database setup:

1. Build the project: `mvn clean install`
2. Deploy to Tomcat server
3. Access the application at: `http://localhost:8080/Ocean-View-Resort-new-1.0-SNAPSHOT/`
