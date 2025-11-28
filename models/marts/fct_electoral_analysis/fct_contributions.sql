{{ config(
  materialized='incremental',
  unique_key='contribution_id',
  on_schema_change='sync_all_columns',
  schema='gold'
) }}

WITH src AS (
  SELECT
    contribution_id,
    donor_name,
    donor_employer,
    donor_occupation,
    donor_industry,
    candidate_id,
    recipient_committee,
    CAST(amount AS NUMBER(18,2)) AS amount,
    TO_DATE(transaction_date) AS transaction_date,
    UPPER(transaction_type) AS transaction_type,
    CAST(election_year AS INTEGER) AS election_year,
    UPPER(state) AS state
  FROM {{ ref('stg_raw_data_fec_contributions') }}
  WHERE amount > 0
),

mapped AS (
  SELECT
    s.contribution_id,
    d.donor_id,
    COALESCE(s.candidate_id, NULL) AS candidate_id,
    s.recipient_committee,
    s.amount,
    s.transaction_date,
    s.transaction_type,
    s.election_year,
    s.state,
    s.donor_industry,
    i.donor_industry
  FROM src s
  LEFT JOIN {{ ref('stg_raw_data_donors') }} d
    ON INITCAP(s.donor_name) = INITCAP(d.donor_name)
   AND (d.donor_employer IS NULL OR INITCAP(s.donor_employer) = INITCAP(d.donor_employer))
  LEFT JOIN {{ ref('stg_raw_data_industries') }} ind
    ON UPPER(s.donor_industry) = ind.industry_name
  LEFT JOIN {{ ref('stg_raw_data_fec_contributions') }} i ON ind.industry_name = i.donor_industry 
)

SELECT * FROM mapped

{% if is_incremental() %}
  WHERE transaction_date > (SELECT COALESCE(MAX(transaction_date), '1900-01-01') FROM {{ this }})
{% endif %}

