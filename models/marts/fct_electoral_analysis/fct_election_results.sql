{{ config(
    materialized='table',
    schema='gold'
) }}

WITH src AS (
  SELECT
    result_id,
    election_year,
    state,
    CAST(candidate_id AS STRING) AS candidate_id,
    office,
    CAST(votes AS INTEGER) AS votes,
    CAST(total_votes_state AS INTEGER) AS total_votes_state,
    CAST(vote_share AS FLOAT) AS vote_share
  FROM {{ ref('stg_raw_data_election_results') }}
)

SELECT * FROM src
