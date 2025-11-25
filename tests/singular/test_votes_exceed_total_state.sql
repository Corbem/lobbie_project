SELECT
    result_id,
    candidate_id,
    state,
    votes,
    total_votes_state
FROM {{ source('raw_data', 'raw_data_election_results') }}
WHERE votes > total_votes_state
