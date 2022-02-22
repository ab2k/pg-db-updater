# PG DB Updater
Lightweight database updater and modification tracker for PostgreSQL family databases.

## Overview
* `PG DB Updater` will keep track of every database update you apply with it.
* `PG DB Updater` uses a special service table and the `sha512sum` utility to calculate the checksum of each applied update file, so you are almost guaranteed to install this update only once. In this way, you no longer have to remember whether you applied this particular update to this particular database or not.
* `PG DB Updater` is very easy to install and configure, it only needs a few utilities and you may already have them installed - `bash`, `sha512sum` and `psql`. To install the script, simply clone this repository, install security certificates for connecting to the database if necessary, and edit the settings file. You can also set options from the command line which will take precedence.
* `PG DB Updater` does not require any fancy strategy for storing database update files. You can store files in one folder or organize them by specific tasks and sort them into different folders with the task name. Remember to number the update files so that there is no confusion when applying them, for example, the table is filled with values before the table itself is created.
* While running `PG DB Updater` will inform you about every action it is taking.

## Usage
```
./pg_db_updater.sh [--db my_database_name] [--dry-run]
```
>`--db`<br />
>This argument will give you the option to specify the name of the database. It will take precedence over the configured value in the configuration file.

>`--dry-run`<br />
>This flag will disable application of updates. A complete list of update files and their application status will be displayed. It will take precedence over the configured value in the configuration file.

## Requirements
* GNU `Bash` (tested with: 4.1.2, 4.2.46, 4.4.20, 5.0.17).
* GNU coreutils `sha512sum` (tested with: 8.4, 8.22, 8.30).
* PostgreSQL `psql` utility (tested with: 9.6.24, 12.10, 13.4, 14.2).

## License
PG DB Updater is licensed under the GNU General Public License version 3. A copy of this license can be found [here](https://github.com/ab2k/pg-db-updater/blob/main/LICENSE).

## Copyright
Copyright (C) 2022 Andrey Bolshakov
