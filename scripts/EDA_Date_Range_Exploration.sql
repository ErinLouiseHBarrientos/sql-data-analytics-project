/*
===============================================================================
Date Range Exploration
===============================================================================
Purpose:
    - Identify the earliest and latest dates in the dataset.
    - Determine the temporal coverage and historical boundaries of key records.
    - Support data validation and time-based analysis.

SQL Functions Used:
    - MIN()      : Returns the earliest date in the dataset.
    - MAX()      : Returns the most recent date in the dataset.
    - DATEDIFF() : Calculates the time span between dates.
===============================================================================
*/

/*================================================
--	        Date Range Exploration            --
================================================*/
-- Find the date of the first and last order
-- How many years of sales are available
SELECT 
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales


-- Find the youngest and the oldest customer
SELECT 
	MIN(birthdate) AS oldest_customer,
	DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age,
	MAX(birthdate) AS youngest_customer,
	DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers
