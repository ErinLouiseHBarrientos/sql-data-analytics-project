/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - Analyze how key metrics evolve across different time periods.
    - Identify trends, growth patterns, seasonality, and fluctuations over time.
    - Measure increases or decreases in performance across defined intervals
      (e.g., monthly, quarterly, yearly).

SQL Features Used:
    - Date Functions:
        • DATEPART()  : Extracts specific components of a date (e.g., year, month).
        • DATETRUNC() : Truncates dates to a defined time interval for grouping.
        • FORMAT()    : Formats date values for clearer reporting output.
    - Aggregate Functions:
        • SUM(), COUNT(), AVG() : Calculate summarized metrics over time.
===============================================================================
*/

---------- Analyze Change-Over-Time -----------
-- analyze sales performance over-time (aggregation: by year)
-- which year had the highest and lowest revenue?
-- which is the best and worst year?
-- are we gaining customers over time?
-- is the revenue increasing or decreasing?
SELECT 
	YEAR(order_date) AS order_year,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

-- changed aggregation from year to month
-- how each month is performing on avereage?
-- which month is the best and worst for sales?
SELECT 
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date)

-- alternative:
-- aggregating the data of a month of specific year
SELECT 
	YEAR(order_date) AS order_year,
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)

-- alternative/s:
-- to format the date into one column (year and month)
SELECT 
	DATETRUNC(month, order_date) AS order_date,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)

-- to format the date into a specific way (format)
SELECT 
	FORMAT(order_date, 'yyyy-MMM') AS order_date,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM')
