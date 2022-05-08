DROP FUNCTION writer_number_of_authored_posts(writer_in writer);
CREATE FUNCTION writer_number_of_authored_posts(writer_in writer) RETURNS INT
    STABLE
    LANGUAGE SQL AS

$$
SELECT COUNT(id)
FROM blogpost
WHERE writer_id = writer_in.id
$$;

DROP FUNCTION blogpost_wirter_display_name(blogpost_in blogpost);
CREATE FUNCTION blogpost_wirter_display_name(blogpost_in blogpost) RETURNS TEXT
    STABLE
    LANGUAGE plpgsql AS
$$
DECLARE
    author writer;
BEGIN
    SELECT *
    FROM writer
    WHERE id = blogpost_in.writer_id
    INTO author;

    IF (author.nickname IS NOT NULL) THEN
        RETURN author.name || ' (' || author.nickname || ') ' ||
               author.surname;
    ELSE
        RETURN author.name || ' ' || author.surname;
    END IF;
END
$$;

CREATE FUNCTION writer_job(writer_in writer, job_in TEXT) RETURNS TEXT
    STABLE
    LANGUAGE SQL AS
$$
    SELECT writer_in.nickname || ' is a ' || job_in || ' working at Mayflower!'
$$;