# PG DB Updater
Lightweight database updater and update modification tracker for PostgreSQL family databases.

## Overview
* `PG DB Updater` will keep track of every database update you apply with it.
* `PG DB Updater` uses a special service table and the `sha512sum` utility to calculate the checksum of each applied update file, so you are almost guaranteed to install this update only once. In this way, you no longer have to remember whether you applied this particular update to this particular database or not.
* `PG DB Updater` is very easy to install and configure, it only needs a few utilities and you may already have them installed - `bash`, `sha512sum` and `psql`. To install the script, simply clone this repository, install security certificates for connecting to the database if necessary, and edit the settings file.
* `PG DB Updater` does not require any fancy strategy for storing database update files. You can store all files in the `sources` folder, or you can group them by specific tasks and organize them into separate subfolders in the `sources` folder. Be sure to number the update files so that there is no confusion when applying them, for example, do not try to populate a table with values before creating the table itself. Please note that the script sorts files by name, so it is recommended to specify the run number with leading zeros at the beginning of the file name.
* While running, `PG DB Updater` will inform you of every action it takes, showing you the results of applying the database update file.
* If an error will be found, the script will stop.

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
