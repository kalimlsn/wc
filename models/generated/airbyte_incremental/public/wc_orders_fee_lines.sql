{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('wc_orders_fee_lines_ab3') }}
select
    _airbyte_wc_orders_hashid,
    {{ adapter.quote('id') }},
    {{ adapter.quote('name') }},
    taxes,
    total,
    meta_data,
    tax_class,
    total_tax,
    tax_status,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_fee_lines_hashid
from {{ ref('wc_orders_fee_lines_ab3') }}
-- fee_lines at wc_orders/fee_lines from {{ ref('wc_orders_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

