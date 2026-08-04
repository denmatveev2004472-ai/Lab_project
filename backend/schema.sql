CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE IF NOT EXISTS locations (
    id SERIAL PRIMARY KEY,
    room TEXT NOT NULL,
    cabinet TEXT DEFAULT '-',
    shelf TEXT DEFAULT '-',
    slot TEXT DEFAULT '-',
    UNIQUE (room, cabinet, shelf, slot)
);

CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    item_type TEXT NOT NULL DEFAULT 'other',
    internal_code TEXT,
    name TEXT,
    name_ru TEXT,
    name_en TEXT,
    formula TEXT,
    cas TEXT,
    manufacturer TEXT,
    catalog_number TEXT,
    inventory_number TEXT,
    serial_number TEXT,
    registry_number TEXT,
    quantity TEXT,
    unit TEXT,
    status TEXT,
    notes TEXT,
    source_file TEXT,
    source_sheet TEXT,
    location_id INTEGER REFERENCES locations(id) ON DELETE SET NULL,
    search_vector tsvector,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_items_location_id ON items(location_id);
CREATE INDEX IF NOT EXISTS idx_items_type ON items(item_type);
CREATE INDEX IF NOT EXISTS idx_items_search_vector ON items USING GIN(search_vector);
CREATE INDEX IF NOT EXISTS idx_items_inventory_number ON items(inventory_number);
CREATE INDEX IF NOT EXISTS idx_items_catalog_number ON items(catalog_number);
