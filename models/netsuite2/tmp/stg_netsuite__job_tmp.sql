{{ config(enabled=var('data_model') == 'netsuite2') }}

select * 
from {{ var('job_netsuite2') }}
