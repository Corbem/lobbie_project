{{
  config(
    materialized='view'
  )
}}

WITH src_candidates AS (
    SELECT * 
    FROM {{ source('raw_data', 'raw_data_candidate_info') }}
),

renamed_casted AS (
    SELECT
        CAST(candidate_id AS STRING)                                        AS candidate_id,
        INITCAP(TRIM(REPLACE(first_name, 'Candidate_', '')))               AS first_name,
        INITCAP(TRIM(REPLACE(last_name, 'Lastname_', '')))                 AS last_name,
        INITCAP(TRIM(full_name))                                           AS full_name,
        UPPER(party)                                                       AS party,
        UPPER(state)                                                       AS state,
        INITCAP(office)                                                    AS office,
        CAST(district AS INTEGER)                                          AS district,
        CAST(incumbent AS BOOLEAN)                                         AS incumbent,
        TO_DATE(campaign_start_date)                                       AS campaign_start_date,
        LOWER(candidate_website)                                           AS candidate_website
    FROM src_candidates
)

SELECT * FROM renamed_casted
