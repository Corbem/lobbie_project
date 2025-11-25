{{
  config(
    materialized='table'
  )
}}

WITH src_lobbying_expenses AS (

    SELECT *
    FROM {{ ref('stg_raw_data_lobbying_expenses') }}

),

renamed_casted AS (

    SELECT
        CAST(lobby_id AS STRING)                   AS lobby_id,
        INITCAP(client_name)                       AS client_name,
        SUM(CAST(total_spent AS NUMBER(18,2)))     AS total_lobby_funding,
        COUNT(*)                                   AS filings_count,
        MIN(report_year)                           AS first_report_year,
        MAX(report_year)                           AS last_report_year
    FROM src_lobbying_expenses
    WHERE total_spent IS NOT NULL
      AND total_spent > 0
    GROUP BY lobby_id, client_name

)

SELECT *
FROM renamed_casted
