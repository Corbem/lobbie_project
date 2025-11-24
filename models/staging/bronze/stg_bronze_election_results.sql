{{
  config(
    materialized='view'
  )
}}


WITH src_results AS (
    SELECT *
    FROM {{ source('bronze', 'bronze_election_results') }}
),

renamed_casted AS (
    SELECT
        CAST(election_id AS STRING)    AS election_id,
        CAST(candidate_id AS STRING)   AS candidate_id,
        CAST(total_votes AS INTEGER)   AS total_votes,
        CAST(vote_share AS FLOAT)      AS vote_share,
        CAST(election_year AS INTEGER) AS election_year
    FROM src_results
    WHERE total_votes >= 0
)

SELECT * FROM renamed_casted
