from fastapi import FastAPI, HTTPException, Query, Header
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from typing import Optional
import psycopg
import psycopg.rows
import os
import bcrypt
import jwt
from datetime import datetime, timedelta
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(title="Lab Inventory API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

ALLOWED_TYPES = {"reagent", "equipment", "consumable", "furniture", "other"}
JWT_SECRET = "lab-secret-change-me"
JWT_ALGO = "HS256"


def get_conn():
    return psycopg.connect(
        host=os.environ.get("PGHOST", "localhost"),
        port=int(os.environ.get("PGPORT", 5432)),
        dbname=os.environ.get("PGDATABASE", "lab_chemicals"),
        user=os.environ.get("PGUSER", "postgres"),
        password=os.environ.get("PGPASSWORD", ""),
        row_factory=psycopg.rows.dict_row,
    )


def normalize_item_type(value: Optional[str]) -> str:
    val = (value or "other").strip().lower()
    return val if val in ALLOWED_TYPES else "other"


# ── Pydantic-схемы ────────────────────────────────────────────────────────

class LocationIn(BaseModel):
    room: str
    cabinet: Optional[str] = None
    shelf: Optional[str] = None
    slot: Optional[str] = None


class ItemIn(BaseModel):
    item_type: str = "other"
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


class LoginIn(BaseModel):
    username: str
    password: str


class ProtocolIn(BaseModel):
    title: str
    description: Optional[str] = None
    steps: Optional[str] = None
    room: Optional[str] = None


class ProtocolItemIn(BaseModel):
    item_id: int
    amount: Optional[str] = None
    role: Optional[str] = None


# ── Auth helpers ───────────────────────────────────────────────────────────

def create_token(username: str) -> str:
    payload = {"sub": username, "exp": datetime.utcnow() + timedelta(hours=24)}
    return jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGO)


def require_admin(authorization: str = Header(default="")):
    if not authorization.startswith("Bearer "):
        raise HTTPException(401, "Требуется авторизация")
    token = authorization.split(" ", 1)[1]
    try:
        payload = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGO])
    except jwt.PyJWTError:
        raise HTTPException(401, "Неверный или просроченный токен")
    return payload["sub"]


# ── Search vector helper ────────────────────────────────────────────────────

def update_search(conn, item_id: int):
    conn.execute(
        """
        UPDATE items
        SET updated_at = now(),
            search_vector =
                to_tsvector('russian', coalesce(name,'') || ' ' || coalesce(name_ru,'') || ' ' || coalesce(notes,'')) ||
                to_tsvector('english', coalesce(name,'') || ' ' || coalesce(name_en,'') || ' ' ||
                    coalesce(formula,'') || ' ' || coalesce(cas,'') || ' ' || coalesce(internal_code,'') || ' ' ||
                    coalesce(manufacturer,'') || ' ' || coalesce(catalog_number,'') || ' ' ||
                    coalesce(inventory_number,'') || ' ' || coalesce(serial_number,'') || ' ' ||
                    coalesce(registry_number,'') || ' ' || coalesce(status,'') || ' ' ||
                    coalesce(source_file,'') || ' ' || coalesce(source_sheet,''))
        WHERE id = %s
        """,
        (item_id,),
    )
    conn.commit()


def get_or_create_location(conn, room, cabinet, shelf, slot):
    if not room:
        return None
    row = conn.execute(
        """
        INSERT INTO locations (room, cabinet, shelf, slot)
        VALUES (%s, %s, %s, %s)
        ON CONFLICT (room, cabinet, shelf, slot) DO UPDATE SET room = EXCLUDED.room
        RETURNING id
        """,
        (room, cabinet or "-", shelf or "-", slot or "-"),
    ).fetchone()
    return row["id"] if row else None


# ── Health ──────────────────────────────────────────────────────────────────

@app.get("/api/health")
def health():
    return {"ok": True}


# ── Auth ────────────────────────────────────────────────────────────────────

@app.post("/api/auth/login")
def login(data: LoginIn):
    with get_conn() as conn:
        row = conn.execute(
            "SELECT username, password_hash FROM admin_users WHERE username = %s",
            (data.username,),
        ).fetchone()
    if not row or not bcrypt.checkpw(data.password.encode(), row["password_hash"].encode()):
        raise HTTPException(401, "Неверный логин или пароль")
    return {"token": create_token(row["username"]), "username": row["username"]}


# ── Search / Items ───────────────────────────────────────────────────────────

