import re
import shutil

path = "main.py"
shutil.copy(path, path + ".bak")

with open(path, "r", encoding="utf-8") as f:
    content = f.read()

# Fix 1: .mapping -> ._mapping (SQLAlchemy 2.x)
content = re.sub(r"\.mapping\b", "._mapping", content)

# Fix 2: insert instrument-usage / instrument-maintenance endpoints
anchor = '@app.post("/api/experiments/alamar-blue")'
if anchor not in content:
    raise SystemExit("Anchor not found — check main.py manually")

block = '''
# ── Эндпоинты: расписание приборов (instrument_usage) ──────────────────────
@app.get("/api/instrument-usage")
def list_instrument_usage(instrument_id: str = Query(default=""), period: str = Query(default="week"), offset: int = Query(default=0), db: Session = Depends(get_db)):
    start, end = period_range(period, offset)
    params = {"start": start, "end": end}
    where = "start_time < :end AND end_time > :start"
    if instrument_id:
        where += " AND instrument_id = :instrument_id"
        params["instrument_id"] = instrument_id
    rows = db.execute(text(f"""
        SELECT id, instrument_id, username, start_time, end_time, notes, created_at
        FROM instrument_usage
        WHERE {where}
        ORDER BY start_time
    """), params).fetchall()
    return {"period": period, "offset": offset, "range_start": start, "range_end": end,
            "results": [dict(r._mapping) for r in rows]}


@app.post("/api/instrument-usage")
def add_instrument_usage(u: InstrumentUsageIn, db: Session = Depends(get_db)):
    if u.end_time <= u.start_time:
        raise HTTPException(400, "Время окончания должно быть позже начала")

    on_maintenance = db.execute(text("""
        SELECT id, reason FROM instrument_maintenance
        WHERE instrument_id = :instrument_id AND date_from <= :d AND date_to >= :d
        LIMIT 1
    """), {"instrument_id": u.instrument_id, "d": u.start_time.date()}).fetchone()
    if on_maintenance:
        reason = f" ({on_maintenance.reason})" if on_maintenance.reason else ""
        raise HTTPException(409, f"Прибор на техобслуживании{reason}")

    conflict = db.execute(text("""
        SELECT id, username, notes FROM instrument_usage
        WHERE instrument_id = :instrument_id
          AND tsrange(start_time, end_time) && tsrange(:start_time, :end_time)
        LIMIT 1
    """), {"instrument_id": u.instrument_id, "start_time": u.start_time, "end_time": u.end_time}).fetchone()
    if conflict and not u.force:
        raise HTTPException(409, f"КОНФЛИКТ: {conflict.username} ({conflict.notes or ''})")

    row = db.execute(text("""
        INSERT INTO instrument_usage (instrument_id, username, start_time, end_time, notes)
        VALUES (:instrument_id, :username, :start_time, :end_time, :notes)
        RETURNING id, instrument_id, username, start_time, end_time, notes, created_at
    """), {"instrument_id": u.instrument_id, "username": u.username, "start_time": u.start_time,
           "end_time": u.end_time, "notes": u.notes}).fetchone()

    log_activity(db, "add", "instrument_usage", row[0], u.instrument_id, f"{u.username} {u.start_time}-{u.end_time}")
    db.commit()
    return dict(row._mapping)


@app.patch("/api/instrument-usage/{usage_id}")
def update_instrument_usage(usage_id: int, data: InstrumentUsageUpdateIn, db: Session = Depends(get_db)):
    updates = {k: v for k, v in data.dict().items() if v is not None}
    if not updates:
        raise HTTPException(400, "Нет данных для обновления")
    sets = ", ".join(f"{k} = :{k}" for k in updates)
    updates["id"] = usage_id
    cur = db.execute(text(f"UPDATE instrument_usage SET {sets} WHERE id = :id"), updates)
    if cur.rowcount == 0:
        raise HTTPException(404, "Не найдено")
    db.commit()
    return {"ok": True}


@app.delete("/api/instrument-usage/{usage_id}")
def delete_instrument_usage(usage_id: int, db: Session = Depends(get_db)):
    row = db.execute(text("SELECT instrument_id, username FROM instrument_usage WHERE id = :id"), {"id": usage_id}).fetchone()
    cur = db.execute(text("DELETE FROM instrument_usage WHERE id = :id"), {"id": usage_id})
    if cur.rowcount == 0:
        raise HTTPException(404, "Не найдено")
    if row:
        log_activity(db, "delete", "instrument_usage", usage_id, row.username, f"instrument_id={row.instrument_id}")
    db.commit()
    return {"ok": True}


@app.get("/api/instrument-maintenance/all")
def list_all_instrument_maintenance(db: Session = Depends(get_db)):
    rows = db.execute(text("""
        SELECT id, instrument_id, date_from, date_to, reason, created_by, created_at
        FROM instrument_maintenance
        ORDER BY date_from
    """)).fetchall()
    return [dict(r._mapping) for r in rows]


@app.post("/api/instrument-maintenance")
def add_instrument_maintenance(m: InstrumentMaintenanceIn, db: Session = Depends(get_db)):
    if m.date_to < m.date_from:
        raise HTTPException(400, "Дата окончания должна быть не раньше даты начала")
    row = db.execute(text("""
        INSERT INTO instrument_maintenance (instrument_id, date_from, date_to, reason, created_by)
        VALUES (:instrument_id, :date_from, :date_to, :reason, :created_by)
        RETURNING id, instrument_id, date_from, date_to, reason, created_by, created_at
    """), {"instrument_id": m.instrument_id, "date_from": m.date_from, "date_to": m.date_to,
           "reason": m.reason, "created_by": m.created_by}).fetchone()
    log_activity(db, "add", "instrument_maintenance", row[0], m.instrument_id,
                 f"{m.date_from}-{m.date_to} {m.reason or ''}")
    db.commit()
    return dict(row._mapping)


@app.delete("/api/instrument-maintenance/{maintenance_id}")
def delete_instrument_maintenance(maintenance_id: int, db: Session = Depends(get_db)):
    row = db.execute(text("SELECT instrument_id, reason FROM instrument_maintenance WHERE id = :id"), {"id": maintenance_id}).fetchone()
    cur = db.execute(text("DELETE FROM instrument_maintenance WHERE id = :id"), {"id": maintenance_id})
    if cur.rowcount == 0:
        raise HTTPException(404, "Не найдено")
    if row:
        log_activity(db, "delete", "instrument_maintenance", maintenance_id, row.instrument_id, row.reason or "")
    db.commit()
    return {"ok": True}
# ── END Эндпоинты: расписание приборов ──────────────────────────────────────


'''

content = content.replace(anchor, block + anchor, 1)

with open(path, "w", encoding="utf-8") as f:
    f.write(content)

print("OK: main.py patched. Backup saved as main.py.bak")