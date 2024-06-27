SELECT COUNT(DISTINCT order_number) AS total_orders
FROM bazaar;
SELECT SUM(amount_per_unit * ordered_quantity) AS total_sales_revenue
FROM bazaar;
SELECT AVG(ordered_quantity) AS average_order_quantity
FROM bazaar;
SELECT order_warehouse_id,
    store_id,
    COUNT(*) AS order_count
FROM bazaar
GROUP BY order_warehouse_id,
    store_id
ORDER BY order_warehouse_id,
    store_id;
SELECT item_id,
    SUM(ordered_quantity) AS total_quantity_sold
FROM bazaar
GROUP BY item_id
ORDER BY total_quantity_sold DESC;
SELECT SUM(item_discount * ordered_quantity) / SUM(ordered_quantity) AS average_discount_rate
FROM bazaar
WHERE item_discount >= 0;
SELECT order_warehouse_id,
    SUM(amount_per_unit * ordered_quantity) / COUNT(*) AS average_order_value
FROM bazaar
GROUP BY order_warehouse_id
ORDER BY average_order_value DESC
LIMIT 1;
SELECT store_id,
    SUM(amount_per_unit * ordered_quantity) AS total_revenue
FROM bazaar
GROUP BY store_id
ORDER BY total_revenue DESC;
SELECT store_id AS customer_id,
    SUM(amount_per_unit * ordered_quantity) AS total_amount_spent
FROM bazaar
GROUP BY store_id
ORDER BY total_amount_spent DESC
LIMIT 5;
SELECT abc.year_and_month,
    abc.total_revenue,
    previous.total_revenue AS previous_month_revenue,
    (
        (abc.total_revenue - previous.total_revenue) / previous.total_revenue
    ) * 100 AS month_over_month_growth_rate
FROM (
        SELECT CASE
                WHEN order_date LIKE '%/%/%' THEN DATE_FORMAT(STR_TO_DATE(order_date, '%d/%m/%Y'), '%Y-%m')
                ELSE DATE_FORMAT(STR_TO_DATE(order_date, '%Y-%m-%d'), '%Y-%m')
            END AS year_and_month,
            SUM(amount_per_unit * ordered_quantity) AS total_revenue
        FROM bazaar
        GROUP BY year_and_month
    ) AS abc
    LEFT JOIN (
        SELECT CASE
                WHEN order_date LIKE '%/%/%' THEN DATE_FORMAT(STR_TO_DATE(order_date, '%d/%m/%Y'), '%Y-%m')
                ELSE DATE_FORMAT(STR_TO_DATE(order_date, '%Y-%m-%d'), '%Y-%m')
            END AS year_and_month,
            SUM(amount_per_unit * ordered_quantity) AS total_revenue
        FROM bazaar
        GROUP BY year_and_month
    ) AS previous ON abc.year_and_month = DATE_FORMAT(
        DATE_ADD(
            STR_TO_DATE(
                CONCAT(previous.year_and_month, '-01'),
                '%Y-%m-%d'
            ),
            INTERVAL 1 MONTH
        ),
        '%Y-%m'
    )
ORDER BY abc.year_and_month;
SELECT (
        COUNT(
            DISTINCT CASE
                WHEN order_status = 'CANCELLED' THEN order_number
            END
        ) / COUNT(DISTINCT order_number)
    ) * 100 AS percentage_cancelled
FROM bazaar;