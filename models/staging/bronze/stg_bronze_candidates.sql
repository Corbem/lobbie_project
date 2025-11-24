{{
  config(
    materialized='view'
  )
}}

WITH src_candidates AS (
    SELECT * 
    FROM {{ source('bronze', 'bronze_candidate_info') }}
),

renamed_casted AS (
    SELECT
        CAST(candidate_id AS STRING)   AS candidate_id,
        INITCAP(first_name)            AS first_name,
        INITCAP(last_name)             AS last_name,
        UPPER(party)                   AS party,
        UPPER(state)                   AS state
    FROM src_candidates
)

SELECT * FROM renamed_casted
