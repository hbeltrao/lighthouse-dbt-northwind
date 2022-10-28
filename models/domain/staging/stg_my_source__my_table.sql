with source as (

    select * from {{ source('my_source', 'my_table') }}

)

,   denormalized as (
    select
)

select * from denormalized