{{ config(
    materialized='table',
    schema='gold'
) }}
-- ¿Qué candidatos reciben más apoyo de ciertos grupos de interés?

WITH contribs AS (
    SELECT
        c.candidate_id,
        COALESCE(d.donor_name, 'UNKNOWN') AS donor_industry,
        COALESCE(l.lobby_id, 'NO_LOBBY') AS lobby_id,
        SUM(c.amount) AS total_by_group
    FROM {{ ref('fct_contributions') }} c
    LEFT JOIN {{ ref('stg_raw_data_donors') }} d 
        ON c.donor_id = d.donor_id
    LEFT JOIN {{ ref('stg_raw_data_lobbies') }} l 
        ON UPPER(d.donor_name) = UPPER(l.industry_name)
    GROUP BY 
        c.candidate_id,
        d.donor_name,
        l.lobby_id
)

SELECT
    candidate_id,
    donor_industry,
    lobby_id,
    total_by_group,
    RANK() OVER (
        PARTITION BY candidate_id 
        ORDER BY total_by_group DESC
    ) AS rank_within_candidate
FROM contribs
WHERE total_by_group > 0
ORDER BY candidate_id, rank_within_candidate
