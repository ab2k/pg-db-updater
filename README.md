# PG DB Updater
Lightweight modification tracker for PostgreSQL family databases

## Usage:
```
./pg_db_updater.sh [--db my_database_name] [--dry-run]

  --db        this option will set the name of the database to which updates will be applied.
  --dry-run   if this option is used, no updates will be applied, only a list of updates and their status will be displayed.
```

## Requirements:
bash (tested on 4.1.2, 4.2.46, 4.4.20, 5.0.17).
sha512sum (tested on 8.4, 8.22, 8.30).
psql (tested on 9.6, 12, 13, 14).
