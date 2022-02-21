#!/usr/bin/env bash

# if this option is set to "1", then no updates will be applied, only a list of updates and their status will be displayed.
export DRY_RUN=0

# specifies mask of the database update script files
export DB_SCRIPT_FILE_MASK="*.sql"

# specifies database name (only need to be specified if argument is not used)
export PGDATABASE=""

# pid file location
export PID_FILE="./pg_db_updater.pid"

# specifies application name used to connect to database
export PGAPPNAME="PG-DB-Updater 0.1.0"

# connection options if defaults are not used and there is no ~/.pgpass file to store authentication data.
# for complete list of options, see the documentation: https://www.postgresql.org/docs/9.6/libpq-envars.html

# specifies database server host
# export PGHOST=localhost

# specifies database server address
# export PGHOSTADDR=127.0.0.1

# specifies database server port
# export PGPORT=5432

# specifies database user
# export PGUSER=

# specifies database user password
# export PGPASSWORD=

# specifies the location of the SSL/TLS client certificate file
# export PGSSLCERT="./certificates/client.crt"

# specifies the location of the SSL/TLS private key file used for the SSL/TLS client certificate
# export PGSSLKEY="./certificates/client.key"

# specifies the location of the SSL/TLS certificate authority (CA) certificate file
# export PGSSLROOTCERT="./certificates/ca.crt"
