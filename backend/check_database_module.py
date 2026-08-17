import database

url = database.DATABASE_URL
password = url.split("://", 1)[1].split("@", 1)[0].split(":", 1)[1]

print("URL from database.py:", url.replace(password, "***"))
print("URL length:", len(url))
print("Non-ASCII:", [(i, hex(ord(ch))) for i, ch in enumerate(url) if ord(ch) > 127])
