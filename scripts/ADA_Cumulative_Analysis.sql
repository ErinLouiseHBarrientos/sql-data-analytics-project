/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - Analyze cumulative performance by calculating running totals and moving
      averages for key metrics.
    - Track how metrics accumulate over time to evaluate overall growth.
    - Support long-term trend analysis and performance monitoring.

SQL Features Used:
    - Window Functions:
        • SUM() OVER() : Calculates cumulative totals across ordered rows.
        • AVG() OVER() : Computes moving or cumulative averages over a defined window.
===============================================================================
*/

---------- Cumulative Analyzes -----------
-- calculate the total sales per month
-- get the running total of sales over time
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM (
	SELECT 
		DATETRUNC(month, order_date) AS order_date,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month, order_date)
)t

-- limit the running total for one year (each year)
-- reset or starts from scrath per year
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_sales
FROM (
	SELECT 
		DATETRUNC(month, order_date) AS order_date,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month, order_date)
)t

-- cummulative values for each year
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM (
	SELECT 
		DATETRUNC(year, order_date) AS order_date,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(year, order_date)
)t

-- total sales per month with the running total of sales over time and
-- get the moving average price over time
SELECT
	order_date,
	total_sales,
	--SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM (
	SELECT 
		DATETRUNC(year, order_date) AS order_date,
		SUM(sales_amount) AS total_sales,
		AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(year, order_date)
)t
