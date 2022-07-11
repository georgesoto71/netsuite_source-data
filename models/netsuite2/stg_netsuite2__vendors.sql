{{ config(enabled=var('netsuite_data_model', 'netsuite') == var('netsuite2_variable_name','netsuite2')) }}

with base as (

    select * 
    from {{ ref('stg_netsuite2__vendors_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_netsuite2__vendors_tmp')),
                staging_columns=get_netsuite2_vendors_columns()
            )
        }}
    from base
),

final as (
    
    select
        _fivetran_synced,
        id as vendor_id,
        companyname as company_name,
        datecreated as create_date_at,
        category as vendor_category_id
    from fields
    where not coalesce(_fivetran_deleted, false)
)

select * 
from final