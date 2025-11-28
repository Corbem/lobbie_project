{{ config(
    materialized='table',
    schema='gold'
) }}
-- ¿Qué lobbies tienen mayor influencia en las elecciones?

WITH lobby_spend AS (
    SELECT
        lobby_id,
        SUM(total_spent_by_year) AS total_spent_by_year,
        SUM(total_spent_by_industry_year) AS total_spent_by_industry_year,
    FROM {{ ref('fct_lobby_spend') }}
    GROUP BY lobby_id
),

contribs_by_industry AS (
    SELECT
        UPPER(donor_industry) AS industry,
        SUM(amount) AS total_contributions
    FROM {{ ref('fct_contributions') }}
    GROUP BY industry
),

lobby_influence AS (
    SELECT
        l.lobby_id,
        l.lobby_name,
        UPPER(l.industry_name) AS industry,
        COALESCE(ls.total_spent_by_year, 0) AS total_lobby_spent_by_year,
        COALESCE(ci.total_contributions, 0) AS contributions_linked
    FROM {{ ref('stg_raw_data_lobbies') }} l
    LEFT JOIN lobby_spend ls
        ON l.lobby_id = ls.lobby_id
    LEFT JOIN contribs_by_industry ci
        ON UPPER(l.industry_name) = ci.industry
)

SELECT
    lobby_id,
    lobby_name,
    industry,
    total_lobby_spent_by_year,
    contributions_linked,
    CASE
        WHEN total_lobby_spent_by_year = 0 THEN NULL
        ELSE ROUND(contributions_linked / total_lobby_spent_by_year, 4)
    END AS influence_ratio,
    RANK() OVER (ORDER BY total_lobby_spent_by_year DESC) AS influence_rank
FROM lobby_influence
ORDER BY influence_rank
