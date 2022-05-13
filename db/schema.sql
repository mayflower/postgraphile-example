DROP TABLE IF EXISTS Writer CASCADE;
DROP TABLE IF EXISTS Blogpost CASCADE;

DROP TYPE BLOGPOST_ENUM;
CREATE TYPE BLOGPOST_ENUM AS ENUM ('Technical', 'Agile');
CREATE TABLE Writer
(
    id       SERIAL PRIMARY KEY,
    name     TEXT NOT NULL,
    surname  TEXT NOT NULL,
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

