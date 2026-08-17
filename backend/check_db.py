from dotenv import load_dotenv
import os

load_dotenv(override=True)

keys = ("PGUSER", "PGPASSWORD", "PGHOST", "PGPORT", "PGDATABASE")
values = [os.getenv(key, "") for key in keys]

url = "postgresql+psycopg2://{}:{}@{}:{}/{}".format(*values)

print("URL:", url.replace(values[1], "***"))
print("URL length:", len(url))
print("Non-ASCII:", [(i, hex(ord(ch))) for i, ch in enumerate(url) if ord(ch) > 127])
print("DATABASE_URL set:", bool(os.getenv("DATABASE_URL")))
