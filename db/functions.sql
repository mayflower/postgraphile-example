DROP FUNCTION writer_number_of_authored_posts(writer_in writer);
CREATE FUNCTION writer_number_of_authored_posts(writer_in writer) RETURNS INT
    STABLE
    LANGUAGE SQL AS

$$
SELECT COUNT(id)
FROM blogpost
WHERE writer_id = writer_in.id
$$;
COMMENT ON FUNCTION writer_number_of_authored_posts(writer_in writer) is E'@sortable\n@filterable';

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

DROP FUNCTION writer_job(writer);
CREATE FUNCTION writer_job(writer_in writer, job_in TEXT) RETURNS TEXT
    STABLE
    LANGUAGE SQL AS
$$
SELECT COALESCE(writer_in.nickname, writer_in.name) || ' is a ' || job_in ||
       ' working at Mayflower!'
$$;


DROP FUNCTION writer_register(text, text, text, text);
CREATE FUNCTION writer_register(name text, lastname text,
                            password text,
                                nickname text = NULL
) RETURNS writer
    VOLATILE
    LANGUAGE plpgsql AS
$$
DECLARE
    result writer;
BEGIN
    IF (SELECT EXISTS(SELECT 1
                      FROM writer w
                      WHERE w.name = writer_register.name
                        AND w.surname = writer_register.lastname)) THEN
        RAISE EXCEPTION 'Writer with the same name and lastname already exists!';
    END IF;

    IF (LENGTH(writer_register.password) < 8) THEN
        RAISE EXCEPTION 'Password is not strong enough! Should be at least 8 characters long!';
    END IF;

    INSERT INTO writer (name, surname, nickname, password)
    VALUES (writer_register.name, writer_register.lastname,
            writer_register.nickname,
            crypt(writer_register.password, gen_salt('bf', 8)))
    RETURNING * INTO result;

    RETURN result;
END
$$;