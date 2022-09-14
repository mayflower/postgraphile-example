CREATE ROLE anonymous;
GRANT anonymous TO graphile;

CREATE ROLE writer_role;
GRANT writer_role TO graphile;

ALTER TABLE writer
    ENABLE ROW LEVEL SECURITY;
ALTER TABLE blogpost
    ENABLE ROW LEVEL SECURITY;

GRANT USAGE ON SCHEMA public TO anonymous, writer_role;
GRANT SELECT ON TABLE writer TO anonymous, writer_role;
GRANT SELECT ON TABLE blogpost TO anonymous, writer_role;

CREATE POLICY select_writer ON writer FOR SELECT USING (true);
CREATE POLICY select_blogpost ON blogpost FOR SELECT USING (true);

GRANT EXECUTE ON FUNCTION writer_register(text, text, text, text, text) TO anonymous;

GRANT UPDATE, DELETE ON TABLE writer TO writer_role;

CREATE POLICY update_writer ON writer FOR UPDATE TO writer_role
    USING (id = current_setting('jwt.claims.writer_id', true)::integer);

CREATE POLICY delete_writer ON writer FOR DELETE TO writer_role
    USING (id = current_setting('jwt.claims.writer_id', true)::integer);

-- CREATE POLICY readers ON blogpost TO anonymous;
GRANT INSERT, UPDATE, DELETE ON TABLE blogpost TO writer_role;

GRANT USAGE ON SEQUENCE blogpost_writer_id_seq to writer_role;
GRANT USAGE ON SEQUENCE blogpost_id_seq to writer_role;

CREATE POLICY insert_blogpost ON blogpost FOR INSERT TO writer_role
    WITH CHECK (writer_id =
                current_setting('jwt.claims.writer_id', true)::integer);

CREATE POLICY update_blogpost ON blogpost FOR UPDATE TO writer_role
    USING (writer_id = current_setting('jwt.claims.writer_id', true)::integer);

CREATE POLICY delete_blogpost ON blogpost FOR DELETE TO writer_role
    USING (writer_id = current_setting('jwt.claims.person_id', true)::integer);
