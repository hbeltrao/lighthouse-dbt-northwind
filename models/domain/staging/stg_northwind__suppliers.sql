with source as (

    select * from {{ source('indicium-lighthouse', 'raw__suppliers') }}
)

select *
from source