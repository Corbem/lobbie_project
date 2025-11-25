{{
  config(
    materialized='view'
  )
}}

WITH src_contributions AS (
    SELECT *
    FROM {{ source('raw_data', 'raw_data_fec_contributions') }}
),

renamed_casted AS (
    SELECT
        CAST(contribution_id AS STRING)           AS contribution_id,
        INITCAP(TRIM(donor_name))                 AS donor_name,
        INITCAP(donor_occupation)                 AS donor_occupation,
        INITCAP(donor_employer)                   AS donor_employer,
        INITCAP(donor_industry)                   AS donor_industry,
        CAST(recipient_candidate_id AS STRING)    AS candidate_id,
        recipient_committee,
        CAST(amount AS NUMBER(18,2))              AS amount,
        TO_DATE(transaction_date)                 AS transaction_date,
        UPPER(transaction_type)                   AS transaction_type,
        CAST(election_year AS INTEGER)            AS election_year,
        UPPER(state)                              AS state
    FROM src_contributions
    WHERE amount > 0
)

SELECT * FROM renamed_casted
