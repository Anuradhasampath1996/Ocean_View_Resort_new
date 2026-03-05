-- ============================================================
-- Migration: Dynamic Room Types + Image Upload Support
-- Run this script ONCE against your ocean_view_resort database
-- ============================================================

USE ocean_view_resort;

-- 1. Create room_types table
CREATE TABLE IF NOT EXISTS room_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,        -- internal key, e.g. "ocean_view"
    display_name VARCHAR(100) NOT NULL,       -- shown in UI, e.g. "Ocean View"
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Seed with the four original types
INSERT IGNORE INTO room_types (name, display_name) VALUES
  ('standard',   'Standard'),
  ('deluxe',     'Deluxe'),
  ('suite',      'Suite'),
  ('ocean_view', 'Ocean View');

-- 3. Change rooms.room_type from ENUM to VARCHAR so it accepts any type
ALTER TABLE rooms MODIFY COLUMN room_type VARCHAR(100) NOT NULL;
