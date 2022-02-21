# PG DB Updater
Lightweight modification tracker for PostgreSQL family databases

## Usage
```
./pg_db_updater.sh [--db my_database_name] [--dry-run]
```
>`--db`<br />
>This argument will give you the option to specify the name of the database. It will take precedence over the configured value in the configuration file.

>`--dry-run`<br />
>This flag will disable application of updates. A complete list of update files and their application status will be displayed. It will take precedence over the configured value in the configuration file.

## Requirements
* GNU Bash (tested versions: 4.1.2, 4.2.46, 4.4.20, 5.0.17).
* GNU coreutils sha512sum (tested versions: 8.4, 8.22, 8.30).
* PostgreSQL psql utility (tested versions: 9.6.24, 12.10, 13.4, 14.2).
