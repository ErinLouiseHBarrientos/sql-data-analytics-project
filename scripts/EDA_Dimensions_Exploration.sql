/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - Analyze and understand the structure and contents of dimension tables.
    - Identify unique attribute values and review categorical data used for analysis.

SQL Features Used:
    - DISTINCT : Retrieves unique values from dimension attributes.
    - ORDER BY : Sorts results to improve readability and analysis.
===============================================================================
*/

================================================
--		     Dimensions Exploration           --
================================================

-- Explore All Countires our customers come from
SELECT DISTINCT country 
FROM gold.dim_customers

-- Explore All Categories "The Major Divisions"
SELECT DISTINCT category 
FROM gold.dim_products

-- Explore All Categories and Subcategories
SELECT DISTINCT category, subcategory 
FROM gold.dim_products

-- Explore All Categories, Subcategories, and Product Name
SELECT DISTINCT category, subcategory, product_name 
FROM gold.dim_products
ORDER BY 1, 2, 3
