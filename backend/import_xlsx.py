"""
import_xlsx.py
Импорт данных из трёх Excel-файлов лаборатории в PostgreSQL (items, locations).

Запуск:
    python import_xlsx.py

Файлы должны лежать в той же папке, что и этот скрипт:
    - Reviziia-Laby-IBSiB-3-2.xlsx
    - inventarizatsiia-sklada.xlsx
    - Inventarizatsiia-laboratorii-1-2-3.xlsx
"""

import re
import pandas as pd
from sqlalchemy import text
from database import engine, SessionLocal, init_db

# ──────────────────────────────────────────────────────────────────────────
# 1. СПРАВОЧНИК РЕАКТИВОВ: название → (формула, CAS, name_ru, name_en)
#    Сопоставление идёт по подстроке (регистронезависимо).
#    Дополняй список по мере необходимости.
# ──────────────────────────────────────────────────────────────────────────

REAGENT_DB = [
    # ключевые слова для поиска      формула              CAS           русское название            английское название
    (["sodium chloride", "натрия хлорид", "хлорид натрия", "nacl"],
        "NaCl", "7647-14-5", "натрия хлорид", "Sodium chloride"),
    (["sodium hydroxide", "натрия гидроксид", "гидроксид натрия", "едкий натр", "naoh"],
        "NaOH", "1310-73-2", "натрия гидроксид", "Sodium hydroxide"),
    (["sodium bicarbonate", "натрия бикарбонат", "гидрокарбонат натрия", "nahco3"],
        "NaHCO3", "144-55-8", "натрия гидрокарбонат", "Sodium bicarbonate"),
    (["sodium carbonate", "натрия карбонат", "карбонат натрия", "na2co3"],
        "Na2CO3", "497-19-8", "натрия карбонат", "Sodium carbonate"),
    (["sodium citrate", "натрия цитрат", "цитрат натрия"],
        "Na3C6H5O7", "68-04-2", "натрия цитрат", "Sodium citrate"),
    (["sodium azide", "натрия азид", "азид натрия", "nan3"],
        "NaN3", "26628-22-8", "натрия азид", "Sodium azide"),
    (["sodium dodecyl sulfate", "sds", "додецилсульфат натрия"],
        "C12H25NaO4S", "151-21-3", "натрия додецилсульфат", "Sodium dodecyl sulfate (SDS)"),
    (["potassium chloride", "калия хлорид", "хлорид калия", "kcl"],
        "KCl", "7447-40-7", "калия хлорид", "Potassium chloride"),
    (["potassium hydroxide", "калия гидроксид", "гидроксид калия", "koh"],
        "KOH", "1310-58-3", "калия гидроксид", "Potassium hydroxide"),
    (["potassium permanganate", "калия перманганат", "марганцовка"],
        "KMnO4", "7722-64-7", "калия перманганат", "Potassium permanganate"),
    (["calcium chloride", "кальция хлорид", "хлорид кальция", "cacl2"],
        "CaCl2", "10043-52-4", "кальция хлорид", "Calcium chloride"),
    (["calcium carbonate", "кальция карбонат", "карбонат кальция", "caco3"],
        "CaCO3", "471-34-1", "кальция карбонат", "Calcium carbonate"),
    (["magnesium chloride", "магния хлорид", "хлорид магния", "mgcl2"],
        "MgCl2", "7786-30-3", "магния хлорид", "Magnesium chloride"),
    (["magnesium sulfate", "магния сульфат", "сульфат магния", "mgso4"],
        "MgSO4", "7487-88-9", "магния сульфат", "Magnesium sulfate"),
    (["ethanol", "этанол", "спирт этиловый", "этиловый спирт"],
        "C2H5OH", "64-17-5", "этанол", "Ethanol"),
    (["methanol", "метанол", "метиловый спирт"],
        "CH3OH", "67-56-1", "метанол", "Methanol"),
    (["isopropanol", "изопропанол", "изопропиловый спирт"],
        "C3H8O", "67-63-0", "изопропанол", "Isopropanol"),
    (["acetone", "ацетон"],
        "C3H6O", "67-64-1", "ацетон", "Acetone"),
    (["hydrochloric acid", "соляная кислота", "хлористоводородная кислота", "hcl"],
        "HCl", "7647-01-0", "соляная кислота", "Hydrochloric acid"),
    (["sulfuric acid", "серная кислота", "h2so4"],
        "H2SO4", "7664-93-9", "серная кислота", "Sulfuric acid"),
    (["nitric acid", "азотная кислота", "hno3"],
        "HNO3", "7697-37-2", "азотная кислота", "Nitric acid"),
    (["acetic acid", "уксусная кислота"],
        "CH3COOH", "64-19-7", "уксусная кислота", "Acetic acid"),
    (["glycerol", "glycerin", "глицерин"],
        "C3H8O3", "56-81-5", "глицерин", "Glycerol"),
    (["formaldehyde", "формальдегид", "формалин"],
        "CH2O", "50-00-0", "формальдегид", "Formaldehyde"),
    (["edta", "этилендиаминтетрауксусная"],
        "C10H16N2O8", "60-00-4", "этилендиаминтетрауксусная кислота (ЭДТА)", "EDTA"),
    (["tris", "трис буфер", "tris-hcl", "трис-hcl"],
        "C4H11NO3", "77-86-1", "трис (гидроксиметил) аминометан", "Tris base"),
    (["glucose", "глюкоза", "dextrose"],
        "C6H12O6", "50-99-7", "глюкоза", "Glucose"),
    (["albumin", "альбумин", "bsa"],
        None, "9048-46-8", "альбумин бычий сывороточный", "Bovine serum albumin (BSA)"),
    (["glutaraldehyde", "глутаральдегид"],
        "C5H8O2", "111-30-8", "глутаральдегид", "Glutaraldehyde"),
    (["phenol", "фенол"],
        "C6H5OH", "108-95-2", "фенол", "Phenol"),
    (["chloroform", "хлороформ"],
        "CHCl3", "67-66-3", "хлороформ", "Chloroform"),
    (["dmso", "диметилсульфоксид"],
        "C2H6OS", "67-68-5", "диметилсульфоксид", "Dimethyl sulfoxide (DMSO)"),
    (["agar", "агар"],
        None, "9002-18-0", "агар", "Agar"),
    (["agarose", "агароза"],
        None, "9012-36-6", "агароза", "Agarose"),
    (["trypsin", "трипсин"],
        None, "9002-07-9", "трипсин", "Trypsin"),
    (["penicillin", "пенициллин"],
        None, "61-33-6", "пенициллин", "Penicillin"),
    (["streptomycin", "стрептомицин"],
        None, "57-92-9", "стрептомицин", "Streptomycin"),
]

