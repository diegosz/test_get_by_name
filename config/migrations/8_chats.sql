-- Write your migrate up statements here
CREATE TABLE chats (
    id bigserial PRIMARY KEY,
    body text,
    reply_to_id bigint[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

---- create above / drop below ----
DROP TABLE chats;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
/* action='createCommentAndProduct',controller='graphql',framework='graphjin' */
WITH _sg_input AS (
    SELECT
        $1::json AS j
),
comments AS (
    WITH products AS (
        SELECT
            "id "
        FROM
            _sg_input i,
            "products "
        WHERE ((products.name) = CAST(i.j -> 'product' -> 'connect' ->> 'name' AS text))
    LIMIT 1) INSERT INTO "comments " ("updated_at ", "body ", "created_at ", "product_id ")
    SELECT
        t.updated_at,
        t.body,
        t.created_at,
        products.id
    FROM
        _sg_input i,
        "products " "products ",
        json_populate_record(NULL "comments ", i.j) t
    RETURNING
        *
)
    SELECT
        jsonb_build_object('comments', __sj_0.json) AS __root
FROM ((
        SELECT
            TRUE)) AS __root_x
    LEFT OUTER JOIN LATERAL (
    SELECT
        COALESCE(jsonb_agg(__sj_0.json), '[]') AS json
FROM (
    SELECT
        to_jsonb (__sr_0.*) AS json
FROM (
    SELECT
        comments_0.id AS "id ",
        __sj_1.json AS "products "
    FROM (
        SELECT
            comments.id,
            comments.product_id
        FROM
            "comments "
        LIMIT 20) AS comments_0
    LEFT OUTER JOIN LATERAL (
    SELECT
        to_jsonb (__sr_1.*) AS json
    FROM (
        SELECT
            products_1.id AS "id ",
            products_1.name AS "name "
        FROM (
            SELECT
                products.id,
                products.name
            FROM
                "products "
            WHERE (((products.id) = (comments_0.product_id)))
        LIMIT 1) AS products_1) AS __sr_1) AS __sj_1 ON TRUE) AS __sr_0) AS __sj_0) AS __sj_0 ON TRUE
