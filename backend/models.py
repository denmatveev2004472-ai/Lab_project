from sqlalchemy import (
    Column, Integer, Text, ForeignKey, TIMESTAMP, Index,
    UniqueConstraint
)
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import TSVECTOR
from sqlalchemy.sql import func

from database import Base


class Location(Base):
    __tablename__ = "locations"

    id      = Column(Integer, primary_key=True, index=True)
    room    = Column(Text, nullable=False)
    cabinet = Column(Text, default="-", server_default="-")
    shelf   = Column(Text, default="-", server_default="-")
    slot    = Column(Text, default="-", server_default="-")

    # Уникальность по комбинации полей — ровно как в schema-2.sql
    __table_args__ = (
        UniqueConstraint("room", "cabinet", "shelf", "slot",
                         name="locations_room_cabinet_shelf_slot_key"),
    )

    # Обратная связь: список предметов в этой локации
    items = relationship("Item", back_populates="location")


class Item(Base):
    __tablename__ = "items"

    id               = Column(Integer, primary_key=True, index=True)
    item_type        = Column(Text, nullable=False, default="other", server_default="other")
    internal_code    = Column("internal_code", Text, nullable=True)   # поле code в API → internal_code в БД
    name             = Column(Text, nullable=True)
    name_ru          = Column(Text, nullable=True)
    name_en          = Column(Text, nullable=True)
    formula          = Column(Text, nullable=True)
    cas              = Column(Text, nullable=True)
    manufacturer     = Column(Text, nullable=True)
    catalog_number   = Column(Text, nullable=True)
    inventory_number = Column(Text, nullable=True)
    serial_number    = Column(Text, nullable=True)
    registry_number  = Column(Text, nullable=True)
    quantity         = Column(Text, nullable=True)
    unit             = Column(Text, nullable=True)
    status           = Column(Text, nullable=True)
    notes            = Column(Text, nullable=True)
    source_file      = Column(Text, nullable=True)
    source_sheet     = Column(Text, nullable=True)
    location_id      = Column(Integer, ForeignKey("locations.id", ondelete="SET NULL"), nullable=True)
    search_vector    = Column(TSVECTOR, nullable=True)
    created_at       = Column(TIMESTAMP, server_default=func.now())
    updated_at       = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

    # Связь с таблицей локаций
    location = relationship("Location", back_populates="items")

    __table_args__ = (
        Index("idx_items_location_id",   "location_id"),
        Index("idx_items_type",          "item_type"),
        Index("idx_items_search_vector", "search_vector", postgresql_using="gin"),
        Index("idx_items_inventory_number", "inventory_number"),
        Index("idx_items_catalog_number",   "catalog_number"),
    )