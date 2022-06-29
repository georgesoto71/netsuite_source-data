
with base as (

    select * 
    from {{ ref('stg_netsuite__job_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_netsuite__job_tmp')),
                staging_columns=get_job_columns()
            )
        }}
    from base
),

final as (
    
    select 
        _fivetran_synced,
        id as job_id,
        externalid as job_external_id,
        customer as customer_id,
        entityid as entity_id,
        defaultbillingaddress as billing_address_id,
        defaultshippingaddress as shipping_address_id,
        parent as parent_id
        
    from fields
)

select *
from final
