WITH numbers AS (
    -- Assuming you won't need more than 5475 days (15 years of daily data)
    SELECT ROW_NUMBER() OVER(ORDER BY SEQ4()) - 1 AS n
    FROM TABLE(GENERATOR(ROWCOUNT => 5475))
),

date_sequence AS (
    SELECT 
        DATEADD('DAY', n, '2010-01-01'::DATE) AS date
    FROM numbers
    WHERE DATEADD('DAY', n, '2010-01-01'::DATE) <= '2024-12-31'::DATE
),

date_attributes AS (
    SELECT
        date,
        EXTRACT(YEAR FROM date) AS year,
        EXTRACT(QUARTER FROM date) AS quarter,
        EXTRACT(MONTH FROM date) AS month,
        EXTRACT(DAY FROM date) AS day,
        EXTRACT(DOY FROM date) AS day_of_year,
        EXTRACT(WEEK FROM date) AS week_of_year,
        CASE 
            WHEN EXTRACT(DOW FROM date) = 0 THEN 7 
            ELSE EXTRACT(DOW FROM date) 
        END AS day_of_week, -- Making Monday=1 and Sunday=7
        CASE 
            WHEN EXTRACT(DOW FROM date) IN (0, 6) THEN 'Weekend' 
            ELSE 'Weekday' 
        END AS weekday_weekend,
        CASE 
            WHEN EXTRACT(MONTH FROM date) IN (12, 1, 2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM date) IN (3, 4, 5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM date) IN (6, 7, 8) THEN 'Summer'
            ELSE 'Fall' 
        END AS season
    FROM date_sequence
)

SELECT
    * 
FROM date_attributes