{{ config(
    materialized='table',
    schema='gold'
) }}

WITH src AS (
  SELECT * FROM {{ ref('stg_raw_data_donors') }}
),

renamed_casted AS (
    SELECT
        donor_id,
        donor_name,
        donor_occupation,
        donor_employer
    FROM src
    )

SELECT * FROM renamed_casted



