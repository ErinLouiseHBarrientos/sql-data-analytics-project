/*
===============================================================================
	Product Report
===============================================================================
Purpose:
    - Consolidate key product metrics, attributes, and performance insights
      into a unified analytical view.

Highlights:
    I.   Extracts essential product attributes:
            - product name
            - category
            - subcategory
            - cost
    II.  Segments products based on revenue performance
         (e.g., High, Mid, Low performers).
    III. Aggregates product-level metrics:
            - total orders
            - total sales
            - total quantity sold
            - total unique customers
            - product lifespan (in months)
    IV.  Calculates key performance indicators (KPIs):
            - recency (months since last sale)
            - average order revenue (AOR)
            - average monthly revenue
===============================================================================
*/

/*======================================================
	Create Report: gold.report_products
======================================================*/
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

WITH base_query AS (
/*-----------------------------------------------------------------------------
	Base Query: Retrieve core columns from dim_prodcuts and fact_sales
-----------------------------------------------------------------------------*/
SELECT 
	f.order_number,
	f.order_date,
	f.customer_key,
	f.sales_amount,
	f.quantity,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.product_cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON		  f.product_key = p.product_key
WHERE order_date IS NOT NULL
)

, product_aggregation AS (
/*-----------------------------------------------------------------------------
	Product Aggregation: Summarize key metrics at the product level
-----------------------------------------------------------------------------*/
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	product_cost,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
	MAX(order_date) AS last_sale_date,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 2) AS avg_selling_price
FROM base_query
GROUP BY 
	product_key,
	product_name,
	category,
	subcategory,
	product_cost
)

/*-----------------------------------------------------------------------------
	Final Query: Combines all product results into one output
-----------------------------------------------------------------------------*/
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	product_cost,
	last_sale_date,
	DATEDIFF(month, last_sale_date, GETDATE()) AS recency_in_months,
	CASE WHEN total_sales > 50000 THEN 'High-Performer'
		 WHEN total_sales >= 10000 THEN 'Mid-Range'
		 ELSE 'Low-Performer'
	END AS product_group,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- average order revenue (AOR)
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales / total_orders
	END AS avg_order_revenue,
	-- average monthly revenue
	CASE WHEN lifespan = 0 THEN 0
		 ELSE total_sales / lifespan
	END AS avg_monthly_revenue
FROM product_aggregation
