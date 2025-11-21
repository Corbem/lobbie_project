{{ config(materialized='table') }}

SELECT
    CAST(report_id AS STRING)             AS report_id,
    CAST(candidate_id AS STRING)          AS candidate_id,
    CAST(cycle AS INTEGER)                AS cycle,
    CAST(total_receipts AS NUMBER(18,2))  AS total_receipts,
    CAST(total_disbursements AS NUMBER(18,2)) AS total_disbursements,
    CAST(cash_on_hand AS NUMBER(18,2))    AS cash_on_hand,
    TO_DATE(filing_date)                  AS filing_date,
    UPPER(report_type)                    AS report_type
FROM {{ source('bronze', 'raw_financial_reports') }}
