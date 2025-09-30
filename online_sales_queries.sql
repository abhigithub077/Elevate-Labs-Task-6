ALTER TABLE online_sales 
MODIFY order_date DATE;

UPDATE online_sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');


-- Extract Month and Year from order_date
SELECT 
    order_id,
    STR_TO_DATE(order_date, '%d-%m-%Y') AS parsed_date,
    YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_year,
    MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_month,
    amount
FROM online_sales
ORDER BY parsed_date;


-- Monthly Revenue Summary (Total revenue by year and month)
SELECT 
    YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_year,
    MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_month,
    SUM(amount) AS total_revenue
FROM online_sales
GROUP BY order_year, order_month
ORDER BY order_year, order_month;


-- Total Revenue (SUM) ordered by revenue
SELECT 
    YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_year,
    MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_month,
    SUM(amount) AS total_revenue
FROM online_sales
GROUP BY order_year, order_month
ORDER BY total_revenue DESC;


-- Monthly Order Volume (COUNT DISTINCT orders)
SELECT 
    YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_year,
    MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_month,
    COUNT(DISTINCT order_id) AS total_orders
FROM online_sales
GROUP BY order_year, order_month
ORDER BY order_year, order_month;


-- Combined Revenue + Order Volume
SELECT 
    YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_year,
    MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_month,
    SUM(amount) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders
FROM online_sales
GROUP BY order_year, order_month
ORDER BY order_year, order_month;


-- Last 12 Months Summary 
SELECT 
    YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_year,
    MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_month,
    SUM(amount) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders
FROM online_sales
WHERE STR_TO_DATE(order_date, '%d-%m-%Y') >= DATE_SUB(
    (SELECT MAX(STR_TO_DATE(order_date, '%d-%m-%Y')) FROM online_sales),
    INTERVAL 12 MONTH
)
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

