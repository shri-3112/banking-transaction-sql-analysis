-- ============================================================ 
-- BANKING TRANSACTION ANALYSIS 
-- Advanced SQL Analysis 
-- ============================================================ 
-- 
-- Purpose: 
-- Apply advanced SQL techniques to rank branches and customers,
 -- calculate running totals, compare regional performance, and 
 -- measure branch contribution to overall transaction value. 
 -- 
 -- SQL Concepts: 
 -- CTEs, RANK(), ROW_NUMBER(), DENSE_RANK(), 
 -- PARTITION BY, window functions, running totals, 
 -- subqueries, multi-table JOINs 
 -- 
 -- ============================================================

-- Business Question:
-- Rank branches based on the total transaction value they process.

WITH branch_transactions AS (
    SELECT
        b.Branch_ID,
        b.City,
        b.Region,
        SUM(t.Transaction_Amount) AS Total_Transaction_Value
    FROM bank_data b
    JOIN customer_data c
        ON b.Branch_ID = c.Branch_ID
    JOIN transaction_data t
        ON c.Customer_ID = t.Customer_ID
    GROUP BY
        b.Branch_ID,
        b.City,
        b.Region
)

SELECT *,
       RANK() OVER (ORDER BY Total_Transaction_Value DESC) AS Branch_Rank
FROM branch_transactions
ORDER BY Branch_Rank;

-- Business Question:
-- Who is the highest-balance customer in each region?

WITH ranked_customers AS (
    SELECT
        c.Region,
        c.Customer_ID,
        t.Total_Balance,
        ROW_NUMBER() OVER(
            PARTITION BY c.Region
            ORDER BY t.Total_Balance DESC
        ) AS rn
    FROM customer_data c
    JOIN transaction_data t
        ON c.Customer_ID = t.Customer_ID
)

SELECT *
FROM ranked_customers
WHERE rn = 1;

-- Business Question:
-- What is the cumulative transaction value over time?

WITH monthly_transactions AS (
    SELECT
        DATE_FORMAT(Transaction_Date, '%Y-%m') AS Month,
        SUM(Transaction_Amount) AS Monthly_Total
    FROM transaction_data
    GROUP BY DATE_FORMAT(Transaction_Date, '%Y-%m')
)

SELECT
    Month,
    Monthly_Total,
    SUM(Monthly_Total) OVER(
        ORDER BY Month
    ) AS Running_Total
FROM monthly_transactions;

-- Business Question:
-- Rank customers by account balance.

SELECT
    Customer_ID,
    Total_Balance,
    DENSE_RANK() OVER(
        ORDER BY Total_Balance DESC
    ) AS Balance_Rank
FROM transaction_data;

-- Business Question:
-- Find the top-performing branches in each region.

WITH ranked_branches AS (
    SELECT
        b.Region,
        b.Branch_ID,
        b.City,
        SUM(t.Transaction_Amount) AS Total_Transaction_Value,

        ROW_NUMBER() OVER(
            PARTITION BY b.Region
            ORDER BY SUM(t.Transaction_Amount) DESC
        ) AS rn

    FROM bank_data b
    JOIN customer_data c
        ON b.Branch_ID = c.Branch_ID
    JOIN transaction_data t
        ON c.Customer_ID = t.Customer_ID

    GROUP BY
        b.Region,
        b.Branch_ID,
        b.City
)

SELECT *
FROM ranked_branches
WHERE rn <= 5;

-- Business Question:
-- What percentage of total transaction value comes from each branch?

SELECT
    b.Branch_ID,
    b.City,

    ROUND(SUM(t.Transaction_Amount),2) AS Branch_Total,

    ROUND(
        SUM(t.Transaction_Amount) * 100 /
        (SELECT SUM(Transaction_Amount) FROM transaction_data),
        2
    ) AS Percentage_Contribution

FROM bank_data b
JOIN customer_data c
    ON b.Branch_ID = c.Branch_ID
JOIN transaction_data t
    ON c.Customer_ID = t.Customer_ID

GROUP BY
    b.Branch_ID,
    b.City

ORDER BY Percentage_Contribution DESC;

-- Business Question:
-- Which customers have balances above their region's average balance?

WITH region_avg AS (
    SELECT
        c.Region,
        AVG(t.Total_Balance) AS Avg_Region_Balance
    FROM customer_data c
    JOIN transaction_data t
        ON c.Customer_ID = t.Customer_ID
    GROUP BY c.Region
)

SELECT
    c.Customer_ID,
    c.Region,
    t.Total_Balance,
    ROUND(r.Avg_Region_Balance,2) AS Avg_Region_Balance
FROM customer_data c
JOIN transaction_data t
    ON c.Customer_ID = t.Customer_ID
JOIN region_avg r
    ON c.Region = r.Region
WHERE t.Total_Balance > r.Avg_Region_Balance
ORDER BY c.Region, t.Total_Balance DESC;