def enrich_reagent(name: str):
    """Ищет совпадение по подстроке в справочнике и возвращает (formula, cas, name_ru, name_en)."""
    if not name:
        return None, None, None, None
    low = name.lower()
    for keywords, formula, cas, name_ru, name_en in REAGENT_DB:
        for kw in keywords:
            if kw in low:
                return formula, cas, name_ru, name_en
    return None, None, None, None


# ──────────────────────────────────────────────────────────────────────────
# 2. ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
# ──────────────────────────────────────────────────────────────────────────

def clean(v):
    if pd.isna(v):
        return None
    s = str(v).strip()
    return s if s and s.lower() != "nan" else None


def parse_room_cabinet(raw_location: str):
    """
    Разбирает строку вида 'ком. 309', 'каб. 306', '308' на (room, cabinet).
    """
    if not raw_location:
        return None, None
    s = raw_location.strip()
    m = re.search(r"(\d+[а-яА-Яa-zA-Z]?)", s)
    room = m.group(1) if m else s
    return room, None


def get_or_create_location(db, room, cabinet=None, shelf=None, slot=None):
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


def insert_item(db, *, item_type, name, formula=None, cas=None, name_ru=None,
                 name_en=None, manufacturer=None, catalog_number=None,
                 inventory_number=None, serial_number=None, quantity=None,
                 unit=None, notes=None, location_id=None, source_file=None,
                 source_sheet=None, internal_code=None):
    if not name:
        return None

    if formula is None and cas is None and item_type == "reagent":
        f, c, nr, ne = enrich_reagent(name)
        formula = formula or f
        cas = cas or c
        name_ru = name_ru or nr
        name_en = name_en or ne

    row = db.execute(
        text("""
            INSERT INTO items (
                item_type, internal_code, name, name_ru, name_en, formula, cas,
                manufacturer, catalog_number, inventory_number, serial_number,
                quantity, unit, notes, source_file, source_sheet, location_id
            ) VALUES (
                :item_type, :internal_code, :name, :name_ru, :name_en, :formula, :cas,
                :manufacturer, :catalog_number, :inventory_number, :serial_number,
                :quantity, :unit, :notes, :source_file, :source_sheet, :location_id
            )
            RETURNING id
        """),
        {
            "item_type": item_type,
            "internal_code": internal_code,
            "name": name,
            "name_ru": name_ru,
            "name_en": name_en,
            "formula": formula,
            "cas": cas,
            "manufacturer": manufacturer,
            "catalog_number": catalog_number,
            "inventory_number": inventory_number,
            "serial_number": serial_number,
            "quantity": str(quantity) if quantity is not None else None,
            "unit": unit,
            "notes": notes,
            "source_file": source_file,
            "source_sheet": source_sheet,
            "location_id": location_id,
        },
    ).fetchone()
    item_id = row[0]
    update_search_vector(db, item_id)
    return item_id


