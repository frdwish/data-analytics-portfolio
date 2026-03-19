#  Data Bank Growth & Customer Behavior Analysis

---

## Business Context

With increasing uncertainty across multiple industries, financial stability has become more important than ever.  

In this case study, I analyzed a neo-digital banking model called **Data Bank**, where customer deposits directly impact their allocated cloud data storage.

###  Objectives

- Understand how customer behavior impacts financial growth  
- Analyze how frequently customers shift across regions and nodes  
- Measure how balances grow or decline over time  
- Estimate future data allocation requirements  

---

##  Tools & Concepts Used

- PostgreSQL  
- Joins  
- Common Table Expressions (CTEs)  
- Window Functions  
- Aggregations  
- Percentile Calculations  
- Running Balance Modeling  
- Monthly Closing Balance Analysis  

---

##  Dataset Overview

The analysis is based on three core tables:

### 1 `regions`
Global operational regions.

### 2 `customer_nodes`
Tracks customer allocation across secure banking nodes.

### 3 `customer_transactions`
Records deposits, withdrawals, and purchases.

The dataset simulates real-world banking behavior with dynamic node reallocation and transactional movement.

---

##  Key Analysis Performed

### A. Customer Nodes Exploration

1. Total number of unique nodes in the system  
2. Node distribution per region  
3. Number of customers allocated to each region  
4. Average number of days before customers are reallocated  
5. Median, 80th percentile, and 95th percentile reallocation duration per region  

---

### B. Customer Transaction Analysis

1. Unique transaction count and total amount by transaction type  
2. Average historical deposit count and amount per customer  
3. Monthly customers with multiple deposits and at least one purchase or withdrawal  
4. End-of-month closing balance for each customer  
5. Percentage of customers increasing their balance by more than 5%  

---

### C. Additional Business Queries

1. Unique customers with at least one transaction per region  
2. Top 5 customers by total deposit amount  
3. Monthly:
   - Total deposits  
   - Total withdrawals  
   - Net balance change  
4. Customers who deposited every month in 2020  
5. Month of highest deposit for each customer  
6. Customers who never made a withdrawal  
7. Second highest deposit amount in 2020  

---

##  Business Takeaways

###  Customer & Region Insights
- Customers are distributed across multiple regions and nodes, enhancing system security.  
- Certain regions show higher customer concentration, indicating
