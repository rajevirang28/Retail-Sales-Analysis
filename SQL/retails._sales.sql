-- create table
CREATE TABLE retail_sales (

    invoice VARCHAR(20),

    stockcode VARCHAR(20),

    description TEXT,

    quantity INTEGER,

    invoicedate TIMESTAMP,

    price NUMERIC(10,2),

    customer_id NUMERIC,

    country VARCHAR(100),

    total_sales NUMERIC(12,2),

    year INTEGER,	

    month VARCHAR(20),

    month_number INTEGER,

    quarter VARCHAR(5),

    day INTEGER,

    weekday VARCHAR(20),

    hour INTEGER

);
-- import the clean dataset

-- Total Records
SELECT COUNT(*) AS total_records
FROM retail_sales;

-- Total Revenue
SELECT ROUND(SUM(total_sales),2) AS total_revenue
FROM retail_sales;

-- Total Orders
SELECT COUNT(DISTINCT invoice) AS total_orders
FROM retail_sales;

-- Total Customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;

-- Total Products
SELECT COUNT(DISTINCT description) AS total_products
FROM retail_sales;

-- Average Order Value
SELECT ROUND(SUM(total_sales) / COUNT(DISTINCT invoice),2) AS average-order_value
FROM retail_salesa;

-- Average Product Price
SELECT ROUND(AVG(price),2) AS average_price
FROM retail_sales;

-- Average Quantity Sold
SELECT ROUND(AVG(quantity),2) AS average_quatity
FROM retail_Sales;

-- Revenue by Year
SELECT year, ROUND(SUM(total_sales),2) AS revenue
FROM retail_sales
GROUP BY year
ORDER BY year;

-- Revenue by Month
SELECT year, month, ROUND(SUM(total_sales),2) AS revenue
FROM retail_sales
GROUP BY year, month, month_number
ORDER BY year, month_number;

-- Revenue BY Quater
SELECT quarter, ROUND(SUM(total_sales),2) AS revenue
FROM retail_sales
GROUP BY quarter
ORDER BY quarter;

-- Revenue by Weekday
SELECT weekday, ROUND(SUM(total_sales),2) AS revenue
FROM retail_sales
GROUP BY weekday
ORDER BY revenue DESC;

-- Revenue by Hour
SELECT hour, ROUND(SUM(total_sales),2) AS revenue
FROM retail_sales
GROUP BY hour
ORDER BY hour;

-- Top 10 Products
SELECT description, ROUND(SUM(total_sales),2) AS revenue
FROM retail_sales
GROUP BY description
ORDER BY revenue DESC
LIMIT 10;

-- Top 10 Products by Quantity
SELECT description, SUM(quantity) AS quantity_sold
FROMretail_sales
GROUP BY description
ORDER BY quantity_sold DESC
LIMIT 10;

-- Most Expensive Products
SELECT
description,
MAX(price) AS highest_price
FROM retail_sales
GROUP BY description
ORDER BY highest_price DESC
LIMIT 10;

-- Top 10 Customers by Revenue
SELECT customer_id, ROUND(SUM(total_sales),2)AS revenue
FROM retail_sales
WHERE customer_is IS NOT NULL
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 10;

-- Customer Lifetime Value (CLV)
SELECT customer_id, COUNT(DISTINCT invoice) AS total_orders, ROUND(SUM(total_sales),2) AS lifetime_value
FROM retail_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY lifetime_value DESC;

-- Top Customers using RANK()
SELECT customer_id, ROUND(SUM(total_sales),2) AS revenue,
RANK() OVER(ORDER BY SUM(total_sales) DESC) AS customer_rank
FROM retail_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id;

-- Dense Ranking
SELECT description, ROUND(SUM(total_sales),2) AS revenue,
DENSE_RANK() OVER(ORDER BY SUM(total_sales) DESC) AS product_rank
FROM retail_sales
GROUP BY description;

-- Top 5 Products in Every Country
WITH ProductSales AS (
SELECT country, description, SUM(total_sales) revenue,
ROW_NUMBER() OVER( PARTITION BY country ORDER BY SUM(total_sales) DESC) rn
FROM retail_sales
GROUP BY country, description
)

SELECT * FROM ProductSales
WHERE rn<=5;

-- Running Total Revenue
SELECT invoice_date, SUM(total_sales) revenue, SUM(SUM(total_sales))
OVER( ORDER BY invoice_date
) running_total
FROM retail_sales
GROUP BY invoice_date
ORDER BY invoice_date;

-- Monthly Revenue
WITH MonthlyRevenue AS (

SELECT year, month_number, month, SUM(total_sales) revenue
FROM retail_sales
GROUP BY year,month_number,month
)
SELECT *
FROM MonthlyRevenue
ORDER BY year,month_number;

-- Month-over-Month Growth
WITH MonthlyRevenue AS (
SELECT year, month_number, month, SUM(total_sales) revenue
FROM retail_sales
GROUP BY year,month_number,month
)
SELECT year, month, ROUND(revenue,2),
ROUND( LAG(revenue)
OVER(
ORDER BY year,month_number
),2) previous_month,
ROUND(
revenue- LAG(revenue)
OVER(
ORDER BY year,month_number
),2) growth
FROM MonthlyRevenue;

-- Best Selling Day
SELECT day, ROUND(SUM(total_sales),2) revenue
FROM retail_sales
GROUP BY day
ORDER BY revenue DESC;

-- Best Shopping Hour
SELECT hour, COUNT(*) orders,
ROUND(SUM(total_sales),2) revenue
FROM retail_sales
GROUP BY hour
ORDER BY revenue DESC;

-- Top Country
SELECT country,
ROUND(SUM(total_sales),2) revenue
FROM retail_sales
GROUP BY country
ORDER BY revenue DESC;

-- Revenue Contribution %
SELECT country,
ROUND(SUM(total_sales),2) revenue,
ROUND(
SUM(total_sales) /
(
SELECT SUM(total_sales)
FROM retail_sales
) *100,2) AS contribution_percent
FROM retail_sales
GROUP BY country
ORDER BY revenue DESC;

-- ABC Product Analysis
WITH ProductRevenue AS (
SELECT description,
SUM(total_sales) revenue
FROM retail_sales
GROUP BY description
)
SELECT description,
ROUND(revenue,2),
CASE
WHEN revenue>=100000 THEN 'A'
WHEN revenue>=25000 THEN 'B'
ELSE 'C'
END
AS category
FROM ProductRevenue
ORDER BY revenue DESC;

-- Most Frequently Purchased Products
SELECT description,
COUNT(*) frequency
FROM retail_sales
GROUP BY description
ORDER BY frequency DESC
LIMIT 20;

-- Highest Average Basket Size
SELECT invoice,
SUM(quantity) basket_size
FROM retail_sales
GROUP BY invoice
ORDER BY basket_size DESC
LIMIT 20;