def update_search_vector(db, item_id):
    db.execute(
        text("""
            UPDATE items
            SET search_vector =
                to_tsvector('russian',
                    coalesce(name,'') || ' ' ||
                    coalesce(name_ru,'') || ' ' ||
                    coalesce(notes,'')) ||
                to_tsvector('english',
                    coalesce(name,'') || ' ' ||
                    coalesce(name_en,'') || ' ' ||
                    coalesce(formula,'') || ' ' ||
                    coalesce(cas,'') || ' ' ||
                    coalesce(internal_code,'') || ' ' ||
                    coalesce(manufacturer,'') || ' ' ||
                    coalesce(catalog_number,''))
            WHERE id = :item_id
        """),
        {"item_id": item_id},
    )


# ──────────────────────────────────────────────────────────────────────────
# 3. ПАРСЕРЫ ПО КОНКРЕТНЫМ ФАЙЛАМ / ЛИСТАМ
# ──────────────────────────────────────────────────────────────────────────

def import_reviziia_laby(db, filename="Reviziia-Laby-IBSiB-3-2.xlsx"):
    """Лист 'Реактивы по шкафам' — реактивы/расходники по шкафам и полкам."""
    xl = pd.ExcelFile(filename)
    count = 0

    if "Реактивы по шкафам" in xl.sheet_names:
        df = xl.parse("Реактивы по шкафам", header=None)
        current_cabinet = None
        for _, row in df.iloc[1:].iterrows():
            cabinet_cell = clean(row[0])
            shelf_cell = clean(row[1])
            name = clean(row[2])
            manufacturer = clean(row[3])
            qty = clean(row[4])
            notes = clean(row[5])
            if cabinet_cell:
                current_cabinet = cabinet_cell
            if not name:
                continue
            loc_id = get_or_create_location(db, room="IBSiB-3-2", cabinet=current_cabinet, shelf=shelf_cell)
            insert_item(
                db, item_type="reagent", name=name, manufacturer=manufacturer,
                quantity=qty, notes=notes, location_id=loc_id,
                source_file=filename, source_sheet="Реактивы по шкафам",
            )
            count += 1

    if "Холодильник 2" in xl.sheet_names:
        df = xl.parse("Холодильник 2", header=None)
        current_shelf = None
        for _, row in df.iloc[1:].iterrows():
            name = clean(row[0])
            volume = clean(row[1])
            manufacturer = clean(row[2])
            qty = clean(row[3])
            if name and ("полка" in name.lower() or "верх" in name.lower() or "низ" in name.lower()):
                current_shelf = name
                continue
            if not name:
                continue
            loc_id = get_or_create_location(db, room="Холодильник 2", shelf=current_shelf)
            insert_item(
                db, item_type="reagent", name=name, manufacturer=manufacturer,
                quantity=qty, unit=volume, location_id=loc_id,
                source_file=filename, source_sheet="Холодильник 2",
            )
            count += 1

    if "Холодильники в раздевалке" in xl.sheet_names:
        df = xl.parse("Холодильники в раздевалке", header=None)
        # Свободная сетка: собираем все непустые текстовые ячейки как отдельные позиции
        for _, row in df.iloc[3:].iterrows():
            for col_idx in range(1, df.shape[1]):
                val = clean(row[col_idx])
                if not val or len(val) < 2:
                    continue
                if val.lower() in ("nan",):
                    continue
                loc_id = get_or_create_location(db, room="Раздевалка", cabinet=f"Холодильник (кол.{col_idx})")
                insert_item(
                    db, item_type="reagent", name=val, location_id=loc_id,
                    source_file=filename, source_sheet="Холодильники в раздевалке",
                )
                count += 1

    print(f"[{filename}] импортировано записей: {count}")
    return count


