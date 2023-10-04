{%- macro get_events_base(event_type, event_id_alias) -%}
WITH base AS (
    SELECT
        e.event_id AS {{ event_id_alias }},
        e.user_id,
        e.session_id,
        e.page_url,
        e.created_at,
        e.product_id,
        e.order_id,
        e.created_at::DATE AS date_key
    FROM {{ ref('stg_postgres__events') }} e
    WHERE e.event_type = '{{ event_type }}'
)
{%- endmacro %}
