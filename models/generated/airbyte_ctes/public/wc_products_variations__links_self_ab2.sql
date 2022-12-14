{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('wc_products_variations__links_self_ab1') }}
select
    _airbyte__links_hashid,
    cast(href as {{ dbt_utils.type_string() }}) as href,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('wc_products_variations__links_self_ab1') }}
-- self at wc_products_variations/_links/self
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

