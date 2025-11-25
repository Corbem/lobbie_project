{{
    codegen.generate_source(
        schema_name = 'RAW_DATA',
        database_name = 'ELECTION_DATA',
        table_names = [
            'RAW_DATA_CAMPAIGN_TRANSACTIONS', 
            'RAW_DATA_CANDIDATE_INFO', 
            'RAW_DATA_ELECTION_RESULTS', 
            'RAW_DATA_FEC_CONTRIBUTIONS', 
            'RAW_DATA_FINANCIAL_REPORTS', 
            'RAW_DATA_LOBBYING_EXPENSES'
        ],
        generate_columns = True,
        include_descriptions=True,
        include_data_types=True,
        name='desarrollo',
        include_database=True,
        include_schema=True
        )
}}


