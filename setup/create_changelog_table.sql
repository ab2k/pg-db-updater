create table if not exists pg_db_updater_changelog
(
  file_hash char(128) not null constraint pg_db_updater_changelog_pk primary key,
  file_name varchar not null,
  date_time timestamp with time zone default now() not null
);
alter table pg_db_updater_changelog owner to session_user;
create unique index if not exists pg_db_updater_changelog_file_hash_uindex on pg_db_updater_changelog (file_hash);
