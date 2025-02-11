# SQL Case Study: Advanced SQL Techniques for Customer Data Analysis

## Overview

This SQL case study explores **advanced SQL techniques** applied to customer data analysis. The goal of the project is to demonstrate proficiency in SQL concepts such as:

- **Common Table Expressions (CTEs)**
- **User-Defined Functions (UDFs)**
- **Table-Valued Functions (TVFs)**
- **Stored Procedures**
- **Triggers** (DML and DDL)
- **Pivot and Unpivot**
- **Conditional Statements**
- **Loops and Cursors**

The **customers table** was used for analyzing and generating actionable insights based on customer data.

## 📚 Techniques Used

### 1. **Common Table Expressions (CTEs)**
   - CTEs were used for simplifying complex queries, especially recursive queries and repeated subqueries.

   Example:
   ```sql
   Use CTE to display list of managers from EMP table who has atleast one person reporting to them

with mgr_with_reporting as
(select mgr, count(empno) as ct from emp group by mgr)
select * from  emp a
inner join mgr_with_reporting m on a.empno = m.mgr;
```
### 2. User-Defined Functions (UDFs)

- UDFs were created to calculate custom metrics, such as Customer Lifetime Value (CLV), and to return specific values based on input parameters.
  Example:
   ```sql
   create function emp_exp(@hiredate date)
    Returns int
    as
    	Begin
    		Declare @Exp int;
    		Set @Exp = year(getdate()) - year(@hiredate)
    		Return @Exp
    	End;
      ```
### 📝 Project Results & Insights

- Performance Optimization: The use of CTEs and TVFs helped optimize queries and reduced the overall execution time.
- Data Integrity: Triggers ensured that the data remained consistent, especially for customer information.
- Advanced Reporting: Pivot/Unpivot helped in creating flexible and dynamic reports for customer behavior.
- Automation: Stored Procedures allowed automation of repetitive tasks, improving efficiency.

### 📚 Learning Outcomes

- Understanding the power of Common Table Expressions (CTEs) in recursive queries.
- Practical experience with User-Defined Functions (UDFs) to encapsulate business logic.
- Handling large datasets efficiently using Table-Valued Functions (TVFs).
- Automating tasks using Stored Procedures and ensuring data integrity using Triggers.
- Mastering Pivoting and Unpivoting for advanced reporting techniques.
- Exploring loops and cursors for row-by-row processing of data.