@app.get("/api/search")
def search(
    q: str = Query(default=""),
    room: str = Query(default=""),
    item_type: str = Query(default=""),
    source_file: str = Query(default=""),
    limit: int = Query(default=1000, ge=1, le=2000),
):
    params = {
        "q": q,
        "like": f"%{q}%",
        "room": room,
        "item_type": normalize_item_type(item_type) if item_type else "",
        "source_file": source_file,
        "limit": limit,
    }
    with get_conn() as conn:
        rows = conn.execute(
            """
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
                %(q)s = ''
                OR i.search_vector @@ plainto_tsquery('russian', %(q)s)
                OR i.search_vector @@ plainto_tsquery('english', %(q)s)
                OR coalesce(i.name,'') ILIKE %(like)s
                OR coalesce(i.name_ru,'') ILIKE %(like)s
                OR coalesce(i.name_en,'') ILIKE %(like)s
                OR coalesce(i.formula,'') ILIKE %(like)s
                OR coalesce(i.cas,'') ILIKE %(like)s
                OR coalesce(i.internal_code,'') ILIKE %(like)s
                OR coalesce(i.inventory_number,'') ILIKE %(like)s
                OR coalesce(i.catalog_number,'') ILIKE %(like)s
                OR coalesce(i.serial_number,'') ILIKE %(like)s
                OR coalesce(i.registry_number,'') ILIKE %(like)s
                OR coalesce(i.manufacturer,'') ILIKE %(like)s
                OR coalesce(i.notes,'') ILIKE %(like)s
            )
            AND (%(room)s = '' OR coalesce(l.room,'') = %(room)s)
            AND (%(item_type)s = '' OR coalesce(i.item_type,'') = %(item_type)s)
            AND (%(source_file)s = '' OR coalesce(i.source_file,'') = %(source_file)s)
            ORDER BY
                coalesce(l.room,'ZZZ'),
                CASE i.item_type
                    WHEN 'reagent' THEN 1
                    WHEN 'consumable' THEN 2
                    WHEN 'equipment' THEN 3
                    WHEN 'furniture' THEN 4
                    ELSE 5
                END,
                coalesce(i.name, i.name_ru, i.name_en, ''),
                coalesce(i.internal_code,''),
                i.id
            LIMIT %(limit)s
            """,
            params,
        ).fetchall()
    return {"count": len(rows), "results": [dict(r) for r in rows]}


@app.get("/api/stats")
def stats():
    with get_conn() as conn:
        total = conn.execute("SELECT COUNT(*) AS n FROM items").fetchone()["n"]
        by_type = conn.execute(
            "SELECT item_type, COUNT(*) AS n FROM items GROUP BY item_type ORDER BY item_type"
        ).fetchall()
        by_room = conn.execute(
            """
            SELECT coalesce(l.room, 'Без комнаты') AS room, COUNT(*) AS n
            FROM items i LEFT JOIN locations l ON i.location_id = l.id
            GROUP BY coalesce(l.room, 'Без комнаты') ORDER BY room
            """
        ).fetchall()
    return {
        "total": total,
        "by_type": [dict(r) for r in by_type],
        "by_room": [dict(r) for r in by_room],
    }


@app.get("/api/locations")
def get_locations(room: str = Query(default="")):
    with get_conn() as conn:
        if room:
            rows = conn.execute(
                "SELECT * FROM locations WHERE room = %s ORDER BY room, cabinet, shelf, slot",
                (room,),
            ).fetchall()
        else:
            rows = conn.execute(
                "SELECT * FROM locations ORDER BY room, cabinet, shelf, slot"
            ).fetchall()
    return [dict(r) for r in rows]


@app.post("/api/locations")
def add_location(loc: LocationIn):
    with get_conn() as conn:
        row = conn.execute(
            """
            INSERT INTO locations (room, cabinet, shelf, slot)
            VALUES (%s, %s, %s, %s)
            ON CONFLICT (room, cabinet, shelf, slot) DO UPDATE SET room = EXCLUDED.room
            RETURNING *
            """,
            (loc.room, loc.cabinet or "-", loc.shelf or "-", loc.slot or "-"),
        ).fetchone()
        conn.commit()
    return dict(row)


@app.get("/api/item/{item_id}")
def get_item(item_id: int):
    with get_conn() as conn:
        row = conn.execute(
            """
            SELECT i.*, i.internal_code AS code, l.room, l.cabinet, l.shelf, l.slot
            FROM items i LEFT JOIN locations l ON i.location_id = l.id
            WHERE i.id = %s
            """,
            (item_id,),
        ).fetchone()
    if not row:
        raise HTTPException(404, "Не найдено")
    return dict(row)


@app.post("/api/item")
def add_item(item: ItemIn):
    item_type = normalize_item_type(item.item_type)
    with get_conn() as conn:
        row = conn.execute(
            """
            INSERT INTO items (
                item_type, internal_code, name, name_ru, name_en, formula, cas,
                manufacturer, catalog_number, inventory_number, serial_number,
                registry_number, quantity, unit, status, notes,
                source_file, source_sheet, location_id
            ) VALUES (
                %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
            ) RETURNING id
            """,
            (
                item_type, item.code, item.name, item.name_ru, item.name_en, item.formula, item.cas,
                item.manufacturer, item.catalog_number, item.inventory_number, item.serial_number,
                item.registry_number, item.quantity, item.unit, item.status, item.notes,
                item.source_file, item.source_sheet, item.location_id,
            ),
        ).fetchone()
        item_id = row["id"]
        conn.commit()
        update_search(conn, item_id)
    return {"ok": True, "id": item_id}


