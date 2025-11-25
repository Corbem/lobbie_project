{{
  config(materialized='view')
}}

WITH src AS (
    SELECT DISTINCT
        vendor_payee
    FROM {{ ref('stg_raw_data_campaign_transactions') }}
    WHERE vendor_payee IS NOT NULL
),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['vendor_payee']) }} AS vendor_id,
        INITCAP(vendor_payee) AS vendor_name
    FROM src
)

SELECT * FROM renamed_casted
