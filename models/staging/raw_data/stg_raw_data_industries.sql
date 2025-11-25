{{
  config(materialized='view')
}}

WITH src AS (
    SELECT DISTINCT
        donor_industry
    FROM {{ ref('stg_raw_data_fec_contributions') }}
    WHERE donor_industry IS NOT NULL
),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['donor_industry']) }} AS industry_id,
        UPPER(donor_industry) AS industry_name
    FROM src
)

SELECT * FROM renamed_casted
