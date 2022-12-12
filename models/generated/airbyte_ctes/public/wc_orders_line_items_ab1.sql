{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('wc_orders_scd') }}
{{ unnest_cte(ref('wc_orders_scd'), 'wc_orders', 'line_items') }}
select
    _airbyte_wc_orders_hashid,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_scalar(unnested_column_value('line_items'), ['sku'], ['sku']) }} as sku,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['name'], ['name']) }} as {{ adapter.quote('name') }},
    {{ json_extract_scalar(unnested_column_value('line_items'), ['price'], ['price']) }} as price,
    {{ json_extract('', unnested_column_value('line_items'), ['taxes']) }} as taxes,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['total'], ['total']) }} as total,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['quantity'], ['quantity']) }} as quantity,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['subtotal'], ['subtotal']) }} as subtotal,
    {{ json_extract('', unnested_column_value('line_items'), ['meta_data']) }} as meta_data,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['tax_class'], ['tax_class']) }} as tax_class,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['total_tax'], ['total_tax']) }} as total_tax,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['product_id'], ['product_id']) }} as product_id,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['subtotal_tax'], ['subtotal_tax']) }} as subtotal_tax,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['variation_id'], ['variation_id']) }} as variation_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('wc_orders_scd') }} as table_alias
-- line_items at wc_orders/line_items
{{ cross_join_unnest('wc_orders', 'line_items') }}
where 1 = 1
and line_items is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

