{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "public",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('wc_customers_scd') }}
select
    _airbyte_unique_key,
    {{ adapter.quote('id') }},
    {{ adapter.quote('role') }},
    email,
    _links,
    billing,
    shipping,
    shop_url,
    username,
    last_name,
    meta_data,
    avatar_url,
    first_name,
    date_created,
    date_modified,
    date_created_gmt,
    date_modified_gmt,
    is_paying_customer,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_wc_customers_hashid
from {{ ref('wc_customers_scd') }}
-- wc_customers from {{ source('public', '_airbyte_raw_wc_customers') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

