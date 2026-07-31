-- ============================================================
-- BANKING TRANSACTION ANALYSIS
-- Exploratory Data Analysis
-- ============================================================
--
-- Purpose:
-- Explore customer, transaction, regional, and demographic
-- patterns in the banking dataset.
--
-- SQL Concepts:
-- COUNT(), SUM(), AVG(), GROUP BY, ORDER BY,
-- CASE, ROUND(), subqueries, NULLIF(), LIMIT
--
-- ============================================================

-- Business Question:
-- How many customers are there?

SELECT COUNT(*)
FROM custome
r_data;

-- Business Question:
-- Total transaction value

SELECT SUM(Transaction_Amount)
FROM transaction_data;

-- Business Question:
-- How are customers distributed across different customer types?

SELECT
    CASE
        WHEN TRIM(Customer_Type) = '' THEN 'Unknown'
        ELSE Customer_Type
    END AS Customer_Type,
    COUNT(*) AS Customer_Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_data), 2) AS Percentage
FROM customer_data
GROUP BY
    CASE
        WHEN TRIM(Customer_Type) = '' THEN 'Unknown'
        ELSE Customer_Type
    END
ORDER BY Customer_Count DESC;

-- Business Question:
-- What is the average age of each customer type?

SELECT
    CASE
        WHEN TRIM(Customer_Type) = '' THEN 'Unknown'
        ELSE Customer_Type
    END AS Customer_Type,
    ROUND(AVG(NULLIF(Age, '')), 2) AS Average_Age,
    COUNT(*) AS Total_Customers
FROM customer_data
GROUP BY
    CASE
        WHEN TRIM(Customer_Type) = '' THEN 'Unknown'
        ELSE Customer_Type
    END
ORDER BY Average_Age DESC;

-- Business Question:
-- Which regions have the highest number of customers?

SELECT
    Region,
    COUNT(*) AS Customer_Count
FROM customer_data
GROUP BY Region
ORDER BY Customer_Count DESC;

-- Business Question:
-- Which cities have the highest number of customers?

SELECT
    CASE
        WHEN TRIM(City) = '' THEN 'Unknown'
        ELSE City
    END AS City,
    COUNT(*) AS Customer_Count
FROM customer_data
GROUP BY
    CASE
        WHEN TRIM(City) = '' THEN 'Unknown'
        ELSE City
    END
ORDER BY Customer_Count DESC
LIMIT 10;

-- Business Question:
-- How are customers distributed across different banks?

SELECT
    Bank_Name,
    COUNT(*) AS Customer_Count
FROM customer_data
GROUP BY Bank_Name
ORDER BY Customer_Count DESC;

-- Business Question:
-- How many records have missing customer information?

SELECT
    SUM(TRIM(Age) = '') AS Missing_Age,
    SUM(TRIM(Customer_Type) = '') AS Missing_Customer_Type,
    SUM(TRIM(City) = '') AS Missing_City
FROM customer_data;