with source as (

    select * from {{ source('raw_northwind', 'raw__categories') }}
)

select * from source