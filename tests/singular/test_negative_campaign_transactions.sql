SELECT
    txn_id,
    candidate_id,
    amount,
    transaction_type
FROM {{ source('raw_data', 'raw_data_campaign_transactions') }}
WHERE amount < 0
