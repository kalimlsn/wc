{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('wc_products_variations__links_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_wc_products_variations_hashid',
        array_to_string(adapter.quote('self')),
        array_to_string('collection'),
    ]) }} as _airbyte__links_hashid,
    tmp.*
from {{ ref('wc_products_variations__links_ab2') }} tmp
-- _links at wc_products_variations/_links
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

