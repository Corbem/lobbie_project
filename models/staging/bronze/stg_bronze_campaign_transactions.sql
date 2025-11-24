{{
  config(
    materialized='view'
  )
}}

WITH src_campaign_transactions AS (
    SELECT * 
    FROM {{ source('bronze', 'bronze_campaign_transactions') }}
    ),

renamed_casted AS (
    SELECT
        CAST(txn_id AS STRING)               AS txn_id,
        CAST(candidate_id AS STRING)         AS candidate_id,
        UPPER(transaction_type)              AS transaction_type,
        INITCAP(vendor_payee)                AS vendor_payee,
        CAST(amount AS NUMBER(18,2))         AS amount,
        TO_DATE(transaction_date)            AS transaction_date,
        description,
        CAST(election_year AS INTEGER)       AS election_year
    FROM src_campaign_transactions
    WHERE amount <> 0
    )

SELECT * FROM renamed_casted
