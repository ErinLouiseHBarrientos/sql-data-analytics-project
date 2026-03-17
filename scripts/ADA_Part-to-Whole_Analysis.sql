/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - Measure the contribution of individual categories to the overall total.
    - Determine the percentage share of entities such as products, regions,
      or customer segments within the dataset.
    - Identify dominant contributors and relative distribution across categories.

SQL Features Used:
    - SUM(), AVG()        : Aggregate metrics for each category or dimension.
    - SUM() OVER()        : Calculates the overall total used to derive
                            percentage contribution.
===============================================================================
*/

---------- Part-to-Whole Analysis -----------
-- Which categories contribute the most to overall sales?
WITH category_sales AS (
SELECT
    category,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON        f.product_key = p.product_key
GROUP BY category
)

SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 3), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC
