with source as (

    select * from {{ source('indicium-lighthouse', 'raw__products') }}
)

select * 
from source