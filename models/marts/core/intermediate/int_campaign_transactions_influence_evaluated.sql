{{
  config(
    materialized='table'
  )
}}

WITH src_campaign_transactions AS (

    SELECT *
    FROM {{ ref('stg_raw_data_campaign_transactions') }}

),

renamed_casted AS (

    SELECT
        CAST(candidate_id AS STRING)                     AS candidate_id,
        COUNT(*)                                         AS txn_count,
        SUM(CAST(amount AS NUMBER(18,2)))                AS total_received,
        AVG(CAST(amount AS NUMBER(18,2)))                AS avg_txn_value,
        MIN(TO_DATE(transaction_date))                   AS first_transaction_date,
        MAX(TO_DATE(transaction_date))                   AS last_transaction_date
    FROM src_campaign_transactions
    WHERE amount IS NOT NULL
      AND amount <> 0
    GROUP BY candidate_id

)

SELECT *
FROM renamed_casted
