-- ============================================================ 
-- BANKING TRANSACTION ANALYSIS 
-- Transaction Analysis 
-- ============================================================
 -- 
 -- Purpose: 
 -- Analyze transaction value, transaction trends, account types, 
 -- investment activity, customer balances, and transaction sizes.
 -- 
 -- SQL Concepts: -- SUM(), COUNT(), AVG(), GROUP BY, ORDER BY, 
 -- CASE, subqueries, DATE_FORMAT(), ROUND(), LIMIT 
 --
 -- ============================================================

-- Business Question:
-- What is the total value of all transactions?

SELECT
    ROUND(SUM(Transaction_Amount),2) AS Total_Transaction_Value
FROM transaction_data;

-- Business Question:
-- How does transaction volume change over time?

SELECT
    DATE_FORMAT(Transaction_Date,'%Y-%m') AS Month,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(Transaction_Amount),2) AS Total_Value
FROM transaction_data
GROUP BY DATE_FORMAT(Transaction_Date,'%Y-%m')
ORDER BY Month;

-- Business Question:
-- Which account type processes the highest transaction value?

SELECT
    Account_Type,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(Transaction_Amount),2) AS Transaction_Value,
    ROUND(AVG(Transaction_Amount),2) AS Average_Transaction
FROM transaction_data
GROUP BY Account_Type
ORDER BY Transaction_Value DESC;

-- Business Question:
-- Which investment products attract the highest investment amount?

SELECT
    Investment_Type,
    COUNT(*) AS Customers,
    ROUND(SUM(Investment_Amount),2) AS Total_Investment,
    ROUND(AVG(Investment_Amount),2) AS Average_Investment
FROM transaction_data
GROUP BY Investment_Type
ORDER BY Total_Investment DESC;

-- Business Question:
-- Who made the largest transactions?

SELECT
    Customer_ID,
    Transaction_ID,
    Transaction_Amount
FROM transaction_data
ORDER BY Transaction_Amount DESC
LIMIT 10;

-- Business Question:
-- How many customers have an account balance greater than the average balance?

SELECT
    COUNT(*) AS High_Value_Customers
FROM transaction_data
WHERE Total_Balance >
(
    SELECT AVG(Total_Balance)
    FROM transaction_data
);

-- Business Question:
-- How are transactions distributed by size?

SELECT
    CASE
        WHEN Transaction_Amount < 1000 THEN 'Small'
        WHEN Transaction_Amount BETWEEN 1000 AND 5000 THEN 'Medium'
        ELSE 'Large'
    END AS Transaction_Size,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(Transaction_Amount),2) AS Total_Value
FROM transaction_data
GROUP BY Transaction_Size
ORDER BY Total_Value DESC;

