-- Write your migrate up statements here
CREATE TABLE products (
    id bigserial PRIMARY KEY,
    name text CHECK (length(name) > 1 AND length(name) < 50),
    description text CHECK (length(name) > 1 AND length(name) < 200),
    -- tsv column is used by full-text search
    -- tsv tsvector GENERATED ALWAYS AS (to_tsvector('english', name) || to_tsvector('english', description)) STORED, -- postgres version > 11
    tsv tsvector,
    tags text[],
    category_ids bigint[] NOT NULL CHECK (cardinality(category_ids) > 0 AND cardinality(category_ids) < 10),
    price numeric(7, 2),
    user_id bigint REFERENCES users (id),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

-- Indices -------------------------------------------------------
CREATE INDEX index_products_on_tsv ON products USING GIN (tsv tsvector_ops);

CREATE INDEX index_products_on_user_id ON products (user_id int8_ops);

CREATE OR REPLACE FUNCTION products_biut ()
    RETURNS TRIGGER
    SET SCHEMA 'public'
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- NEW.tsv := to_tsvector('english', NEW.name) || to_tsvector('english', NEW.description);
    -- ensure that one field will still be indexed when the other is NULL
    NEW.tsv := to_tsvector('english', coalesce(NEW.name, '') || ' ' || coalesce(NEW.description, ''));
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS products_biut ON products;

CREATE TRIGGER products_biut
    BEFORE INSERT OR UPDATE ON products
    FOR EACH ROW
    EXECUTE PROCEDURE products_biut ();

---- create above / drop below ----
DROP TABLE products;

DROP TRIGGER IF EXISTS products_biut ON products;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
