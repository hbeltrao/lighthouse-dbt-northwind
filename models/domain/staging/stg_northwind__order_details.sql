with source as (

    select * from {{ source('raw_northwind', 'raw__order_details') }}

)

select * 
from source