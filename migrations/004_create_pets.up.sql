-- 004_create_pets.sql
-- Owner pet profiles. PetModel was only ever created by the development
-- AutoMigrate branch in cmd/server/main.go, so "pets" did not exist in any
-- environment that runs the SQL migrations instead. See KPD-57.
--
-- This table is the foundation of epic KPD-7 (MVP-GAP-01 Owner pet profiles),
-- so it has to exist outside a developer laptop before KPD-8 starts.
--
-- owner_id references a user owned by service-identity, in a different
-- database, so it deliberately carries no foreign key.

CREATE TABLE IF NOT EXISTS pets (
    id                 UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id           UUID          NOT NULL,
    name               VARCHAR(100)  NOT NULL CHECK (name <> ''),
    pet_type           VARCHAR(20)   NOT NULL CHECK (pet_type <> ''),
    breed              VARCHAR(100),
    weight_kg          DECIMAL(5,2),
    age_months         INT,
    allergies          TEXT,
    special_needs      TEXT,
    notes              TEXT,
    photo_url          TEXT,
    vaccination_status VARCHAR(50),
    status             VARCHAR(20)   NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'archived')),
    version            BIGINT        NOT NULL DEFAULT 1,
    created_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- Owners list their own pets; the list view hides archived ones.
CREATE INDEX IF NOT EXISTS idx_pets_owner_id ON pets(owner_id);
CREATE INDEX IF NOT EXISTS idx_pets_owner_active ON pets(owner_id) WHERE status = 'active';
