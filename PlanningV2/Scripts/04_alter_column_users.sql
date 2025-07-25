alter table users ALTER COLUMN  password varchar(256) null
alter table users add domain_user_name [varchar](128) NULL
alter table users add is_win_auth bit NULL
alter table users add is_system_user bit NULL