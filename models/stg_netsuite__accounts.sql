
with base as (

    select * 
    from {{ ref('stg_netsuite__accounts_tmp') }}

),

fields as (

    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns 
        that are expected/needed (staging_columns from dbt_salesforce_source/models/tmp/) and compares it with columns 
        in the source (source_columns from dbt_salesforce_source/macros/).
        For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */

        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_netsuite__accounts_tmp')),
                staging_columns=get_accounts_columns()
            )
        }}
        --The below script allows for pass through columns.
        {% if var('accounts_pass_through_columns') %}
        ,
        {{ var('accounts_pass_through_columns') | join (", ")}}

        {% endif %}
        
    from base
),

final as (
    
    select 
        account_id,
        parent_id,
        name,
        type_name,
        accountnumber as account_number,
        general_rate_type,
        is_leftside,
        is_balancesheet,
        _fivetran_deleted

        --The below script allows for pass through columns.
        {% if var('accounts_pass_through_columns') %}
        ,
        {{ var('accounts_pass_through_columns') | join (", ")}}

        {% endif %}
        
    from fields
)

select * 
from final
where not coalesce(_fivetran_deleted, false)
