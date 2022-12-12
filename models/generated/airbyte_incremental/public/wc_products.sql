{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "public",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('wc_products_scd') }}
select
    _airbyte_unique_key,
    {{ adapter.quote('id') }},
    sku,
    {{ adapter.quote('name') }},
    slug,
    tags,
    price,
    images,
    status,
    categories,
   description,
    parent_id,
    permalink,
    price_html,
    sale_price,
    short_description,
    date_created_gmt,
    date_modified_gmt,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_wc_products_hashid
from {{ ref('wc_products_scd') }}
-- wc_products_variations from {{ source('public', '_airbyte_raw_wc_products_variations') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

