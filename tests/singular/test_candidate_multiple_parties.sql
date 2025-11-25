SELECT
    candidate_id,
    COUNT(DISTINCT party) AS total_parties
FROM {{ source('raw_data', 'raw_data_candidate_info') }}
GROUP BY candidate_id
HAVING COUNT(DISTINCT party) > 1


--Verifica que un candidato sólo pertenezca a un partido
