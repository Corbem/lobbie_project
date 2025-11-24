{{
  config(
    materialized='view'
  )
}}

WITH src_lobbying AS (
    SELECT *
    FROM {{ source('bronze', 'bronze_lobbying_expenses') }}
),

renamed_casted AS (
    SELECT
        CAST(lobby_id AS STRING)       AS lobby_id,
        INITCAP(industry)              AS industry,
        CAST(amount_spent AS NUMBER(18,2)) AS amount_spent,
        CAST(year AS INTEGER)          AS year
    FROM src_lobbying
    WHERE amount_spent > 0
)

SELECT * FROM renamed_casted
