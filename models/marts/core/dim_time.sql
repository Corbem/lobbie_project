{{ config(
    materialized='table',
    schema='gold'
) }}

-- simple time dimension; materialize once and refresh if needed
WITH dates AS (
  SELECT
    DISTINCT transaction_date::date AS day
  FROM {{ ref('stg_raw_data_campaign_transactions') }}
  UNION
  SELECT DISTINCT transaction_date::date FROM {{ ref('stg_raw_data_fec_contributions') }}
),

renamed_casted AS (
    SELECT
    day AS date,
    EXTRACT(year FROM day) AS year,
    EXTRACT(month FROM day) AS month,
    EXTRACT(day FROM day) AS day_of_month,
    --TO_CHAR(day, 'IW')::int AS week_of_year,
    CASE WHEN EXTRACT(month FROM day) BETWEEN 1 AND 3 THEN 1
        WHEN EXTRACT(month FROM day) BETWEEN 4 AND 6 THEN 2
        WHEN EXTRACT(month FROM day) BETWEEN 7 AND 9 THEN 3
        ELSE 4 END AS quarter
    FROM dates
    )

SELECT * FROM renamed_casted



