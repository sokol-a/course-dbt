{{ get_events_base('page_view', 'page_view_id') }}

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
    b.order_id
FROM base b
JOIN {{ ref('dim_user') }} u ON b.user_id = u.user_id