@app.patch("/api/item/{item_id}")
def update_item(item_id: int, data: ItemUpdate):
    updates = {k: v for k, v in data.dict().items() if v is not None}
    if not updates:
        raise HTTPException(400, "Нет данных для обновления")
    if "item_type" in updates:
        updates["item_type"] = normalize_item_type(updates["item_type"])
    if "code" in updates:
        updates["internal_code"] = updates.pop("code")
    sets = ", ".join(f"{k} = %s" for k in updates)
    vals = list(updates.values()) + [item_id]
    with get_conn() as conn:
        cur = conn.execute(f"UPDATE items SET {sets} WHERE id = %s", vals)
        if cur.rowcount == 0:
            raise HTTPException(404, "Не найдено")
        conn.commit()
        update_search(conn, item_id)
    return {"ok": True}


@app.delete("/api/item/{item_id}")
def delete_item(item_id: int):
    with get_conn() as conn:
        cur = conn.execute("DELETE FROM items WHERE id = %s", (item_id,))
        conn.commit()
    if cur.rowcount == 0:
        raise HTTPException(404, "Не найдено")
    return {"ok": True}


# ── Protocols ────────────────────────────────────────────────────────────────

@app.get("/api/protocols")
def list_protocols(room: str = Query(default="")):
    with get_conn() as conn:
        if room:
            rows = conn.execute(
                "SELECT * FROM protocols WHERE room = %s ORDER BY title", (room,)
            ).fetchall()
        else:
            rows = conn.execute("SELECT * FROM protocols ORDER BY title").fetchall()
    return [dict(r) for r in rows]


@app.get("/api/protocols/{protocol_id}")
def get_protocol(protocol_id: int):
    with get_conn() as conn:
        proto = conn.execute(
            "SELECT * FROM protocols WHERE id = %s", (protocol_id,)
        ).fetchone()
        if not proto:
            raise HTTPException(404, "Протокол не найден")
        items = conn.execute(
            """
            SELECT pi.amount, pi.role, i.*, i.internal_code AS code
            FROM protocol_items pi JOIN items i ON i.id = pi.item_id
            WHERE pi.protocol_id = %s
            """,
            (protocol_id,),
        ).fetchall()
    result = dict(proto)
    result["items"] = [dict(r) for r in items]
    return result


@app.post("/api/protocols")
def create_protocol(data: ProtocolIn, admin: str = Header(default=None, alias="Authorization")):
    with get_conn() as conn:
        row = conn.execute(
            "INSERT INTO protocols (title, description, steps, room) VALUES (%s, %s, %s, %s) RETURNING id",
            (data.title, data.description, data.steps, data.room),
        ).fetchone()
        conn.commit()
    return {"ok": True, "id": row["id"]}


@app.patch("/api/protocols/{protocol_id}")
def update_protocol(protocol_id: int, data: ProtocolIn):
    updates = {k: v for k, v in data.dict().items() if v is not None}
    if not updates:
        raise HTTPException(400, "Нет данных для обновления")
    sets = ", ".join(f"{k} = %s" for k in updates)
    vals = list(updates.values()) + [protocol_id]
    with get_conn() as conn:
        cur = conn.execute(f"UPDATE protocols SET {sets}, updated_at = now() WHERE id = %s", vals)
        conn.commit()
    if cur.rowcount == 0:
        raise HTTPException(404, "Не найдено")
    return {"ok": True}


@app.delete("/api/protocols/{protocol_id}")
def delete_protocol(protocol_id: int):
    with get_conn() as conn:
        cur = conn.execute("DELETE FROM protocols WHERE id = %s", (protocol_id,))
        conn.commit()
    if cur.rowcount == 0:
        raise HTTPException(404, "Не найдено")
    return {"ok": True}


@app.post("/api/protocols/{protocol_id}/items")
def add_protocol_item(protocol_id: int, data: ProtocolItemIn):
    with get_conn() as conn:
        conn.execute(
            """
            INSERT INTO protocol_items (protocol_id, item_id, amount, role)
            VALUES (%s, %s, %s, %s)
            ON CONFLICT (protocol_id, item_id) DO UPDATE SET amount=EXCLUDED.amount, role=EXCLUDED.role
            """,
            (protocol_id, data.item_id, data.amount, data.role),
        )
        conn.commit()
    return {"ok": True}


app.mount("/", StaticFiles(directory="static", html=True), name="static")