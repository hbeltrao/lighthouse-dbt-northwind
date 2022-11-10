with source as (

    select * from {{ source('raw_northwind', 'raw__customers') }}
)

select * from source