from fastapi import FastAPI, HTTPException, Query, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from typing import Optional, List
from sqlalchemy.orm import Session
from sqlalchemy import text
import os
from dotenv import load_dotenv

from database import get_db, init_db
from models import Location, Item

load_dotenv()

app = FastAPI(title="Lab Inventory API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

ALLOWED_TYPES = {"reagent", "equipment", "consumable", "furniture", "other"}


# ── Pydantic-схемы ────────────────────────────────────────────────────────────

class LocationIn(BaseModel):
    room: str
    cabinet: Optional[str] = None
    shelf: Optional[str] = None
    slot: Optional[str] = None


class ItemIn(BaseModel):
    item_type: str = "other"
    code: Optional[str] = None          # → internal_code в БД
    name: Optional[str] = None
    name_ru: Optional[str] = None
    name_en: Optional[str] = None
    formula: Optional[str] = None
    cas: Optional[str] = None
    manufacturer: Optional[str] = None
    catalog_number: Optional[str] = None
    inventory_number: Optional[str] = None
    serial_number: Optional[str] = None
    registry_number: Optional[str] = None
    quantity: Optional[str] = None
    unit: Optional[str] = None
    status: Optional[str] = None
    notes: Optional[str] = None
    source_file: Optional[str] = None
    source_sheet: Optional[str] = None
    location_id: Optional[int] = None


class ItemUpdate(BaseModel):
    item_type: Optional[str] = None
    code: Optional[str] = None
    name: Optional[str] = None
    name_ru: Optional[str] = None
    name_en: Optional[str] = None
    formula: Optional[str] = None
    cas: Optional[str] = None
    manufacturer: Optional[str] = None
    catalog_number: Optional[str] = None
    inventory_number: Optional[str] = None
    serial_number: Optional[str] = None
    registry_number: Optional[str] = None
    quantity: Optional[str] = None
    unit: Optional[str] = None
    status: Optional[str] = None
    notes: Optional[str] = None
    source_file: Optional[str] = None
    source_sheet: Optional[str] = None
    location_id: Optional[int] = None


# ── Вспомогательные функции ───────────────────────────────────────────────────

def normalize_item_type(value: Optional[str]) -> str:
    val = (value or "other").strip().lower()
    return val if val in ALLOWED_TYPES else "other"


def update_search_vector(db: Session, item_id: int):
    """Пересчитывает tsvector для строки items."""
    db.execute(
        text("""
            UPDATE items
            SET
                updated_at = now(),
                search_vector =
                    to_tsvector('russian',
                        coalesce(name,'')    || ' ' ||
                        coalesce(name_ru,'') || ' ' ||
                        coalesce(notes,'')) ||
                    to_tsvector('english',
                        coalesce(name,'')             || ' ' ||
                        coalesce(name_en,'')           || ' ' ||
                        coalesce(formula,'')           || ' ' ||
                        coalesce(cas,'')               || ' ' ||
                        coalesce(internal_code,'')     || ' ' ||
                        coalesce(manufacturer,'')      || ' ' ||
                        coalesce(catalog_number,'')    || ' ' ||
                        coalesce(inventory_number,'')  || ' ' ||
                        coalesce(serial_number,'')     || ' ' ||
                        coalesce(registry_number,'')   || ' ' ||
                        coalesce(status,'')            || ' ' ||
                        coalesce(source_file,'')       || ' ' ||
                        coalesce(source_sheet,''))
            WHERE id = :item_id
        """),
        {"item_id": item_id},
    )


def get_or_create_location(
    db: Session,
    room: Optional[str],
    cabinet: Optional[str],
    shelf: Optional[str],
    slot: Optional[str],
) -> Optional[int]:
    if not room:
        return None
    row = db.execute(
        text("""
            INSERT INTO locations (room, cabinet, shelf, slot)
            VALUES (:room, :cabinet, :shelf, :slot)
            ON CONFLICT (room, cabinet, shelf, slot)
            DO UPDATE SET room = EXCLUDED.room
            RETURNING id
        """),
        {
            "room": room,
            "cabinet": cabinet or "-",
            "shelf": shelf or "-",
            "slot": slot or "-",
        },
    ).fetchone()
    return row[0] if row else None


# ── Жизненный цикл ────────────────────────────────────────────────────────────

@app.on_event("startup")
def on_startup():
    init_db()


# ── Эндпоинты ─────────────────────────────────────────────────────────────────

@app.get("/api/health")
def health():
    return {"ok": True}


@app.get("/api/search")
def search(
    q: str = Query(default=""),
    room: str = Query(default=""),
    item_type: str = Query(default=""),
    source_file: str = Query(default=""),
    limit: int = Query(default=300, ge=1, le=1000),
    db: Session = Depends(get_db),
):
    params = {
        "q": q,
        "like": f"%{q}%",
        "room": room,
        "item_type": normalize_item_type(item_type) if item_type else "",
        "source_file": source_file,
        "limit": limit,
    }
    rows = db.execute(
        text("""
            SELECT
                i.id, i.item_type, i.internal_code AS code,
                i.name, i.name_ru, i.name_en,
                i.formula, i.cas, i.manufacturer,
                i.catalog_number, i.inventory_number, i.serial_number,
                i.registry_number, i.quantity, i.unit,
                i.status, i.notes, i.source_file, i.source_sheet,
                i.location_id,
                l.room, l.cabinet, l.shelf, l.slot
            FROM items i
            LEFT JOIN locations l ON i.location_id = l.id
            WHERE (
                :q = ''
                OR i.search_vector @@ plainto_tsquery('russian', :q)
                OR i.search_vector @@ plainto_tsquery('english', :q)
                OR coalesce(i.name,'')             ILIKE :like
                OR coalesce(i.name_ru,'')          ILIKE :like
                OR coalesce(i.name_en,'')          ILIKE :like
                OR coalesce(i.formula,'')          ILIKE :like
                OR coalesce(i.cas,'')              ILIKE :like
                OR coalesce(i.internal_code,'')    ILIKE :like
                OR coalesce(i.inventory_number,'') ILIKE :like
                OR coalesce(i.catalog_number,'')   ILIKE :like
                OR coalesce(i.serial_number,'')    ILIKE :like
                OR coalesce(i.registry_number,'')  ILIKE :like
                OR coalesce(i.manufacturer,'')     ILIKE :like
                OR coalesce(i.notes,'')            ILIKE :like
            )
            AND (:room        = '' OR coalesce(l.room,'')        = :room)
            AND (:item_type   = '' OR coalesce(i.item_type,'')   = :item_type)
            AND (:source_file = '' OR coalesce(i.source_file,'') = :source_file)
            ORDER BY
                coalesce(l.room,'ZZZ'),
                coalesce(l.cabinet,'ZZZ'),
                coalesce(i.item_type,'zzz'),
                coalesce(i.name, i.name_ru, i.name_en,''),
                coalesce(i.internal_code,''),
                i.id
            LIMIT :limit
        """),
        params,
    ).fetchall()
    results = [dict(r._mapping) for r in rows]
    return {"count": len(results), "results": results}


@app.get("/api/stats")
def stats(db: Session = Depends(get_db)):
    total = db.execute(text("SELECT COUNT(*) FROM items")).scalar()
    by_type = db.execute(
        text("SELECT item_type, COUNT(*) AS n FROM items GROUP BY item_type ORDER BY item_type")
    ).fetchall()
    by_room = db.execute(
        text("""
            SELECT coalesce(l.room, 'Без комнаты') AS room, COUNT(*) AS n
            FROM items i
            LEFT JOIN locations l ON i.location_id = l.id
            GROUP BY coalesce(l.room, 'Без комнаты')
            ORDER BY room
        """)
    ).fetchall()
    files = db.execute(
        text("SELECT source_file, COUNT(*) AS n FROM items GROUP BY source_file ORDER BY source_file")
    ).fetchall()
    return {
        "total": total,
        "by_type": [dict(r._mapping) for r in by_type],
        "by_room": [dict(r._mapping) for r in by_room],
        "by_source_file": [dict(r._mapping) for r in files],
    }


@app.get("/api/rooms")
def rooms(db: Session = Depends(get_db)):
    rows = db.execute(
        text("""
            SELECT l.room, COUNT(i.id) AS items_count
            FROM locations l
            LEFT JOIN items i ON i.location_id = l.id
            GROUP BY l.room
            ORDER BY l.room
        """)
    ).fetchall()
    return [dict(r._mapping) for r in rows]


@app.get("/api/locations")
def get_locations(
    room: str = Query(default=""),
    db: Session = Depends(get_db),
):
    if room:
        rows = db.execute(
            text("SELECT * FROM locations WHERE room = :room ORDER BY room, cabinet, shelf, slot"),
            {"room": room},
        ).fetchall()
    else:
        rows = db.execute(
            text("SELECT * FROM locations ORDER BY room, cabinet, shelf, slot")
        ).fetchall()
    return [dict(r._mapping) for r in rows]


@app.post("/api/locations")
def add_location(loc: LocationIn, db: Session = Depends(get_db)):
    row = db.execute(
        text("""
            INSERT INTO locations (room, cabinet, shelf, slot)
            VALUES (:room, :cabinet, :shelf, :slot)
            ON CONFLICT (room, cabinet, shelf, slot)
            DO UPDATE SET room = EXCLUDED.room
            RETURNING *
        """),
        {
            "room": loc.room,
            "cabinet": loc.cabinet or "-",
            "shelf": loc.shelf or "-",
            "slot": loc.slot or "-",
        },
    ).fetchone()
    db.commit()
    return dict(row._mapping)


@app.get("/api/item/{item_id}")
def get_item(item_id: int, db: Session = Depends(get_db)):
    row = db.execute(
        text("""
            SELECT i.*, i.internal_code AS code, l.room, l.cabinet, l.shelf, l.slot
            FROM items i
            LEFT JOIN locations l ON i.location_id = l.id
            WHERE i.id = :item_id
        """),
        {"item_id": item_id},
    ).fetchone()
    if not row:
        raise HTTPException(404, "Не найдено")
    return dict(row._mapping)


@app.post("/api/item")
def add_item(item: ItemIn, db: Session = Depends(get_db)):
    item_type = normalize_item_type(item.item_type)
    row = db.execute(
        text("""
            INSERT INTO items (
                item_type, internal_code, name, name_ru, name_en, formula, cas,
                manufacturer, catalog_number, inventory_number, serial_number,
                registry_number, quantity, unit, status, notes,
                source_file, source_sheet, location_id
            ) VALUES (
                :item_type, :internal_code, :name, :name_ru, :name_en, :formula, :cas,
                :manufacturer, :catalog_number, :inventory_number, :serial_number,
                :registry_number, :quantity, :unit, :status, :notes,
                :source_file, :source_sheet, :location_id
            )
            RETURNING id
        """),
        {
            "item_type": item_type,
            "internal_code": item.code,
            "name": item.name,
            "name_ru": item.name_ru,
            "name_en": item.name_en,
            "formula": item.formula,
            "cas": item.cas,
            "manufacturer": item.manufacturer,
            "catalog_number": item.catalog_number,
            "inventory_number": item.inventory_number,
            "serial_number": item.serial_number,
            "registry_number": item.registry_number,
            "quantity": item.quantity,
            "unit": item.unit,
            "status": item.status,
            "notes": item.notes,
            "source_file": item.source_file,
            "source_sheet": item.source_sheet,
            "location_id": item.location_id,
        },
    ).fetchone()
    item_id = row[0]
    update_search_vector(db, item_id)
    db.commit()
    return {"ok": True, "id": item_id}


@app.patch("/api/item/{item_id}")
def update_item(item_id: int, data: ItemUpdate, db: Session = Depends(get_db)):
    updates = {k: v for k, v in data.dict().items() if v is not None}
    if not updates:
        raise HTTPException(400, "Нет данных для обновления")
    if "item_type" in updates:
        updates["item_type"] = normalize_item_type(updates["item_type"])
    # Маппинг: поле API code → колонка internal_code
    if "code" in updates:
        updates["internal_code"] = updates.pop("code")

    sets = ", ".join(f"{k} = :{k}" for k in updates)
    updates["_item_id"] = item_id
    cur = db.execute(
        text(f"UPDATE items SET {sets} WHERE id = :_item_id"),
        updates,
    )
    if cur.rowcount == 0:
        raise HTTPException(404, "Не найдено")
    update_search_vector(db, item_id)
    db.commit()
    return {"ok": True}


@app.delete("/api/item/{item_id}")
def delete_item(item_id: int, db: Session = Depends(get_db)):
    cur = db.execute(
        text("DELETE FROM items WHERE id = :item_id"),
        {"item_id": item_id},
    )
    db.commit()
    if cur.rowcount == 0:
        raise HTTPException(404, "Не найдено")
    return {"ok": True}


@app.get("/api/export/sql-template")
def export_sql_template():
    return {"message": "Use import_xlsx.py to load Excel files into items."}


app.mount("/", StaticFiles(directory="static", html=True), name="static")
