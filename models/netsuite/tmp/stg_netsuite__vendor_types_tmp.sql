{{ config(enabled=var('data_model', 'netsuite') == 'netsuite') }}

select * 
from {{ var('netsuite_vendor_types') }}
