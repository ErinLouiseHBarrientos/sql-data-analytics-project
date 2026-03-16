/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - Evaluate the relative performance of entities (e.g., products, customers,
      regions) based on selected metrics.
    - Identify top-performing and lowest-performing records within the dataset.
    - Support comparative analysis and Top-N reporting.

SQL Features Used:
    - Window Ranking Functions:
        • ROW_NUMBER()  : Assigns a unique sequential number to each row.
        • RANK()        : Assigns the same rank to tied values, with gaps in ranking.
        • DENSE_RANK()  : Assigns the same rank to tied values without gaps.
    - TOP              : Retrieves the highest or lowest N records.
    - GROUP BY         : Aggregates data by specific dimensions.
    - ORDER BY         : Sorts results to determine ranking order.
===============================================================================
*/

/*================================================
--		        Ranking Analysis              --
================================================*/
-- Which 5 products generate the highest revenue?
SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON		  p.product_key = f.product_key
GROUP BY product_name
ORDER BY total_revenue DESC

------- OR -------  -- for more complex use cases
SELECT * 
FROM ( 
	SELECT 
		p.product_name,
		SUM(f.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON		  p.product_key = f.product_key
	GROUP BY product_name)t
WHERE rank_products <= 5 


-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON		  p.product_key = f.product_key
GROUP BY product_name
ORDER BY total_revenue 

------- OR -------  -- for more complex use cases
SELECT *
FROM (
	SELECT
		p.product_name,
		SUM(f.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount)) AS rank_products 
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON		  p.product_key = f.product_key
	GROUP BY p.product_name)t
WHERE rank_products <= 5 


-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON		  c.customer_key = f.customer_key
GROUP BY 
	c.customer_key, 
	c.customer_id, 
	c.first_name, 
	c.last_name
ORDER BY total_revenue DESC

------- OR -------  -- for more complex use cases
SELECT *
FROM (
	SELECT
		c.customer_key,
		c.first_name,
		c.last_name,
		SUM(f.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_customers
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON		  c.customer_key = f.customer_key
	GROUP BY 
		c.customer_key, 
		c.first_name, 
		c.last_name )t
WHERE rank_customers <= 10


-- The 3 customer with the fewest orders placed
SELECT
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON		  c.customer_key = f.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_orders

------- OR -------  -- for more complex use cases (Window Function)
SELECT *
FROM (
	SELECT
		c.customer_key,
		c.first_name,
		c.last_name,
		COUNT(DISTINCT order_number) AS total_orders,
		RANK() OVER (ORDER BY COUNT(DISTINCT order_number)) AS rank_customers
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON		  c.customer_key = f.customer_key
	GROUP BY 
		c.customer_key,
		c.first_name,
		c.last_name )t
WHERE rank_customers <= 3
