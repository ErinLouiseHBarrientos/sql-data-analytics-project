/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - Segment data into meaningful groups to uncover patterns and actionable insights.
    - Enable targeted analysis for entities such as customers, products, or regions.
    - Support decision-making through classification of data into defined segments
      (e.g., high-value vs low-value, active vs inactive).

SQL Features & Techniques Used:
    - CASE     : Defines custom segmentation logic based on business rules.
    - GROUP BY : Aggregates data within each segment for summary analysis.
===============================================================================
*/

---------- Data Segmentation -----------
-- segment products into cost ranges 
SELECT 
	product_key,
	product_name,
	product_cost,
	CASE WHEN product_cost < 100 THEN 'below 100'
		 WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
		 WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
		 ELSE 'above 1000'
	END AS cost_range
FROM gold.dim_products


-- count how many products fall into each segment
WITH product_segment AS (
SELECT 
	product_key,
	product_name,
	product_cost,
	CASE WHEN product_cost < 100 THEN 'below 100'
		 WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
		 WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
		 ELSE 'above 1000'
	END AS cost_range
FROM gold.dim_products
)
SELECT 
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC


-- ANOTHER EXAMPLE --
-- group customers into three segments based on their spending behavior:
-- VIP: Customers with at least 12 months history and spending more than EU5,000
-- Regular: Customers with at least 12 months history but spends EU5,000 or less
-- New: Customers with a lifespan less than 12 months
-- find the total number of customers by each group

-- found the total spend, and lifespan
SELECT 
	c.customer_key,
	SUM(f.sales_amount) AS total_spend,
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON		  f.customer_key = c.customer_key
GROUP BY c.customer_key

-- segemented customers
WITH customer_spending_behavior AS (
SELECT 
	c.customer_key,
	SUM(f.sales_amount) AS total_spend,
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON		  f.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT
	customer_key,
	total_spend,
	lifespan,
	CASE WHEN lifespan >= 12 AND total_spend > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND total_spend <= 5000 THEN 'Regular'
		 ELSE 'New'
	END AS customer_segment
FROM customer_spending_behavior


-- total number of customers by each group
WITH customer_spending_behavior AS (
SELECT 
	c.customer_key,
	SUM(f.sales_amount) AS total_spend,
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON		  f.customer_key = c.customer_key
GROUP BY c.customer_key
)
SELECT
	customer_segment,
	COUNT(customer_key) AS total_customers
FROM (
	SELECT
		customer_key,
		CASE WHEN lifespan >= 12 AND total_spend > 5000 THEN 'VIP'
			 WHEN lifespan >= 12 AND total_spend <= 5000 THEN 'Regular'
			 ELSE 'New'
		END AS customer_segment
	FROM customer_spending_behavior )t
GROUP BY customer_segment
ORDER BY total_customers DESC
