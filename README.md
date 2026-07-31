# Banking Transaction SQL Analysis

## Project Overview

This project is a practical SQL analysis of a banking dataset containing customer, branch, transaction, account, and investment information.

The goal was to use a realistic relational dataset to demonstrate practical SQL skills rather than creating a small artificial dataset specifically for a portfolio. The analysis focuses on data validation, data cleaning, exploratory analysis, transaction patterns, customer behavior, regional performance, branch performance, and advanced SQL techniques.

The project was developed using **MySQL and MySQL Workbench**.

---

## Dataset

The project uses three CSV files:

| Table | Records | Purpose |
|---|---:|---|
| `bank_data` | 950 | Branch and bank-level information |
| `customer_data` | 10,000 | Customer information |
| `transaction_data` | 10,000 | Transaction, account, investment, and balance information |

### Table Relationships

```text
bank_data
    │
    │ Branch_ID
    ▼
customer_data
    │
    │ Customer_ID
    ▼
transaction_data
```

- `bank_data.Branch_ID` connects branches with customers.
- `customer_data.Customer_ID` connects customers with transactions.
- These relationships were used to demonstrate two-table and three-table SQL joins.

---

## Project Structure

```text
banking-transaction-sql-analysis/
│
├── dataset/
│   ├── bank_data.csv
│   ├── customer_data.csv
│   └── transaction_data.csv
│
├── sql/
│   ├── 01_data_validation.sql
│   ├── 02_create_views.sql
│   ├── 03_exploratory_analysis.sql
│   ├── 04_transaction_analysis.sql
│   ├── 05_business_analysis.sql
│   └── 06_advanced_sql.sql
│
└── README.md
```

---

## 1. Data Validation

Before performing analysis, the dataset was checked for structural and data-quality issues.

### Checks performed

- Record counts for all three tables
- Duplicate `Branch_ID` values
- SQL `NULL` values
- Blank-string values
- Missing customer ages
- Verification of identified missing records

### Initial Record Counts

The validation process found:

- `bank_data` — **950 records**
- `customer_data` — **10,000 records**
- `transaction_data` — **10,000 records**

### Duplicate Check

A duplicate check was performed on `Branch_ID` in `bank_data`.

**Result:** No duplicate `Branch_ID` values were returned.

### NULL vs Blank Values

An important data-quality issue was identified during validation.

The initial NULL check returned **0** for the relevant columns. However, further investigation showed that some fields contained **blank strings rather than SQL NULL values**.

This distinction was important because a simple `IS NULL` check did not identify those records.

### Blank Values Identified

In `bank_data`:

| Column | Blank Records |
|---|---:|
| `Customer_Type` | 500 |
| `City` | 500 |
| `Region` | 0 |
| `Bank_Name` | 0 |

In `customer_data`:

- **500 records had blank `Age` values.**

The 500 blank-age records were subsequently verified for consistency.

This became one of the main data-cleaning considerations in the project.

---

## 2. Data Cleaning and Reusable Views

Two reusable SQL views were created to make subsequent analysis cleaner and more consistent.

### `customer_data_clean`

This view was created to handle blank customer information.

The cleaning logic:

- Converts blank `Age` values to `NULL`
- Converts blank `Customer_Type` values to `Unknown`
- Converts blank `City` values to `Unknown`
- Retains `Region`, `Bank_Name`, and `Branch_ID`

### `banking_master`

A consolidated master view was created by combining:

- `transaction_data`
- `customer_data_clean`
- `bank_data`

The view uses `LEFT JOIN` operations and provides a convenient foundation for analysis involving transaction, customer, and branch information.

---

## 3. Exploratory Data Analysis

The exploratory analysis was used to understand the overall structure and patterns in the dataset.

### Questions explored

- How many customers are there?
- What is the total transaction value?
- How are customers distributed across customer types?
- What is the average age of each customer type?
- Which regions have the highest number of customers?
- Which cities have the highest number of customers?
- How are customers distributed across banks?
- How many records contain missing customer information?

### SQL concepts used

- `COUNT()`
- `SUM()`
- `AVG()`
- `GROUP BY`
- `ORDER BY`
- `CASE`
- `ROUND()`
- Subqueries
- `NULLIF()`
- `LIMIT`

---

## 4. Transaction Analysis

Transaction analysis focused on understanding transaction activity, account types, investments, balances, and transaction sizes.

### Questions explored

- What is the total value of all transactions?
- How does transaction volume change over time?
- Which account type processes the highest transaction value?
- Which investment products attract the highest investment amount?
- Who made the largest transactions?
- How many customers have an account balance greater than the average balance?
- How are transactions distributed by size?

