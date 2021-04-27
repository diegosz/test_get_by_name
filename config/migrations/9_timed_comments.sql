-- Write your migrate up statements here
CREATE TABLE timed_comments (
    ts timestamptz NOT NULL,
    id bigint GENERATED ALWAYS AS IDENTITY,
    body text CHECK (length(body) > 1 AND length(body) < 200),
    product_id bigint REFERENCES products (id),
    user_id bigint REFERENCES users (id),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    PRIMARY KEY (ts, id)
);

---- create above / drop below ----
DROP TABLE timed_comments;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
