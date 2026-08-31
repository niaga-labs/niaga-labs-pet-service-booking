-- 005_create_booking_photos.sql
-- Proof-of-delivery photos. PhotoModel was only ever created by the development
-- AutoMigrate branch in cmd/server/main.go, so "booking_photos" did not exist in
-- any environment that runs the SQL migrations instead. See KPD-57.
--
-- The CHECK constraints mirror NewBookingPhoto in internal/domain/photo/photo.go:
-- a known photo type, and a non-empty URL.

CREATE TABLE IF NOT EXISTS booking_photos (
    id         UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID        NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    runner_id  UUID        NOT NULL,
    photo_type VARCHAR(20) NOT NULL CHECK (photo_type IN ('pickup', 'delivery')),
    photo_url  TEXT        NOT NULL CHECK (photo_url <> ''),
    caption    TEXT,
    taken_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_booking_photos_booking_id ON booking_photos(booking_id);
CREATE INDEX IF NOT EXISTS idx_booking_photos_booking_type ON booking_photos(booking_id, photo_type);
