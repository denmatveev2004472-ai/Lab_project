from database import engine
from sqlalchemy import text

columns = {
    "internal_code": "TEXT",
    "name": "TEXT",
    "name_ru": "TEXT",
    "name_en": "TEXT",
    "formula": "TEXT",
    "cas": "TEXT",
    "manufacturer": "TEXT",
    "catalog_number": "TEXT",
    "inventory_number": "TEXT",
    "serial_number": "TEXT",
    "registry_number": "TEXT",
    "quantity": "TEXT",
    "unit": "TEXT",
    "status": "TEXT",
    "notes": "TEXT",
    "source_file": "TEXT",
    "source_sheet": "TEXT",
}

with engine.connect() as conn:
    for col, col_type in columns.items():
        conn.execute(text(f"ALTER TABLE items ADD COLUMN IF NOT EXISTS {col} {col_type};"))
    conn.commit()
    print("Все колонки проверены и добавлены при необходимости")