def import_sklad(db, filename="inventarizatsiia-sklada.xlsx"):
    """Листы расходников/пластика со складской структурой."""
    xl = pd.ExcelFile(filename)
    count = 0

    for sheet in ["расходники клеточные", "расходники пластик"]:
        if sheet not in xl.sheet_names:
            continue
        df = xl.parse(sheet, header=1)
        loc_id = get_or_create_location(db, room="Склад", cabinet=sheet)
        for _, row in df.iterrows():
            name = clean(row.get("Наименование"))
            if not name:
                continue
            manufacturer = clean(row.get("Производитель"))
            catalog_number = clean(row.get("Каталожный номер/артикул"))
            qty_units = clean(row.get("Кол-во единиц"))
            insert_item(
                db, item_type="consumable", name=name, manufacturer=manufacturer,
                catalog_number=catalog_number, quantity=qty_units,
                location_id=loc_id, source_file=filename, source_sheet=sheet,
            )
            count += 1

    if "Склад 108а" in xl.sheet_names:
        df = xl.parse("Склад 108а", header=0)
        loc_id = get_or_create_location(db, room="108а", cabinet="Склад 108а")
        for _, row in df.iterrows():
            name = clean(row.get("Название"))
            if not name:
                continue
            qty = clean(row.get("Остаток коробок"))
            insert_item(
                db, item_type="consumable", name=name, quantity=qty,
                location_id=loc_id, source_file=filename, source_sheet="Склад 108а",
            )
            count += 1

    print(f"[{filename}] импортировано записей: {count}")
    return count


