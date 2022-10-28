
with staging as (

    select * from {{ ref('stg_my_source__my_table') }}

)


select * from staging
