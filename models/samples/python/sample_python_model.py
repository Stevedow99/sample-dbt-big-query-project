import pandas

def model(dbt, session):
    dbt.config(
        materialized = 'table',
        packages = ['pandas'],
        schema = 'testing'
    )
    
    df = dbt.ref('my_first_model')
    
    return df