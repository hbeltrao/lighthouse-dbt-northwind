
with staging as (

    select * from {{ ref('stg_northwind__orders') }}

)

select * from staging
