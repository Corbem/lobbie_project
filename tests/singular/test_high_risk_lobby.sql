SELECT
    lobby_id,
    org_name,
    total_spent
FROM {{ source('raw_data', 'raw_data_lobbying_expenses') }}
WHERE total_spent > 50000000


--Controla el total de gasto de un Lobby, que no supere los 50 millones