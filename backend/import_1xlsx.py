
import re
import psycopg
import psycopg.rows
import openpyxl
import os
from dotenv import load_dotenv

load_dotenv()

XLSX_PATH = "1.xlsx"  # положи файл рядом со скриптом в C:\lab-app\backend\

def get_conn():
    return psycopg.connect(
        host=os.environ.get("PGHOST", "localhost"),
        port=int(os.environ.get("PGPORT", 5432)),
        dbname=os.environ.get("PGDATABASE", "lab_chemicals"),
        user=os.environ.get("PGUSER", "postgres"),
        password=os.environ.get("PGPASSWORD", ""),
        row_factory=psycopg.rows.dict_row,
    )

SECTION_MARKERS = {
    "оборудование": "equipment",
    "мебель": "furniture",
    "расходный пластик": "consumable",
    "расходник клетки": "consumable",
    "расходник клеточные": "consumable",
}

ROOM_RE = re.compile(r"(?:каб\.?|ком\.?)\s*(\d{3})", re.IGNORECASE)
ROOM_ONLY_RE = re.compile(r"^\s*(\d{3})\s*$")

def detect_room(text):
    if not text:
        return None
    m = ROOM_RE.search(str(text))
    if m:
        return m.group(1)
    m2 = ROOM_ONLY_RE.match(str(text))
    if m2:
        return m2.group(1)
    return None

def get_or_create_location(conn, cache, room, cabinet="-", shelf="-", slot="-"):
    if not room:
        room = "не указано"
    key = (room, cabinet, shelf, slot)
    if key in cache:
        return cache[key]
    row = conn.execute(
        "SELECT id FROM locations WHERE room=%s AND cabinet=%s AND shelf=%s AND slot=%s",
        (room, cabinet, shelf, slot)
    ).fetchone()
    if row:
        cache[key] = row["id"]
        return row["id"]
    row = conn.execute(
        "INSERT INTO locations (room, cabinet, shelf, slot) VALUES (%s,%s,%s,%s) RETURNING id",
        (room, cabinet, shelf, slot)
    ).fetchone()
    conn.commit()
    cache[key] = row["id"]
    return row["id"]

def insert_item(conn, item_type, code, name, formula, cas, manufacturer, catalog_number, notes, location_id):
    if not name:
        return
    conn.execute("""
        INSERT INTO items (item_type, code, name, formula, cas, manufacturer, catalog_number, notes, location_id)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """, (item_type, code, name, formula, cas, manufacturer, catalog_number, notes, location_id))

def main():
    wb = openpyxl.load_workbook(XLSX_PATH, data_only=True)
    conn = get_conn()
    loc_cache = {}
    total = 0

    for sheet in wb.worksheets:
        current_type = "reagent"
        current_room_default = None

        for row in sheet.iter_rows(values_only=True):
            cells = [str(c).strip() if c is not None else "" for c in row]
            joined = " ".join(cells).strip().lower()
            if not joined:
                continue

            if "оборудование" in joined and len(joined) < 40:
                current_type = "equipment"
                continue
            if "мебель" == joined.strip():
                current_type = "furniture"
                continue
            if "расходный пластик" in joined or "расходник клетки" in joined or "расходник клеточные" in joined:
                current_type = "consumable"
                continue
            if joined in ("306", "308", "310"):
                current_type = "reagent"
                current_room_default = joined
                continue
            if "№ п/п" in joined or "основное средство" in joined or "реактив (полное название)" in joined:
                continue

            name = None
            code = None
            formula = None
            cas = None
            manufacturer = None
            catalog_number = None
            notes = None
            room = current_room_default

            for c in cells:
                r = detect_room(c)
                if r:
                    room = r

            non_empty = [c for c in cells if c]
            if not non_empty:
                continue

            if current_type == "equipment" or current_type == "furniture":
                name = non_empty[1] if len(non_empty) > 1 else non_empty[0]
                code = non_empty[2] if len(non_empty) > 2 and re.match(r"^\d{6,}$", non_empty[2]) else None
                notes = " | ".join(non_empty[-3:]) if len(non_empty) > 3 else None
            elif current_type == "reagent":
                candidates = [c for c in non_empty if not re.match(r"^\d+(\.\d+)?\.?$", c) and not detect_room(c)]
                name = candidates[0] if candidates else non_empty[-1]
                code = non_empty[0] if re.match(r"^\d+(\.\d+)?\.?$", non_empty[0]) else None
                notes = " | ".join(candidates[1:]) if len(candidates) > 1 else None
            else:
                name = non_empty[0]
                notes = " | ".join(non_empty[1:]) if len(non_empty) > 1 else None

            if not name or len(name) < 2:
                continue

            loc_id = get_or_create_location(conn, loc_cache, room)
            insert_item(conn, current_type, code, name, formula, cas, manufacturer, catalog_number, notes, loc_id)
            total += 1

    conn.commit()

    conn.execute("""
        UPDATE items SET search_vector =
            to_tsvector('russian', coalesce(name,'')) ||
            to_tsvector('english',
                coalesce(formula,'') || ' ' ||
                coalesce(cas,'') || ' ' ||
                coalesce(code,'') || ' ' ||
                coalesce(manufacturer,'') || ' ' ||
                coalesce(catalog_number,''))
    """)
    conn.commit()
    print(f"Импортировано строк: {total}")
    conn.close()

if __name__ == "__main__":
    main()
