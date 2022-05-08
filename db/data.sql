CREATE EXTENSION IF NOT EXISTS pgcrypto;
INSERT INTO Writer (name, surname, password) VALUES ('Emanuel', 'Vollmer', crypt('superSecret', gen_salt('bf', 8)));

INSERT INTO Blogpost (title, content, blogpost_type, writer_id)
VALUES (
        'Graphql',
        'Graphql is a query language...',
        'Technical',
        (
            SELECT id
            FROM Writer
            WHERE name = 'Emanuel'
        )
    )