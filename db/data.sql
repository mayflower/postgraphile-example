INSERT INTO Writer (name, surname)
VALUES ('Emanuel', 'Vollmer');
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