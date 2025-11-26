{{ config(
    materialized='table',
    schema='gold'
) }}

WITH src AS (
  SELECT * FROM {{ ref('stg_raw_data_lobbies') }}
),

renamed_casted AS (
    SELECT
        lobby_id,
        lobby_name,
        industry_name
    FROM src
    )

SELECT * FROM renamed_casted


