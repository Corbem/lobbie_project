{{ config(
    materialized='table',
    schema='gold'
) }}
-- ¿Qué relación existe entre donaciones de lobbies y resultados electorales?

WITH contribs_by_candidate AS (
    SELECT
        candidate_id,
        SUM(amount) AS total_donations
    FROM {{ ref('fct_contributions') }}
    GROUP BY candidate_id
),

lobby_spend AS (
    SELECT
        lobby_id,
        SUM(total_spent_by_year) AS total_spent_by_year,
        SUM(total_spent_by_industry_year) AS total_spent_by_industry_year,
    FROM {{ ref('fct_lobby_spend') }}
    GROUP BY lobby_id
),

lobby_money_by_candidate AS (
    SELECT
        c.candidate_id,
        SUM(ls.total_spent_by_year) AS lobby_spend_by_year_linked
    FROM {{ ref('fct_contributions') }} c
    LEFT JOIN {{ ref('stg_raw_data_lobbies') }} l
        ON UPPER(c.donor_industry) = UPPER(l.industry_name)
    LEFT JOIN lobby_spend ls
        ON l.lobby_id = ls.lobby_id
    GROUP BY c.candidate_id
),

results AS (
    SELECT
        candidate_id,
        SUM(votes) AS votes,
        AVG(vote_share) AS avg_vote_share
    FROM {{ ref('fct_election_results') }}
    GROUP BY candidate_id
)

SELECT
    r.candidate_id,
    r.votes,
    r.avg_vote_share,
    COALESCE(cb.total_donations, 0) AS total_donations,
    COALESCE(lb.lobby_spend_by_year_linked, 0) AS lobby_spend_by_year_linked,
    CASE 
        WHEN COALESCE(cb.total_donations, 0) = 0 THEN NULL
        ELSE ROUND(lb.lobby_spend_by_year_linked / cb.total_donations, 4)
    END AS lobby_share_of_donations
FROM results r
LEFT JOIN contribs_by_candidate cb 
    ON r.candidate_id = cb.candidate_id
LEFT JOIN lobby_money_by_candidate lb 
    ON r.candidate_id = lb.candidate_id
ORDER BY r.votes DESC
