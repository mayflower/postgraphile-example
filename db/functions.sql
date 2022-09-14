DROP FUNCTION IF EXISTS writer_number_of_authored_posts(writer_in writer);
CREATE FUNCTION writer_number_of_authored_posts(writer_in writer) RETURNS INT
    STABLE
    LANGUAGE SQL AS

$$
SELECT COUNT(id)
FROM blogpost
WHERE writer_id = writer_in.id
$$;
COMMENT ON FUNCTION writer_number_of_authored_posts(writer_in writer) is E'@sortable\n@filterable';

DROP FUNCTION IF EXISTS blogpost_wirter_display_name(blogpost_in blogpost);
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

DROP FUNCTION IF EXISTS writer_job(writer, text);
CREATE FUNCTION writer_job(writer_in writer, job_in TEXT) RETURNS TEXT
    STABLE
    LANGUAGE SQL AS
$$
SELECT COALESCE(writer_in.nickname, writer_in.name) || ' is a ' || job_in ||
       ' working at Mayflower!'
$$;


DROP FUNCTION IF EXISTS writer_register(text, text, text, text, text);
CREATE FUNCTION writer_register(name text, lastname text,
                                password text,
                                email text,
                                nickname text = NULL
) RETURNS writer
    STRICT
    SECURITY DEFINER
    LANGUAGE plpgsql AS
$$
DECLARE
    result writer;
BEGIN
    IF (SELECT EXISTS(SELECT 1
                      FROM writer w
                      WHERE w.email = writer_register.email)) THEN
        RAISE EXCEPTION 'Writer with the email address already exists!';
    END IF;

    IF (LENGTH(writer_register.password) < 8) THEN
        RAISE EXCEPTION 'Password is not strong enough! Should be at least 8 characters long!';
    END IF;

    INSERT INTO writer (name, surname, nickname, email, password)
    VALUES (writer_register.name, writer_register.lastname,
            writer_register.nickname,
            writer_register.email,
            crypt(writer_register.password, gen_salt('bf', 8)))
    RETURNING * INTO result;

    RETURN result;
END
$$;


DROP FUNCTION IF EXISTS writer_authenticate(text, text);
CREATE FUNCTION writer_authenticate(email text, password text) RETURNS jwt_token
    LANGUAGE plpgsql AS
$$
DECLARE
    _writer writer;
BEGIN
    SELECT w.* into _writer from writer as w where (w.email) = ($1);

    if _writer.password = crypt($2, _writer.password) then
        return ('writer_role', _writer.id,
                extract(epoch from (now() + interval '2 days')))::jwt_token;
    else
        return null;
    end if;
END ;
$$;


DROP FUNCTION IF EXISTS whoami();
CREATE FUNCTION whoami() RETURNS WRITER AS
$$
SELECT *
FROM WRITER
WHERE id = current_setting('jwt.claims.writer_id', true)::integer
$$ language sql stable;

