-- ============================================================ 
-- BANKING TRANSACTION ANALYSIS 
-- Business Analysis 
-- ============================================================ 
-- 
-- Purpose: 
-- Analyze customer segments, regional performance, branch 
-- performance, investments, transaction values, and balances
 -- using relational data from multiple tables. 
 -- 
 -- SQL Concepts: 
 -- INNER JOIN, LEFT JOIN, 3-table JOIN, GROUP BY, HAVING, 
 -- CASE, aggregate functions, ORDER BY, COUNT(DISTINCT) 
 --
 -- ============================================================

-- Business Question:
-- Which customer segment contributes the highest transaction value?

SELECT
    CASE
        WHEN TRIM(c.Customer_Type) = '' THEN 'Unknown'
        ELSE c.Customer_Type
    END AS Customer_Type,

    COUNT(t.Transaction_ID) AS Total_Transactions,

    ROUND(SUM(t.Transaction_Amount),2) AS Total_Transaction_Value,

    ROUND(AVG(t.Transaction_Amount),2) AS Average_Transaction

FROM customer_data c

INNER JOIN transaction_data t
ON c.Customer_ID = t.Customer_ID

GROUP BY Customer_Type

ORDER BY Total_Transaction_Value DESC;

-- Business Question:
-- Which region has the highest average account balance?

SELECT

    c.Region,

    ROUND(AVG(t.Total_Balance),2) AS Average_Balance,

    ROUND(SUM(t.Total_Balance),2) AS Total_Balance

FROM customer_data c

INNER JOIN transaction_data t
ON c.Customer_ID = t.Customer_ID

GROUP BY c.Region

ORDER BY Average_Balance DESC;

-- Business Question:
-- Which bank branches have the largest customer base?

SELECT

    b.Branch_ID,

    b.City,

    COUNT(c.Customer_ID) AS Total_Customers

FROM bank_data b

LEFT JOIN customer_data c
ON b.Branch_ID = c.Branch_ID

GROUP BY
    b.Branch_ID,
    b.City

ORDER BY Total_Customers DESC
LIMIT 10;

-- Business Question:
-- Which bank branches process the highest transaction value?

SELECT

    b.Branch_ID,

    b.City,

    ROUND(SUM(t.Transaction_Amount),2) AS Total_Transaction_Value,

    COUNT(t.Transaction_ID) AS Transactions

FROM bank_data b

INNER JOIN customer_data c
ON b.Branch_ID = c.Branch_ID

INNER JOIN transaction_data t
ON c.Customer_ID = t.Customer_ID

GROUP BY
    b.Branch_ID,
    b.City

ORDER BY Total_Transaction_Value DESC
LIMIT 10;

-- Business Question:
-- Which branches generate the highest revenue per customer?

SELECT

    b.Branch_ID,

    b.City,

    ROUND(b.Firm_Revenue / COUNT(DISTINCT c.Customer_ID),2) AS Revenue_Per_Customer

FROM bank_data b

LEFT JOIN customer_data c
ON b.Branch_ID = c.Branch_ID

GROUP BY
    b.Branch_ID,
    b.City,
    b.Firm_Revenue

HAVING COUNT(DISTINCT c.Customer_ID) > 0

ORDER BY Revenue_Per_Customer DESC;

-- Business Question:
-- Which customer types invest the most?

SELECT

    CASE
        WHEN TRIM(c.Customer_Type) = '' THEN 'Unknown'
        ELSE c.Customer_Type
    END AS Customer_Type,

    ROUND(SUM(t.Investment_Amount),2) AS Total_Investment,

    ROUND(AVG(t.Investment_Amount),2) AS Average_Investment

FROM customer_data c

INNER JOIN transaction_data t
ON c.Customer_ID = t.Customer_ID

GROUP BY Customer_Type

ORDER BY Total_Investment DESC;


-- Business Question:
-- Which customers maintain the highest account balances?

SELECT
    c.Customer_ID,
    CASE
        WHEN TRIM(c.Customer_Type) = '' THEN 'Unknown'
        ELSE c.Customer_Type
    END AS Customer_Type,
    c.Region,
    t.Total_Balance
FROM customer_data c
JOIN transaction_data t
    ON c.Customer_ID = t.Customer_ID
ORDER BY t.Total_Balance DESC
LIMIT 10;

-- Which Region generate the Highest Investment
SELECT
    c.Region,
    ROUND(SUM(t.Investment_Amount),2) AS Total_Investment,
    ROUND(AVG(t.Investment_Amount),2) AS Avg_Investment
FROM customer_data c
JOIN transaction_data t
ON c.Customer_ID = t.Customer_ID
GROUP BY c.Region
ORDER BY Total_Investment DESC;

-- Business Question:
-- Which regions contribute the highest transaction value?

SELECT
    c.Region,
    COUNT(t.Transaction_ID) AS Total_Transactions,
    ROUND(SUM(t.Transaction_Amount),2) AS Total_Transaction_Value,
    ROUND(AVG(t.Transaction_Amount),2) AS Average_Transaction_Value
FROM customer_data c
JOIN transaction_data t
ON c.Customer_ID = t.Customer_ID
GROUP BY c.Region
ORDER BY Total_Transaction_Value DESC;

-- Business Question:
-- Which branches maintain the highest average customer balance?

SELECT
    b.Branch_ID,
    b.City,
    b.Region,
    ROUND(AVG(t.Total_Balance),2) AS Average_Balance,
    COUNT(DISTINCT c.Customer_ID) AS Customers
FROM bank_data b
JOIN customer_data c
ON b.Branch_ID = c.Branch_ID
JOIN transaction_data t
ON c.Customer_ID = t.Customer_ID
GROUP BY
    b.Branch_ID,
    b.City,
    b.Region
ORDER BY Average_Balance DESC
LIMIT 10;