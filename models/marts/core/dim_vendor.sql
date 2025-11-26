{{ config(
    materialized='table',
    schema='gold'
) }}

WITH src AS (
  SELECT * FROM {{ ref('stg_raw_data_vendors') }}
),

renamed_casted AS (
    SELECT
        vendor_id,
        vendor_name
    FROM src
    )

SELECT * FROM renamed_casted



