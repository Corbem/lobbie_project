{{
  config(
    materialized='view'
  )
}}


WITH src_results AS (
    SELECT *
    FROM {{ source('raw_data', 'raw_data_election_results') }}
),

renamed_casted AS (
    SELECT
        CAST(result_id AS STRING)           AS result_id,
        CAST(election_year AS INTEGER)      AS election_year,
        UPPER(state)                        AS state,
        CAST(candidate_id AS STRING)        AS candidate_id,
        INITCAP(office)                     AS office,
        CAST(votes AS INTEGER)              AS votes,
        CAST(total_votes_state AS INTEGER)  AS total_votes_state,
        ROUND(CAST(vote_share AS FLOAT), 4) AS vote_share
    FROM src_results
    WHERE votes >= 0
)

SELECT * FROM renamed_casted
