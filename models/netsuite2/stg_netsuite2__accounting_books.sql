{{ config(enabled=var('data_model', 'netsuite') == 'netsuite2') }}

with base as (

    select * 
    from {{ ref('stg_netsuite2__accounting_books_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_netsuite2__accounting_books_tmp')),
                staging_columns=get_netsuite2_accounting_books_columns()
            )
        }}
    from base
),

final as (
    
    select
        _fivetran_synced,
        id as accounting_book_id,
        name as accounting_book_name,
        basebook as base_book_id,
        effectiveperiod as effective_period_id,
        isadjustmentonly = 'T' as is_adjustment_only,
        isconsolidated = 'T' as is_consolidated,
        contingentrevenuehandling as is_contingent_revenue_handling,
        isprimary = 'T' as is_primary,
        twosteprevenueallocation as is_two_step_revenue_allocation,
        unbilledreceivablegrouping as unbilled_receivable_grouping
    from fields
    where not coalesce(_fivetran_deleted, false)
)

select * 
from final