### Transaction-size segmentation

Transactions were grouped into:

- **Small** — below 1,000
- **Medium** — 1,000 to 5,000
- **Large** — above 5,000

---

## 5. Business Analysis

The business analysis uses relationships between customers, transactions, and branches to answer practical business questions.

### Customer Analysis

- Which customer segment contributes the highest transaction value?
- Which customer types invest the most?
- Which customers maintain the highest account balances?

### Regional Analysis

- Which region has the highest average account balance?
- Which regions generate the highest investment?
- Which regions contribute the highest transaction value?

### Branch Analysis

- Which branches have the largest customer base?
- Which branches process the highest transaction value?
- Which branches generate the highest revenue per customer?
- Which branches maintain the highest average customer balance?

The analysis uses both `INNER JOIN` and `LEFT JOIN`, including joins across all three tables.

---

## 6. Advanced SQL Analysis

Advanced SQL techniques were used for more complex analytical questions.

### Techniques demonstrated

- Common Table Expressions (CTEs)
- Window functions
- `RANK()`
- `ROW_NUMBER()`
- `DENSE_RANK()`
- `PARTITION BY`
- Running totals
- Subqueries
- Multi-table joins

### Advanced questions explored

- Rank branches based on total transaction value.
- Find the highest-balance customer in each region.
- Calculate cumulative transaction value over time.
- Rank customers by account balance.
- Find the top-performing branches in each region.
- Calculate each branch's percentage contribution to total transaction value.
- Identify customers whose balances are above their regional average.

---

## 7. SQL Optimization Challenge

One of the most useful parts of the project was encountering and investigating a real SQL performance problem.

### Problem

An initial correlated-subquery approach was used to identify customers whose balances were above their regional average.

The query resulted in:

```text
Error Code: 2013
Lost connection to MySQL server during query
```

The problem occurred while running the query in MySQL Workbench, which reached the connection timeout.

### Optimization

The approach was rewritten using a **Common Table Expression (CTE)**.

The CTE first calculated the average balance for each region. The resulting regional averages were then joined back to the customer data.

This avoided repeatedly calculating the same regional averages and provided a more efficient structure for the analysis.

### Learning

This highlighted an important practical SQL lesson:

> Writing a query that is logically correct is not enough; query structure and efficiency also matter.

The experience demonstrated:

- Debugging a real SQL execution problem
- Understanding correlated subqueries
- Using CTEs for reusable intermediate results
- Improving query structure for analytical workloads

---

## 8. Important Dataset Consideration

The dataset contains only **one bank: HDFC**.

Because there is no variation in `Bank_Name`, a comparison such as:

> "Which bank has the highest average customer balance?"

would not provide meaningful comparative insight.

Therefore, that question was excluded from the business analysis rather than forcing an irrelevant comparison.

This is an example of adapting the analysis to the actual structure of the dataset.

---

## 9. Key SQL Skills Demonstrated

### Data Quality

- Record validation
- Duplicate detection
- NULL checking
- Blank-string detection
- Missing-value investigation
- Data cleaning

### SQL Fundamentals

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `HAVING`
- Aggregate functions
- `CASE`
- Date functions
- Subqueries

### Relational SQL

- `INNER JOIN`
- `LEFT JOIN`
- Two-table joins
- Three-table joins
- Relational analysis using identifiers

### Advanced SQL

- CTEs
- Window functions
- `RANK()`
- `ROW_NUMBER()`
- `DENSE_RANK()`
- `PARTITION BY`
- Running totals
- Percentage contribution
- Query optimization

---

## 10. Project Learning Outcomes

Through this project, I gained practical experience in:

- Working with a multi-table relational dataset
- Validating data before analysis
- Identifying the difference between NULL and blank values
- Creating reusable SQL views
- Combining data from multiple tables
- Translating business questions into SQL queries
- Performing exploratory and business analysis
- Using advanced SQL window functions
- Debugging a query-performance issue
- Improving query structure using CTEs
- Documenting an end-to-end SQL analysis project

---

## Tools Used

- **MySQL**
- **MySQL Workbench**
- **SQL**
- **GitHub**

---

## Conclusion

This project demonstrates an end-to-end SQL workflow, beginning with data validation and cleaning and progressing through exploratory analysis, transaction analysis, business analysis, and advanced SQL.

Rather than focusing only on writing queries, the project also considers data quality, relational structure, business relevance, and query performance.

The project provides a practical demonstration of SQL skills using a realistic multi-table banking dataset.
