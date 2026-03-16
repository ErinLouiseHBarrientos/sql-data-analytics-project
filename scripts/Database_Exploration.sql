/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - Examine the database structure and available tables.
    - Review table schemas, column definitions, and metadata.
    - Support understanding of the database before performing analysis or queries.

System Views Used:
    - INFORMATION_SCHEMA.TABLES   : Lists all tables within the database.
    - INFORMATION_SCHEMA.COLUMNS  : Provides column-level details for each table.
===============================================================================
*/

-- Explore All Objects in the Database
SELECT 
* 
FROM INFORMATION_SCHEMA.TABLES

-- Explore All Columns in the Database
SELECT 
* 
FROM INFORMATION_SCHEMA.COLUMNS

-- Explore All Columns for a Specific Table
SELECT 
* 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
