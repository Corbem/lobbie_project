{{ config(
    materialized='table',
    schema='gold'
) }}

WITH src AS (
  SELECT * FROM {{ ref('stg_raw_data_industries') }}
),

renamed_casted AS (
    SELECT
        industry_id,
        industry_name
    FROM src
    )

SELECT * FROM renamed_casted


