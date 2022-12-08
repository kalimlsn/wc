{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('wc_products__links_ab3') }}
select
    _airbyte_wc_products_hashid,
    {{ adapter.quote('self') }},
    collection,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte__links_hashid
from {{ ref('wc_products__links_ab3') }}
-- _links at wc_products/_links from {{ ref('wc_products_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

