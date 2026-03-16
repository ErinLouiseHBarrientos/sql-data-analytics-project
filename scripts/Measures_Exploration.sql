/*
===============================================================================
	Measures Exploration 
===============================================================================
Purpose:
    - Analyze aggregated metrics to understand overall dataset performance.
    - Calculate summary statistics such as totals, averages, and record counts.
    - Support quick insights, trend identification, and anomaly detection.

SQL Functions Used:
    - COUNT() : Counts the number of records.
    - SUM()   : Calculates the total value of numeric fields.
    - AVG()   : Computes the average value of numeric fields.
===============================================================================
*/

/*================================================
--		      Measures Exploration            --
================================================*/
-- Find the total sales
SELECT 
	SUM(sales_amount) AS total_sales 
FROM gold.fact_sales


-- Find how many items were sold
SELECT 
	SUM(quantity) AS total_items_sold 
FROM gold.fact_sales


-- Find the average selling price
SELECT 
	AVG(price) AS average_selling_price 
FROM gold.fact_sales


-- Find the total number of orders
SELECT 
	COUNT(DISTINCT order_number) AS total_count_distinct_order 
FROM gold.fact_sales


-- Find the total number of products
-- then check with DISTINCT
SELECT 
	COUNT(product_key) AS total_count_product 
FROM gold.dim_products

SELECT 
	COUNT(DISTINCT product_key) AS total_count_product 
FROM gold.dim_products

------- OR USE -------
SELECT 
	COUNT(product_name) AS total_count_product 
FROM gold.dim_products

SELECT 
	COUNT(DISTINCT product_name) AS total_count_product 
FROM gold.dim_products


-- Find the total number of customers
-- then check with DISTINCT
SELECT 
	COUNT(customer_key) AS total_count_customers 
FROM gold.dim_customers

SELECT 
	COUNT(DISTINCT customer_key) AS total_count_customers 
FROM gold.dim_customers

------- OR USE -------
SELECT 
	COUNT(customer_id) AS total_count_customers 
FROM gold.dim_customers

SELECT 
	COUNT(DISTINCT customer_id) AS total_count_customers 
FROM gold.dim_customers


-- Find the total number of customers that has place an order
SELECT 
	COUNT(DISTINCT customer_key) AS total_count_customers 
FROM gold.fact_sales 
HAVING COUNT(order_number) >= 1


-- Generate a report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, 
	SUM(sales_amount) AS measure_value 
FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', 
	SUM(quantity) 
FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', 
	AVG(price) 
FROM gold.fact_sales
UNION ALL
SELECT 'Total # Orders',
	COUNT(DISTINCT order_number) 
FROM gold.fact_sales
UNION ALL
SELECT 'Total # Customers', 
	COUNT(customer_key) 
FROM gold.dim_customers
UNION ALL 
SELECT 'Total # Customers w/ order', 
	COUNT(DISTINCT customer_key) 
FROM gold.fact_sales 
HAVING COUNT(order_number) > 0
