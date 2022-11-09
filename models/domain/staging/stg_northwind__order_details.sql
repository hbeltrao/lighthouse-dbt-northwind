with source as (

    select * from {{ source('indicium-lighthose', 'raw__order_details') }}

)

select * 
from source