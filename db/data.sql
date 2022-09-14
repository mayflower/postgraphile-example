CREATE EXTENSION IF NOT EXISTS pgcrypto;
INSERT INTO Writer (name, surname, email, password)
VALUES ('Emanuel', 'Vollmer', 'bar@baz.com', crypt('superSecret', gen_salt('bf', 8)));
INSERT INTO Writer (name, surname, nickname, email, password)
VALUES ('Thomas', 'Blank', 'Blanky', 'foo@bar.com', crypt('superSecret', gen_salt('bf', 8)));

INSERT INTO blogpost (title, content, blogpost_type, writer_id)
VALUES ('Extending Schema Definitions in Postgraphile',
        'SmartTags are great!...',
        'Technical',
        (SELECT id FROM Writer where nickname = 'Blanky'));

INSERT INTO Blogpost (title, content, blogpost_type, writer_id)
VALUES ('Graphql',
        'Graphql is a query language...',
        'Technical',
        (
            SELECT id
            FROM Writer
            WHERE name = 'Emanuel'
        ));

INSERT INTO Blogpost (title, content, blogpost_type, writer_id)
VALUES ('RLS - Row Level Security',
        'Better save than sorry...',
        'Technical',
        (
            SELECT id
            FROM Writer
            WHERE name = 'Emanuel'
        ));