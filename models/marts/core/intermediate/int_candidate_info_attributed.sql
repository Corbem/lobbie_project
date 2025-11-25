{{
  config(
    materialized='table'
  )
}}

WITH src_campaign_transactions AS (

    SELECT
        txn.txn_id,
        txn.amount,
        txn.transaction_date,
        c.candidate_id,
        c.party,
        c.state
    FROM {{ ref('stg_raw_data_campaign_transactions') }} txn
    JOIN {{ ref('stg_raw_data_candidate_info') }} c
      ON txn.candidate_id = c.candidate_id

),

renamed_casted AS (

    SELECT
        CAST(txn_id AS STRING)                   AS transaction_id,
        CAST(candidate_id AS STRING)             AS candidate_id,
        UPPER(party)                             AS party,
        UPPER(state)                             AS state,
        CAST(amount AS NUMBER(18,2))             AS amount,
        TO_DATE(transaction_date)               AS transaction_date,
        YEAR(TO_DATE(transaction_date))          AS election_year
    FROM src_campaign_transactions
    WHERE amount IS NOT NULL
      AND amount <> 0

)

SELECT *
FROM renamed_casted
