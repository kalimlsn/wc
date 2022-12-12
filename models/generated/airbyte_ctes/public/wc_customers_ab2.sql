{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('wc_customers_ab1') }}
select
    cast({{ adapter.quote('id') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('id') }},
    cast({{ adapter.quote('role') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('role') }},
    cast(email as {{ dbt_utils.type_string() }}) as email,
    _links,
    billing,
    shipping,
    cast(shop_url as {{ dbt_utils.type_string() }}) as shop_url,
    cast(username as {{ dbt_utils.type_string() }}) as username,
    cast(last_name as {{ dbt_utils.type_string() }}) as last_name,
    meta_data,
    cast(avatar_url as {{ dbt_utils.type_string() }}) as avatar_url,
    cast(first_name as {{ dbt_utils.type_string() }}) as first_name,
    cast(date_created as {{ dbt_utils.type_string() }}) as date_created,
    cast(date_modified as {{ dbt_utils.type_string() }}) as date_modified,
    cast(date_created_gmt as {{ dbt_utils.type_string() }}) as date_created_gmt,
    cast(date_modified_gmt as {{ dbt_utils.type_string() }}) as date_modified_gmt,
    {{ cast_to_boolean('is_paying_customer') }} as is_paying_customer,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('wc_customers_ab1') }}
-- wc_customers
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

