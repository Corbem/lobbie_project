{{ config(
  materialized='incremental',
  unique_key='txn_id',
  on_schema_change='sync_all_columns',
  schema='gold'
) }}

WITH src AS (
  SELECT
    txn_id,
    CAST(candidate_id AS STRING) AS candidate_id,
    UPPER(transaction_type) AS transaction_type,
    INITCAP(vendor_payee) AS vendor_payee,
    CAST(amount AS NUMBER(18,2)) AS amount,
    TO_DATE(transaction_date) AS transaction_date,
    description,
    CAST(election_year AS INTEGER) AS election_year
  FROM {{ ref('stg_raw_data_campaign_transactions') }}
  WHERE amount IS NOT NULL
),

mapped AS (
  SELECT
    s.txn_id,
    s.candidate_id,
    v.vendor_id,
    s.transaction_type,
    s.vendor_payee,
    s.amount,
    s.transaction_date,
    s.description,
    s.election_year
  FROM src s
  LEFT JOIN {{ ref('stg_raw_data_vendors') }} v
    ON INITCAP(s.vendor_payee) = INITCAP(v.vendor_name)
)

SELECT * FROM mapped

{% if is_incremental() %}
  WHERE transaction_date > (SELECT COALESCE(MAX(transaction_date), '1900-01-01') FROM {{ this }})
{% endif %}

