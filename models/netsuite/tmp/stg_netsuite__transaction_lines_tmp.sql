{{ config(enabled=var('data_model', 'netsuite') == 'netsuite') }}

select * 
from {{ var('netsuite_transaction_lines') }}
