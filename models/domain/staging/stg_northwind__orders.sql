with source as (

    select * from {{ source('indicium-lighthose', 'raw__orders') }}

)

select * 
from source