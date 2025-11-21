{{ config(materialized='table') }}

SELECT
    CAST(lobby_id AS STRING)          AS lobby_id,
    INITCAP(org_name)                 AS org_name,
    INITCAP(client_name)              AS client_name,
    INITCAP(industry)                 AS industry,
    CAST(report_year AS INTEGER)      AS report_year,
    CAST(total_spent AS NUMBER(18,2)) AS total_spent,
    CAST(num_filings AS INTEGER)      AS num_filings,
    INITCAP(purpose)                  AS purpose,
    TO_DATE(filing_date)              AS filing_date
FROM {{ source('bronze', 'raw_lobbying_expenses') }}
