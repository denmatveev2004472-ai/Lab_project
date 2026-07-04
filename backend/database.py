from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker, DeclarativeBase
import os
from dotenv import load_dotenv

load_dotenv()

PGHOST     = os.environ.get("PGHOST", "localhost")
PGPORT     = os.environ.get("PGPORT", "5432")
PGDATABASE = os.environ.get("PGDATABASE", "lab_chemicals")
PGUSER     = os.environ.get("PGUSER", "postgres")
PGPASSWORD = os.environ.get("PGPASSWORD", "")

DATABASE_URL = (
    f"postgresql+psycopg2://postgres:FUDwjyoIWepFOkQxlZeVMFdtdHZkNBmn"
    f"@shinkansen.proxy.rlwy.net:29064/railway"
)

engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,   # проверяет соединение перед использованием
    pool_size=10,
    max_overflow=20,
    echo=False,           # поставь True для отладки SQL-запросов
)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine,
)


class Base(DeclarativeBase):
    pass


def get_db():
    """
    Dependency для FastAPI: открывает сессию и гарантирует её закрытие.
    Использование: db: Session = Depends(get_db)
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def init_db():
    """
    Создаёт все таблицы и расширения при первом запуске.
    Вызывается из @app.on_event('startup').
    """
    with engine.connect() as conn:
        conn.execute(text("CREATE EXTENSION IF NOT EXISTS pg_trgm"))
        conn.commit()

    # Импортируем модели ПОСЛЕ объявления Base, чтобы SQLAlchemy их видел
    from models import Location, Item  # noqa: F401
    Base.metadata.create_all(bind=engine)