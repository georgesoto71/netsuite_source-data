{{ config(enabled=var('data_model') == 'netsuite') }}

select * 
from {{ var('consolidated_exchange_rates') }}
