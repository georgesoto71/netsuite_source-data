{{ config(enabled=var('data_model', 'netsuite') == 'netsuite2') }}

select * 
from {{ var('entities_netsuite2') }}
