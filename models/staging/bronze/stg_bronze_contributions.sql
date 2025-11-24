{{
  config(
    materialized='view'
  )
}}

WITH src_contributions AS (
    SELECT *
    FROM {{ source('bronze', 'bronze_fec_contributions') }}
),

renamed_casted AS (
    SELECT
        CAST(contribution_id AS STRING) AS contribution_id,
        CAST(candidate_id AS STRING)    AS candidate_id,
        INITCAP(donor_type)             AS donor_type,
        CAST(amount AS NUMBER(18,2))    AS amount,
        TO_DATE(contribution_date)      AS contribution_date
    FROM src_contributions
    WHERE amount > 0
)

SELECT * FROM renamed_casted
