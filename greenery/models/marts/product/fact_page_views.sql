-- fact_page_views.sql

WITH base AS (
    SELECT
        e.event_id AS page_view_id,
        e.user_id,
        e.session_id,
        e.page_url,
        e.created_at,
        e.product_id,
        e.order_id,
        e.created_at::DATE AS date_key -- Extracting the date part of the timestamp for joining with DimDate
    FROM {{ ref('stg_postgres__events') }} e
    WHERE e.event_type = 'page_view'
)

SELECT
    b.page_view_id,
    b.user_id,
    u.first_name, -- Additional user attributes from DimUser
    u.last_name,
    u.email,
    b.session_id,
    b.page_url,
    b.created_at,
    b.product_id,
    b.order_id,
    d.date AS date_key
FROM base b
JOIN {{ ref('dim_user') }} u ON b.user_id = u.user_id
JOIN {{ ref('dim_date') }} d ON b.date_key = d.date
