import sqlite3

db_path = r"c:\Users\hp\Desktop\CODES\AMHARICQUR\assets\database\book.db"
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Get tables
cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
tables = cursor.fetchall()
print("Tables:")
for table in tables:
    print(f"  - {table[0]}")
    
# Get row counts
print("\nRow counts:")
for table in tables:
    table_name = table[0]
    if not table_name.startswith('sqlite_'):
        cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
        count = cursor.fetchone()[0]
        print(f"  {table_name}: {count} rows")

# Show sample from paragraphs
print("\nSample from paragraphs table (first 3 rows):")
cursor.execute("SELECT * FROM paragraphs LIMIT 3")
rows = cursor.fetchall()
for row in rows:
    print(f"  {row}")

conn.close()
