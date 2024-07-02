-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    ROUND((SUM(order_details.quantity * pizzas.price)) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_revenue
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY SUM(order_details.quantity * pizzas.price) DESC;





-- Analyze the cumulative revenue generated over time.
SELECT  order_date ,sum(revenue) OVER (ORDER BY order_date) AS cumalative_revenue
FROM 
(SELECT 
    orders.order_date,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    orders
        JOIN
    order_details ON orders.order_id = order_details.order_id
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id group by orders.order_date order by revenue) as sales ;
    
    
    
    
    -- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT name ,revenue ,rn AS rank_ 
FROM
(SELECT category ,name,revenue ,RANK() OVER(PARTITION  BY category order by revenue DESC) AS rn
FROM(select pizza_types.category ,pizza_types.name , SUM(order_details.quantity * pizzas.price) as revenue 
FROM pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id group by  pizza_types.category ,pizza_types.name) as a) as b 
    where rn <=3;