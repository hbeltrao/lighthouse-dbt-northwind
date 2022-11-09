with source as (

    select * from {{ source('raw_northwind', 'raw__orders') }}

)

select * 
from source