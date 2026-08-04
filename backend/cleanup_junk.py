"""
cleanup_junk.py
Удаляет мусорные позиции из таблицы items:
1. Записи с item_type='consumable' (Расходники), у которых cabinet='-' И
   номер шкафа явно совпадает с номером комнаты (например room='107', cabinet='-'
   но в поле notes/formula затесался "107" как артефакт парсинга).
2. Записи, у которых room совпадает по числу с cabinet-мусором вида
   "107 · Шкаф -" — то есть cabinet IS NULL или '-' и location реально не задана.
3. Опционально: полностью удаляет позиции без названия (name IS NULL).

ВНИМАНИЕ: сначала скрипт делает DRY RUN (только показывает, что будет удалено).
Чтобы реально удалить — запусти с флагом --apply:
    python cleanup_junk.py            # только показать
    python cleanup_junk.py --apply    # удалить
"""

import sys
from sqlalchemy import text
from database import engine

APPLY = "--apply" in sys.argv

with engine.connect() as conn:
    # 1. Показать список "мусорных" расходников без реального адреса
    rows = conn.execute(text("""
        SELECT i.id, i.item_type, i.name, i.quantity, l.room, l.cabinet, l.shelf, l.slot
        FROM items i
        LEFT JOIN locations l ON i.location_id = l.id
        WHERE i.item_type = 'consumable'
          AND (l.cabinet IS NULL OR l.cabinet = '-')
          AND (l.shelf IS NULL OR l.shelf = '-')
          AND (i.name IS NULL OR i.name = '' OR i.name ~ '^[0-9]+$')
        ORDER BY l.room
    """)).fetchall()

    print(f"Найдено мусорных 'Расходников' без адреса и без нормального названия: {len(rows)}")
    for r in rows[:30]:
        print(f"  id={r.id} room={r.room} cabinet={r.cabinet} name={r.name!r} qty={r.quantity}")
    if len(rows) > 30:
        print(f"  ... и ещё {len(rows) - 30}")

    # 2. Показать позиции без названия вообще (name IS NULL или пустое)
    rows_noname = conn.execute(text("""
        SELECT id, item_type, name, source_file, source_sheet
        FROM items
        WHERE name IS NULL OR trim(name) = ''
    """)).fetchall()
    print(f"\\nНайдено позиций без названия: {len(rows_noname)}")
    for r in rows_noname[:30]:
        print(f"  id={r.id} type={r.item_type} source={r.source_file}/{r.source_sheet}")

    all_ids = [r.id for r in rows] + [r.id for r in rows_noname]
    all_ids = list(set(all_ids))

    if not APPLY:
        print(f"\\nDRY RUN: будет удалено {len(all_ids)} записей.")
        print("Чтобы реально удалить, запусти: python cleanup_junk.py --apply")
    else:
        if all_ids:
            conn.execute(
                text("DELETE FROM items WHERE id = ANY(:ids)"),
                {"ids": all_ids},
            )
            conn.commit()
            print(f"\\nУдалено записей: {len(all_ids)}")
        else:
            print("\\nНичего удалять не нужно.")

    # 3. Показать оставшиеся комнаты и количество позиций в них
    print("\\nТекущее распределение по комнатам:")
    stats = conn.execute(text("""
        SELECT coalesce(l.room, 'не указано') AS room, COUNT(i.id) AS n
        FROM items i
        LEFT JOIN locations l ON i.location_id = l.id
        GROUP BY l.room
        ORDER BY n DESC
    """)).fetchall()
    for s in stats:
        print(f"  {s.room}: {s.n}")
