/*
===============================================================================
Performance Analysis (Year-over-Year)
===============================================================================
Purpose:
    - Evaluate the performance of entities (e.g., products, customers, regions)
      across different time periods.
    - Compare current metrics with previous periods to identify growth,
      decline, or performance trends.
    - Support benchmarking and performance monitoring through period-over-
      period comparisons such as YoY (Year-over-Year) and MoM (Month-over-Month).

SQL Features Used:
    - LAG()        : Retrieves values from previous rows to enable period-to-
                     period comparisons.
    - AVG() OVER() : Calculates averages across defined partitions for
                     performance benchmarking.
    - CASE         : Implements conditional logic to classify trends
                     (e.g., growth, decline, stable).
===============================================================================
*/

---------- Performance Analysis -----------
-- analyze the yearly performance of products (sales)
SELECT
	YEAR(f.order_date) AS order_year,
	p.product_name,
	SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON		  f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(f.order_date), p.product_name


-- compare product's sales (yearly performance) to its average sales performance
WITH yearly_product_sales AS (
	SELECT
		YEAR(f.order_date) AS order_year,
		p.product_name,
		SUM(f.sales_amount) AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON		  f.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(f.order_date), p.product_name
)
SELECT
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS current_and_avg_diff,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg' 
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg' 
		 ELSE 'Average'
	END AS avg_change
FROM yearly_product_sales
ORDER BY 
	product_name, 
	order_year


-- compare product's sales (yearly performance) to its previous year's sales
WITH yearly_product_sales AS (
	SELECT
		YEAR(f.order_date) AS order_year,
		p.product_name,
		SUM(f.sales_amount) AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON		  f.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY 
		YEAR(f.order_date), 
		p.product_name
)
-- note: this whole example is a Year-over-year Analysis  <-- long-term analysis
SELECT
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS current_and_avg_diff,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg' 
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg' 
		 ELSE 'Average'
	END AS avg_change,
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS prev_yr_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS current_and_prev_diff,
	CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase' 
		 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease' 
		 ELSE 'No Change'
	END AS prev_yr_change
FROM yearly_product_sales
ORDER BY 
	product_name, 
	order_year
