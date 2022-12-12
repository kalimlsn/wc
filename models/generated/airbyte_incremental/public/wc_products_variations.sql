{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "public",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('wc_products_variations_scd') }}
select
    _airbyte_unique_key,
    {{ adapter.quote('id') }},
    {{ adapter.quote('name') }},
    sku,
    price,
    parent_id,
    tags,
    images,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_wc_products_variations_hashid
from {{ ref('wc_products_variations_scd') }}
-- wc_products_variations from {{ source('public', '_airbyte_raw_wc_products_variations') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

union all

select
    _airbyte_unique_key,
    {{ adapter.quote('id') }},
    {{ adapter.quote('name') }},
    sku,
    price,
    
     CAST(id AS bigint)  as parent_id,
    tags,
    images,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_wc_products_hashid
from {{ ref('wc_products_scd') }}
-- wc_products from {{ source('public', '_airbyte_raw_wc_products') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

