{{ get_events_base('checkout', 'purchase_event_id') }}

SELECT
    b.purchase_event_id,
    b.session_id,
    b.created_at,
    b.order_id,
    b.date_key,
    o.product_id,
    o.quantity
FROM base b
JOIN {{ ref('stg_postgres__order_items') }} o ON b.order_id = o.order_id