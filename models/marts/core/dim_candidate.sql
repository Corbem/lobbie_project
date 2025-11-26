{{ config(
    materialized='table',
    schema='gold'
) }}

WITH src AS (
  SELECT * FROM {{ ref('stg_raw_data_candidate_info') }}
),

renamed_casted AS (
    SELECT
    candidate_id,
    first_name,
    last_name,
    full_name,
    party,
    state,
    office,
    district,
    incumbent,
    campaign_start_date,
    candidate_website
    FROM src
    )

SELECT * FROM renamed_casted
