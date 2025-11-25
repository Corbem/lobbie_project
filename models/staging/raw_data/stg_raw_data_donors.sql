{{
  config(materialized='view')
}}

WITH src AS (
    SELECT DISTINCT
        donor_name,
        donor_occupation,
        donor_employer
    FROM {{ ref('stg_raw_data_fec_contributions') }}
    WHERE donor_name IS NOT NULL
),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['donor_name', 'donor_employer']) }} AS donor_id,
        INITCAP(donor_name)                        AS donor_name,
        INITCAP(donor_occupation)                 AS donor_occupation,
        INITCAP(donor_employer)                   AS donor_employer
    FROM src
)

SELECT * FROM renamed_casted
