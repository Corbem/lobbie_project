{{
    codegen.generate_source(
        schema_name = 'RAW_DATA',
        database_name = 'ELECTION_DATA',
        table_names = [
        'stg_raw_data_donors',
        'stg_raw_data_industries',
        'stg_raw_data_lobbies',
        'stg_vendors'
        ],
        generate_columns = True,
        include_descriptions=True,
        include_data_types=True,
        name='desarrollo',
        include_database=True,
        include_schema=True
        )
}}


