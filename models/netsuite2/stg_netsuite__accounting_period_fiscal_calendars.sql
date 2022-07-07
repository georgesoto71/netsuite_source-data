{{ config(enabled=var('data_model', 'netsuite') == 'netsuite2') }}

with base as (

    select * 
    from {{ ref('stg_netsuite__accounting_period_fiscal_calendars_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_netsuite__accounting_period_fiscal_calendars_tmp')),
                staging_columns=get_accountingperiodfiscalcalendars_columns()
            )
        }}
    from base
),

final as (
    
    select 
        _fivetran_id,
        _fivetran_synced,
        accountingperiod as accounting_period_id,
        fiscalcalendar as fiscal_calendar_id,
        parent as parent_id

    from fields
    where not coalesce(_fivetran_deleted, false)
)

select *
from final
