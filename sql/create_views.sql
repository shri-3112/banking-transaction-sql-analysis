-- ============================================================ 
-- BANKING TRANSACTION ANALYSIS 
-- Reusable Data Views 
-- ============================================================ 
-- 
-- Purpose: 
-- This script creates reusable SQL views to simplify analysis 
-- of the banking dataset. 
-- 
-- View 1: customer_data_clean 
-- Creates a cleaned customer dataset by handling blank values 
-- in Age, Customer_Type, and City.
-- 
 -- View 2: banking_master 
 -- Creates a consolidated dataset by combining transaction,
 -- customer, and branch information using SQL JOINs. 
 -- 
 -- These views reduce repetitive data-cleaning and JOIN logic 
 -- and provide a consistent foundation for further analysis. 
 -- 
 -- ============================================================

# creating clean view
CREATE VIEW customer_data_clean AS
SELECT
    Customer_ID,

    CASE
        WHEN TRIM(Age) = '' THEN NULL
        ELSE Age
    END AS Age,

    CASE
        WHEN TRIM(Customer_Type) = '' THEN 'Unknown'
        ELSE Customer_Type
    END AS Customer_Type,

    CASE
        WHEN TRIM(City) = '' THEN 'Unknown'
        ELSE City
    END AS City,

    Region,
    Bank_Name,
    Branch_ID

FROM customer_data;

# master table 
CREATE VIEW banking_master AS
SELECT

    t.Transaction_ID,
    t.Transaction_Date,
    t.Account_Type,
    t.Transaction_Amount,
    t.Total_Balance,
    t.Investment_Amount,
    t.Investment_Type,

    c.Customer_ID,
    c.Age,
    c.Customer_Type,
    c.City,
    c.Region,
    c.Bank_Name,

    b.Branch_ID,
    b.Firm_Revenue,
    b.Expenses,
    b.Profit_Margin

FROM transaction_data t

LEFT JOIN customer_data_clean c
ON t.Customer_ID = c.Customer_ID

LEFT JOIN bank_data b
ON c.Branch_ID = b.Branch_ID;