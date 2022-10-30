with customer_orders as (

    select
	user_id as customer_id
	, min(order_date) as first_order_date
	, max(order_date) as most_recent_order_date
	, count(id) as number_of_orders
    from jaffle_shop.orders
    group by 1

),

final as (

    select
	c.id as customer_id,
	c.first_name,
	c.last_name,
	co.first_order_date,
	co.most_recent_order_date,
	coalesce(co.number_of_orders, 0) as number_of_orders
    from jaffle_shop.customers c
    left join customer_orders co on c.id = co.customer_id

)

select * from final
