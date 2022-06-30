{{ config(enabled=var('data_model', 'netsuite') == 'netsuite2') }}

with base as (

    select * 
    from {{ ref('stg_netsuite__accounttype_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_netsuite__accounttype_tmp')),
                staging_columns=get_accounttype_columns()
            )
        }}
    from base
),

final as (
    
    select 
        _fivetran_deleted,
        _fivetran_synced,
        id as account_type_id, -- short name
        balancesheet = 'T' as is_balancesheet,
        {%- if target.type == 'bigquery' -%}
        `left` 
        {%- elif target.type == 'snowflake' -%}
        "LEFT"
        {%- elif target.type == 'redshift' -%}
        "left"
        {%- else -%}
        left
        {%- endif -%} = 'T' as is_leftside,
        longname as type_name

    from fields
)

select *
from final
