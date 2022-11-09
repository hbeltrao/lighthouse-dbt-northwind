with source as (

    select * from {{ source('raw_northwind', 'raw__suppliers') }}
)

select *
from source