def import_inventarizatsiia_lab123(db, filename="Inventarizatsiia-laboratorii-1-2-3.xlsx"):
    """Оборудование, реактивы (306/308/-20 310), расходники, мебель."""
    xl = pd.ExcelFile(filename)
    count = 0

    # ── Оборудование и мебель: одинаковая структура ─────────────────────
    for sheet, item_type in [("Оборудование", "equipment"), ("Мебель", "furniture")]:
        if sheet not in xl.sheet_names:
            continue
        df = xl.parse(sheet, header=0)
        for _, row in df.iterrows():
            name = clean(row.get("Основное средство"))
            if not name:
                continue
            inv_number = clean(row.get("Инвентарный номер"))
            serial_number = clean(row.get("Заводской номер"))
            location_raw = clean(row.get("Местоположение"))
            qty = clean(row.get("Количество"))
            room, cabinet = parse_room_cabinet(location_raw)
            loc_id = get_or_create_location(db, room=room or "Без комнаты", cabinet=cabinet)
            insert_item(
                db, item_type=item_type, name=name, inventory_number=inv_number,
                serial_number=serial_number, quantity=qty, location_id=loc_id,
                source_file=filename, source_sheet=sheet,
            )
            count += 1

    # ── Реактивы по комнатам (306, 308, -20 в 310) ──────────────────────
    for sheet, room_label in [
        ("Реактивы КТ (306)", "306"),
        ("Реактивы КТ (308)", "308"),
        ("Реактивы -20 (310)", "310"),
    ]:
        if sheet not in xl.sheet_names:
            continue
        df = xl.parse(sheet, header=1)
        for _, row in df.iterrows():
            # первая колонка после заголовка — название реактива
            name_col = [c for c in df.columns if "реактив" in str(c).lower()]
            name = clean(row.get(name_col[0])) if name_col else None
            if not name:
                continue
            where_col = [c for c in df.columns if "где лежит" in str(c).lower()]
            where = clean(row.get(where_col[0])) if where_col else None
            qty_cols = [c for c in df.columns if "колличес" in str(c).lower() or "количество" in str(c).lower()]
            qty = clean(row.get(qty_cols[0])) if qty_cols else None
            notes_col = [c for c in df.columns if "примечан" in str(c).lower()]
            notes = clean(row.get(notes_col[0])) if notes_col else None

            loc_id = get_or_create_location(db, room=room_label, shelf=where)
            insert_item(
                db, item_type="reagent", name=name, quantity=qty, notes=notes,
                location_id=loc_id, source_file=filename, source_sheet=sheet,
            )
            count += 1

    # ── Расходники (пластик / клетки) ───────────────────────────────────
    for sheet in ["Расходный пластик ", "Расходник клетки"]:
        if sheet not in xl.sheet_names:
            continue
        df = xl.parse(sheet, header=1)
        name_col = [c for c in df.columns if "пластик" in str(c).lower()]
        for _, row in df.iterrows():
            name = clean(row.get(name_col[0])) if name_col else None
            if not name:
                continue
            total_col = [c for c in df.columns if "итого" in str(c).lower()]
            qty = clean(row.get(total_col[0])) if total_col else None
            where_col = [c for c in df.columns if "лежит" in str(c).lower()]
            where = clean(row.get(where_col[0])) if where_col else None

            loc_id = get_or_create_location(db, room="Лаборатория 1-2-3", cabinet=where)
            insert_item(
                db, item_type="consumable", name=name, quantity=qty,
                location_id=loc_id, source_file=filename, source_sheet=sheet,
            )
            count += 1

    print(f"[{filename}] импортировано записей: {count}")
    return count


# ──────────────────────────────────────────────────────────────────────────
# 4. ТОЧКА ВХОДА
# ──────────────────────────────────────────────────────────────────────────

def main():
    print("Инициализация базы данных...")
    init_db()

    db = SessionLocal()
    total = 0
    try:
        total += import_reviziia_laby(db, filename="Reviziia-Laby-IBSiB-3.xlsx")
        total += import_sklad(db, filename="inventarizatsiia-sklada.xlsx")
        total += import_inventarizatsiia_lab123(db, filename="Inventarizatsiia-laboratorii-1-2.xlsx")
        db.commit()
        print(f"\nГотово! Всего импортировано записей: {total}")
    except Exception as e:
        db.rollback()
        print(f"Ошибка импорта, все изменения отменены: {e}")
        raise
    finally:
        db.close()