
with orders as (

    select * from {{ ref('stg_northwind__orders') }}

)

, order_details as (

    select * from {{ ref('stg_northwind__order_details') }}
)

, joined as (

    select *
    from order_details
    left join orders on order_details.order_id = orders.order_id
)

select * from joined
