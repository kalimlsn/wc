{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('wc_orders_refunds_ab3') }}
select
    _airbyte_wc_orders_hashid,
    {{ adapter.quote('id') }},
    total,
    reason,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_refunds_hashid
from {{ ref('wc_orders_refunds_ab3') }}
-- refunds at wc_orders/refunds from {{ ref('wc_orders_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

