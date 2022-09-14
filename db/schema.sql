CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE ROLE graphile LOGIN PASSWORD 'graphile';

DROP TABLE IF EXISTS Writer CASCADE;
DROP TABLE IF EXISTS Blogpost CASCADE;

DROP TYPE IF EXISTS BLOGPOST_ENUM;
CREATE TYPE BLOGPOST_ENUM AS ENUM ('Technical', 'Agile');

CREATE TABLE Writer
(
    id       SERIAL PRIMARY KEY,
    name     TEXT NOT NULL,
    surname  TEXT NOT NULL,
    email    TEXT NOT NULL UNIQUE CHECK (email ~* '^.+@.+\..+$'),
    nickname TEXT,
    password TEXT NOT NULL
);

comment on column Writer.nickname is E'@deprecated Use name instead.';
comment on column Writer.surname is E'@name lastname';
comment on column Writer.password is E'@omit create,read,update,delete,all,many';
comment on table writer is E'@omit create';

CREATE TABLE Blogpost
(
    id            SERIAL PRIMARY KEY,
    title         TEXT          NOT NULL,
    content       TEXT          NOT NULL,
    blogpost_type BLOGPOST_ENUM NOT NULL,
    writer_id     SERIAL REFERENCES Writer (id)
);

CREATE TYPE jwt_token as
(
    role      text,
    writer_id integer,
    exp       bigint
);
