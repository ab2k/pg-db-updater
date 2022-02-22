#!/usr/bin/env bash

# Copyright (C) 2022 Andrey Bolshakov
# https://github.com/ab2k/pg-db-updater

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# maybe any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -o errexit
if [ -f "./pg_db_updater_config.sh" ]; then
  source ./pg_db_updater_config.sh
else
  echo -e "\nThere is no ./pg_db_updater_config.sh file found. Exiting.\n"
  exit 1
fi
while (( "$#" )); do
  case $1 in
    --dry-run) DRY_RUN=1; shift ;;
    --db) if [ "$2" ] && [ "$2" != "--dry-run" ]; then PGDATABASE="$2"; shift 2; else break; fi ;;
    *) shift
  esac
done
set -o nounset
if ! command -v psql >/dev/null 2>&1; then
  echo -e "\sPG DB Updater needs the psql command to make changes to the database, but it doesn't seem to be installed.\nExiting.\n"
  exit 1
fi
if ! command -v sha512sum >/dev/null 2>&1; then
  echo -e "\sPG DB Updater uses the sha512sum application to check the status of applied updates, but it doesn't seem to be installed.\nExiting.\n"
  exit 1
fi
if [ -z "${PGDATABASE}" ]; then
  echo -e "\nPG DB Updater needs a database name to continue.\nYou can set it up in a config file or provide it as an option.\n\nUsage: ./pg_db_updater.sh [--db my_database_name] [--dry-run]\n\n    --db        this option will set the name of the database to which updates will be applied.\n    --dry-run   if this option is used, no updates will be applied, only a list of updates and their status will be displayed.\n"
  exit 1
fi
if [ -f "${PID_FILE}" ]; then
  PID=$(cat "${PID_FILE}")
  if [[ "${PID}" =~ ^[0-9]+$ ]] && ps -p "${PID}" > /dev/null 2>&1; then
    echo -e "\nPG DB Updater is already running. PID file (${PID_FILE}) and process (${PID}) exists.\nExiting.\n"
    exit 1
  fi
fi
echo $$ > "${PID_FILE}"
declare -r SINGLE_QUOTE_ESCAPE="''"
echo -e "\n.- Starting PG DB Updater..."
echo "|- Current date and time: $(date)."
echo "|- Database for applying updates: ${PGDATABASE}."
echo "|- Checking the database connection and the required changelog table:"
if psql --set ON_ERROR_STOP=on -f "./setup/create_changelog_table.sql" > /dev/null 2>&1; then
  echo "|= SUCCESS: database (${PGDATABASE}) is available and the required table exists or has just been created."
else
  echo "|= FAIL: database (${PGDATABASE}) is not accessible and/or setup file is missing."
  echo -e "'- Exiting.\n"
  exit 1
fi
echo "|- Finding task directories in the source directory..."
for TASK in $( find ./sources -mindepth 1 -maxdepth 1 -type d  | sort -n )
do
  NUM_OF_FILES=$( find "${TASK}" -type f -iname "${DB_SCRIPT_FILE_MASK}" | wc -l )
  if (( NUM_OF_FILES > 0 )); then
    echo "|= FOUND: ${TASK} directory with ${NUM_OF_FILES} database update files."
  fi
done
if (( DRY_RUN == 1 )); then
  echo "|- INFO: dry run option is in effect. The database will not be updated."
fi
echo "'- Finished summary routine, starting applying procedure..."
find ./sources -type f -iname "${DB_SCRIPT_FILE_MASK}" -print0 | sort -z | while read -r -d $'\0' SCRIPT_NAME
do
  echo -e "\n.- Found database script file: ${SCRIPT_NAME}..."
  if FILE_HASH=$( sha512sum --binary "${SCRIPT_NAME}" | sed 's/\ \*.*$//g' ); then
    echo "|= Hashed content: ${FILE_HASH}"
  else
    echo -e "'- Can't get hash of ${SCRIPT_NAME} file content. Exiting.\n"
    exit 1
  fi
  DB_QUERY_RESULT=$( psql --set ON_ERROR_STOP=on -At -c "SELECT COUNT(1) FROM pg_db_updater_changelog WHERE file_hash = '${FILE_HASH}'" )
  if (( DB_QUERY_RESULT == 1 )); then
    echo "|= The hash for the content of the file was found in the database. Getting saved filename, applied date and time from database:"
    DB_QUERY_RESULT=$( psql --set ON_ERROR_STOP=on -At -c "SELECT file_name FROM pg_db_updater_changelog WHERE file_hash = '${FILE_HASH}'" )
    echo "|= File name from database: ${DB_QUERY_RESULT}."
    if [ "${SCRIPT_NAME}" = "${DB_QUERY_RESULT}" ]; then
      echo "|= The original file name and the applied file name are the same."
    else
      echo "|= The original file name and the applied file name do not match."
    fi
    DB_QUERY_RESULT=$( psql --set ON_ERROR_STOP=on -At -c "SELECT date_time FROM pg_db_updater_changelog WHERE file_hash = '${FILE_HASH}'" )
    echo "|= Date and time the update was applied: ${DB_QUERY_RESULT}."
    echo "|- INFO: applying of this file will not be performed."
  elif (( DB_QUERY_RESULT == 0 )); then
    echo "|= The hash was not found in the database. The database update can be performed."
    if (( DRY_RUN == 0 )); then
      echo "|= Applying database update script file:"
      if psql --set ON_ERROR_STOP=on -f "${SCRIPT_NAME}"; then
        echo "|= SUCCESS: database update applied."
        if psql --set ON_ERROR_STOP=on -At -c "INSERT INTO pg_db_updater_changelog (file_hash, file_name) VALUES ('${FILE_HASH}', '${SCRIPT_NAME//\'/${SINGLE_QUOTE_ESCAPE}}')" > /dev/null 2>&1; then
          echo "|= SUCCESS: updated changelog table in database."
        else
          echo -e "|= FAIL: cannot update changelog table in database. Exiting.\n"
          exit 1
        fi
      else
        echo -e "|= FAIL: cannot apply script file. Exiting.\n"
        exit 1
      fi
    else
      echo "|= INFO: dry run option is in effect. The database will not be updated."
    fi
  else
    echo -e "'- ERROR: ${DB_QUERY_RESULT}.\n"
    exit 1
  fi
  echo "'- Completed file processing."
done
rm "${PID_FILE}"
echo -e "\nPG DB Updater has successfully completed all procedures at: $(date).\n"
exit 0
