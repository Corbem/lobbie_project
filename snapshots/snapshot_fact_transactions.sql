{% snapshot snapshot_fact_transactions %}

{{
  config(
    target_schema='snapshots',
    unique_key='txn_id',
    strategy='check',
    check_cols=[
      'amount',
      'transaction_type',
      'vendor_payee',
      'description'
    ]
  )
}}

select
    txn_id,
    candidate_id,
    transaction_type,
    vendor_payee,
    amount,
    transaction_date,
    description,
    election_year
from {{ source('raw_data', 'raw_data_campaign_transactions') }}

{% endsnapshot %}
