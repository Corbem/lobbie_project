{{
  config(materialized='view')
}}

WITH src AS (
    SELECT DISTINCT
        lobby_id,
        org_name,
        industry
    FROM {{ ref('stg_raw_data_lobbying_expenses') }}
),

renamed_casted AS (
    SELECT
        CAST(lobby_id AS STRING) AS lobby_id,
        INITCAP(org_name)        AS lobby_name,
        UPPER(industry)          AS industry_name
    FROM src
)

SELECT * FROM renamed_casted
