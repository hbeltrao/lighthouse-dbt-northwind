with source as (

    select * from {{ source('raw_northwind', 'raw__products') }}
)

select * 
from source