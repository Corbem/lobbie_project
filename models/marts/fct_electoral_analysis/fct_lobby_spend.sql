{{ config(
    materialized='table',
    schema='gold'
) }}

WITH src AS (
  SELECT
    CAST(lobby_id AS STRING) AS lobby_id,
    client_name,
    UPPER(industry) AS industry,
    CAST(report_year AS INTEGER) AS report_year,
    CAST(total_spent AS NUMBER(18,2)) AS total_spent,
    CAST(num_filings AS INTEGER) AS num_filings,
    TO_DATE(filing_date) AS filing_date
  FROM {{ ref('stg_raw_data_lobbying_expenses') }}
)

SELECT
  lobby_id,
  client_name,
  industry,
  report_year,
  SUM(total_spent) OVER (PARTITION BY lobby_id, report_year) AS total_spent_by_year,
  SUM(total_spent) OVER (PARTITION BY industry, report_year) AS total_spent_by_industry_year,
  num_filings,
  filing_date
FROM src

