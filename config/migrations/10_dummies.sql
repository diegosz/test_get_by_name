-- Write your migrate up statements here
CREATE TABLE a_dummies (
    id bigserial PRIMARY KEY,
    body text CHECK (length(body) > 1 AND length(body) < 200),
    product_id bigint REFERENCES products (id),
    user_id bigint REFERENCES users (id),
    reply_to_id bigint REFERENCES comments (id),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

CREATE TABLE b_dummies (
    id bigserial PRIMARY KEY,
    body text CHECK (length(body) > 1 AND length(body) < 200),
    product_id bigint REFERENCES products (id),
    user_id bigint REFERENCES users (id),
    reply_to_id bigint REFERENCES comments (id),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

CREATE TABLE c_dummies (
    id bigserial PRIMARY KEY,
    body text CHECK (length(body) > 1 AND length(body) < 200),
    product_id bigint REFERENCES products (id),
    user_id bigint REFERENCES users (id),
    reply_to_id bigint REFERENCES comments (id),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

CREATE TABLE d_dummies (
    id bigserial PRIMARY KEY,
    body text CHECK (length(body) > 1 AND length(body) < 200),
    product_id bigint REFERENCES products (id),
    user_id bigint REFERENCES users (id),
    reply_to_id bigint REFERENCES comments (id),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

CREATE TABLE e_dummies (
    id bigserial PRIMARY KEY,
    body text CHECK (length(body) > 1 AND length(body) < 200),
    product_id bigint REFERENCES products (id),
    user_id bigint REFERENCES users (id),
    reply_to_id bigint REFERENCES comments (id),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

CREATE TABLE f_dummies (
    id bigserial PRIMARY KEY,
    body text CHECK (length(body) > 1 AND length(body) < 200),
    product_id bigint REFERENCES products (id),
    user_id bigint REFERENCES users (id),
    reply_to_id bigint REFERENCES comments (id),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

CREATE TABLE g_dummies (
    id bigserial PRIMARY KEY,
    body text CHECK (length(body) > 1 AND length(body) < 200),
    product_id bigint REFERENCES products (id),
    user_id bigint REFERENCES users (id),
    reply_to_id bigint REFERENCES comments (id),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

CREATE TABLE h_dummies (
    id bigserial PRIMARY KEY,
    body text CHECK (length(body) > 1 AND length(body) < 200),
    product_id bigint REFERENCES products (id),
    user_id bigint REFERENCES users (id),
    reply_to_id bigint REFERENCES comments (id),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

CREATE TABLE i_dummies (
    id bigserial PRIMARY KEY,
    body text CHECK (length(body) > 1 AND length(body) < 200),
    product_id bigint REFERENCES products (id),
    user_id bigint REFERENCES users (id),
    reply_to_id bigint REFERENCES comments (id),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

CREATE TABLE j_dummies (
    id bigserial PRIMARY KEY,
    body text CHECK (length(body) > 1 AND length(body) < 200),
    product_id bigint REFERENCES products (id),
    user_id bigint REFERENCES users (id),
    reply_to_id bigint REFERENCES comments (id),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

CREATE TABLE k_dummies (
    id bigserial PRIMARY KEY,
    body text CHECK (length(body) > 1 AND length(body) < 200),
    product_id bigint REFERENCES products (id),
    user_id bigint REFERENCES users (id),
    reply_to_id bigint REFERENCES comments (id),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

-- CREATE TABLE l_dummies (
--     id bigserial PRIMARY KEY,
--     body text CHECK (length(body) > 1 AND length(body) < 200),
--     product_id bigint REFERENCES products (id),
--     user_id bigint REFERENCES users (id),
--     reply_to_id bigint REFERENCES comments (id),
--     created_at timestamp without time zone NOT NULL,
--     updated_at timestamp without time zone NOT NULL
-- );
-- CREATE TABLE m_dummies (
--     id bigserial PRIMARY KEY,
--     body text CHECK (length(body) > 1 AND length(body) < 200),
--     product_id bigint REFERENCES products (id),
--     user_id bigint REFERENCES users (id),
--     reply_to_id bigint REFERENCES comments (id),
--     created_at timestamp without time zone NOT NULL,
--     updated_at timestamp without time zone NOT NULL
-- );
-- CREATE TABLE n_dummies (
--     id bigserial PRIMARY KEY,
--     body text CHECK (length(body) > 1 AND length(body) < 200),
--     product_id bigint REFERENCES products (id),
--     user_id bigint REFERENCES users (id),
--     reply_to_id bigint REFERENCES comments (id),
--     created_at timestamp without time zone NOT NULL,
--     updated_at timestamp without time zone NOT NULL
-- );
-- CREATE TABLE o_dummies (
--     id bigserial PRIMARY KEY,
--     body text CHECK (length(body) > 1 AND length(body) < 200),
--     product_id bigint REFERENCES products (id),
--     user_id bigint REFERENCES users (id),
--     reply_to_id bigint REFERENCES comments (id),
--     created_at timestamp without time zone NOT NULL,
--     updated_at timestamp without time zone NOT NULL
-- );
-- CREATE TABLE p_dummies (
--     id bigserial PRIMARY KEY,
--     body text CHECK (length(body) > 1 AND length(body) < 200),
--     product_id bigint REFERENCES products (id),
--     user_id bigint REFERENCES users (id),
--     reply_to_id bigint REFERENCES comments (id),
--     created_at timestamp without time zone NOT NULL,
--     updated_at timestamp without time zone NOT NULL
-- );
---- create above / drop below ----
DROP TABLE a_dummies;

DROP TABLE b_dummies;

DROP TABLE c_dummies;

DROP TABLE d_dummies;

DROP TABLE e_dummies;

DROP TABLE f_dummies;

DROP TABLE g_dummies;

DROP TABLE h_dummies;

DROP TABLE i_dummies;

DROP TABLE j_dummies;

DROP TABLE k_dummies;

-- DROP TABLE l_dummies;
-- DROP TABLE m_dummies;
-- DROP TABLE n_dummies;
-- DROP TABLE o_dummies;
-- DROP TABLE p_dummies;
-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
