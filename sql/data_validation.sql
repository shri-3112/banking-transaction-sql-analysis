-- ============================================================ 
-- BANKING TRANSACTION ANALYSIS 
-- Data Validation & Quality Checks 
-- ============================================================ 
-- Purpose:
 -- Validate row counts, duplicates, NULL values, and blank
 -- values before beginning exploratory and business analysis.
 -- ===========================================================

use banking_analytics;

show tables;
select * from customer_data;
SELECT COUNT(*) AS total_customers
FROM customer_data;

-- Check Missing Values
SELECT
SUM(Customer_ID IS NULL) AS Customer_ID_null,
SUM(Age IS NULL) AS Age_null,
SUM(Customer_Type IS NULL) AS Customer_Type_null,
SUM(City IS NULL) AS City_null,
SUM(Region IS NULL) AS Region_null,
SUM(Bank_Name IS NULL) AS Bank_Name_null,
SUM(Branch_ID IS NULL) AS Branch_ID_null
FROM customer_data;

-- to check blank " " values
SELECT
SUM(TRIM(Customer_Type) = '') AS Customer_Type_blank,
SUM(TRIM(City) = '') AS City_blank,
SUM(TRIM(Region) = '') AS Region_blank,
SUM(TRIM(Bank_Name) = '') AS Bank_Name_blank
FROM customer_data;

-- blank for numeric values
SELECT Customer_ID,Age
FROM customer_data
WHERE Age IS NULL or Age=0;

-- Check blank values in Age column
SELECT COUNT(*) AS blank_age
FROM customer_data
WHERE TRIM(Age) = '';

-- Check for null values in Age column
SELECT COUNT(*) AS null_age
FROM customer_data
WHERE Age IS NULL;

-- Check for blank strings in important categorical columns.
-- TRIM() is used to detect empty or whitespace-only values.
SELECT COUNT(*) AS incomplete_records
FROM customer_data
WHERE TRIM(Age) = ''
  AND TRIM(Customer_Type) = ''
  AND TRIM(City) = '';
  
  SELECT COUNT(*) AS age_and_type
FROM customer_data
WHERE TRIM(Age) = ''
AND TRIM(Customer_Type) = '';

SELECT COUNT(*) AS age_and_city
FROM customer_data
WHERE TRIM(Age) = ''
AND TRIM(City) = '';

SELECT COUNT(*) AS city_and_type
FROM customer_data
WHERE TRIM(City) = ''
AND TRIM(Customer_Type) = '';

-- to find missing values from transaction_data table
SELECT
SUM(Transaction_ID IS NULL) AS Transaction_ID_null,
SUM(Customer_ID IS NULL) AS Customer_ID_null,
SUM(TRIM(Account_Type) = '') AS Account_Type_blank,
SUM(Total_Balance IS NULL) AS Balance_null,
SUM(Transaction_Amount IS NULL) AS Transaction_null,
SUM(Investment_Amount IS NULL) AS Investment_null,
SUM(TRIM(Investment_Type) = '') AS Investment_Type_blank,
SUM(Transaction_Date IS NULL) AS Date_null
FROM transaction_data;

-- duplicate transactions 
SELECT Transaction_ID, COUNT(*)
FROM transaction_data
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;

SELECT
    ROUND(MIN(Transaction_Amount),2) AS min_transaction,
    ROUND(MAX(Transaction_Amount),2) AS max_transaction,
    ROUND(AVG(Transaction_Amount),2) AS avg_transaction
FROM transaction_data;

SELECT
    ROUND(MIN(Total_Balance),2) AS min_balance,
    ROUND(MAX(Total_Balance),2) AS max_balance,
    ROUND(AVG(Total_Balance),2) AS avg_balance
FROM transaction_data;
