# Swiggy Food Delivery — SQL Business Intelligence

**Tools:** PostgreSQL 18 · pgAdmin · Tableau Public  
**Domain:** Food Tech · Business Analytics  
**Dataset:** Synthetic dataset modeled on Swiggy's real operational structure

---

## Problem Statement

Swiggy operates across 500+ cities in India with 1.5 lakh+ restaurant partners. The business needs to understand which cities and cuisines are driving the most revenue, where delivery operations are underperforming, which customers are high-value and at risk of churning, and whether premium pricing actually delivers better quality.

This project answers these questions using structured SQL analysis across a 4-table relational database.

---

## Database Schema

| Table | Rows | Description |
|---|---|---|
| `restaurants` | 5,000 | Restaurant details, cuisine, rating, cost |
| `customers` | 2,000 | Customer profiles, city, premium status |
| `orders` | 15,000 | Order transactions, payment, status |
| `deliveries` | 8,980 | Delivery time, distance, rider rating |

```
restaurants (5,000 rows)
├── restaurant_id  PK
├── name, city, area, cuisine
├── rating, rating_count
├── avg_cost_for_two
└── address

customers (2,000 rows)
├── customer_id  PK
├── name, email, city, age
├── signup_date
└── is_premium

orders (15,000 rows)
├── order_id  PK
├── customer_id  FK → customers
├── restaurant_id  FK → restaurants
├── order_date, order_time
├── quantity, order_amount
├── discount, final_amount
├── status, payment_method

deliveries (8,980 rows)
├── delivery_id  PK
├── order_id  FK → orders
├── rider_id
├── delivery_time_min
├── distance_km
├── delivery_rating
└── on_time
```

---

## Business Questions Solved

| # | Business Question | SQL Concepts Used |
|---|---|---|
| 1 | What is the overall scale of Swiggy's operations? | Subqueries |
| 2 | Which cities generate the most revenue? | JOIN, GROUP BY |
| 3 | Which restaurant partners drive the most business? | JOIN, GROUP BY |
| 4 | Who are Swiggy's most valuable customers? | JOIN, CASE, GROUP BY |
| 5 | How has revenue grown month over month? | TO_CHAR, GROUP BY |
| 6 | Who are the top 3 restaurants in each city? | Window Function (RANK) |
| 7 | Which customers placed only 1 order and churned? | JOIN, HAVING |
| 8 | Which cities have the worst delivery performance? | 3-Table JOIN, CASE |
| 9 | Are high-value customers being served by poor restaurants? | CTE, Multi-table JOIN |
| 10 | What is the cumulative revenue growth 2023-2024? | CTE, LAG, SUM OVER |
| 11 | Which payment methods drive highest order values? | GROUP BY, AVG |
| 12 | Which cuisines generate the most revenue and best delivery? | 3-Table JOIN |
| 13 | Do premium customers actually spend more? | JOIN, GROUP BY |
| 14 | Which restaurants have the highest cancellation rates? | JOIN, CASE, HAVING |
| 15 | Full city-level business health scorecard | 4-Table JOIN |

---

## Key Findings

### Revenue
- Total platform revenue: **₹77.7 lakh** across 15,000 orders
- Average order value: **₹865.78**
- Kolkata leads city revenue at **₹13.9 lakh**; Chennai lowest at **₹11.8 lakh**
- Ahmedabad leads order volume but has the worst delivery performance

### Customer Insights
- Premium vs non-premium revenue per customer is nearly identical (₹3,973 vs ₹3,887) — premium membership shows weak ROI
- Top customer spent **₹15,760** — 18x the average customer
- Multiple high-value customers are repeatedly ordering from restaurants rated below 3.0 — retention risk

### Delivery Performance
- Ahmedabad has the worst late delivery rate at **51.5%** — critical operational issue
- Jaipur performs best at **46.4%** late rate
- Average delivery time is ~45 mins consistently across all cities

### Cuisine Performance
- Burgers generate the highest revenue (**₹5.85 lakh**) despite not having the most restaurants
- South Indian has the best delivery rating (**4.31**) among all cuisines
- High-volume cuisines don't always mean high quality — weighted rating analysis reveals the gap

### Risk Areas
- Restaurants with 66.7% cancellation rate identified — immediate partnership review needed
- Premium membership pricing not justified by current behavioral data

---

## SQL Highlights

### Window Function — Rank Restaurants Within Each City

```sql
SELECT * FROM (
    SELECT
        r.name,
        r.city,
        r.cuisine,
        COUNT(o.order_id) AS total_orders,
        SUM(o.final_amount) AS total_revenue,
        RANK() OVER (PARTITION BY r.city ORDER BY COUNT(o.order_id) DESC) AS city_rank
    FROM orders o
    JOIN restaurants r ON o.restaurant_id = r.restaurant_id
    WHERE o.status = 'Delivered'
    GROUP BY r.restaurant_id, r.name, r.city, r.cuisine
) ranked
WHERE city_rank <= 3
ORDER BY city, city_rank;
```

### CTE — High Value Customers Ordering From Low Rated Restaurants

```sql
WITH high_value_customers AS (
    SELECT customer_id,
           SUM(final_amount) AS total_spent
    FROM orders
    WHERE status = 'Delivered'
    GROUP BY customer_id
    HAVING SUM(final_amount) > 3000
),
low_rated_restaurants AS (
    SELECT restaurant_id, name, rating
    FROM restaurants
    WHERE rating < 3.0 AND rating IS NOT NULL
)
SELECT
    c.name AS customer_name,
    c.city,
    hvc.total_spent,
    r.name AS restaurant_name,
    r.rating,
    COUNT(o.order_id) AS orders_from_low_rated
FROM high_value_customers hvc
JOIN customers c ON hvc.customer_id = c.customer_id
JOIN orders o ON c.customer_id = o.customer_id
JOIN low_rated_restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY c.name, c.city, hvc.total_spent, r.name, r.rating
ORDER BY hvc.total_spent DESC;
```

### Running Revenue With Month-over-Month Growth (LAG Window Function)

```sql
WITH monthly AS (
    SELECT
        TO_CHAR(order_date, 'YYYY-MM') AS month,
        SUM(final_amount) AS monthly_revenue
    FROM orders
    WHERE status = 'Delivered'
    GROUP BY TO_CHAR(order_date, 'YYYY-MM')
)
SELECT
    month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY month) AS cumulative_revenue,
    ROUND(100.0 * (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month))
          / LAG(monthly_revenue) OVER (ORDER BY month), 2) AS mom_growth_pct
FROM monthly
ORDER BY month;
```

### 4-Table JOIN — City-Level Business Health Scorecard

```sql
SELECT
    r.city,
    COUNT(DISTINCT r.restaurant_id) AS total_restaurants,
    COUNT(DISTINCT c.customer_id) AS active_customers,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.final_amount), 2) AS total_revenue,
    ROUND(AVG(d.delivery_time_min), 1) AS avg_delivery_time,
    ROUND(AVG(d.delivery_rating), 2) AS avg_delivery_rating,
    ROUND(100.0 * SUM(CASE WHEN o.status = 'Cancelled' THEN 1 ELSE 0 END)
          / COUNT(o.order_id), 1) AS cancellation_rate
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN deliveries d ON o.order_id = d.order_id
GROUP BY r.city
ORDER BY total_revenue DESC;
```

---

## Tableau Dashboard

Interactive dashboard built on Tableau Public with cross-filters across all charts.

Visuals included:
- Revenue by City (bar chart)
- Monthly Revenue Trend 2023-2024 (line chart)
- Top 10 Cuisines by Orders (horizontal bar chart)
- Order Status Distribution (pie chart)

[View Live Dashboard](#) ← replace with your Tableau Public link

---

## Project Structure

```
Swiggy Food Delivery — SQL Business Intelligence/
├── data/
│   ├── restaurants.csv
│   ├── customers.csv
│   ├── orders.csv
│   └── deliveries.csv
├── queries/
│   └── swiggy_analysis.sql
├── Sql Queries and Results/
│   ├── 1.png   Query 1  — Platform Overview
│   ├── 2.png   Query 2  — City Revenue
│   ├── 3.png   Query 3  — Top Restaurants
│   ├── 4.png   Query 4  — Customer Segmentation
│   ├── 5.png   Query 5  — Monthly Trend
│   ├── 6.png   Query 6  — City Rankings
│   ├── 7.png   Query 7  — Churned Customers
│   ├── 8.png   Query 8  — Delivery Performance
│   ├── 9.png   Query 9  — High Value + Low Rated
│   ├── 10.png  Query 10 — Cumulative Revenue
│   ├── 11.png  Query 11 — Payment Methods
│   ├── 12.png  Query 12 — Cuisine Performance
│   ├── 13.png  Query 13 — Premium vs Non-Premium
│   ├── 14.png  Query 14 — Cancellation Rates
│   └── 15.png  Query 15 — Business Health Scorecard
├── Swiggy Dashboards/
│   ├── 1.png
│   ├── 2.png
│   └── 3.png
└── README.md

---

## Tools Used

- PostgreSQL 18 via pgAdmin — database design and querying
- Tableau Public — interactive dashboard
- Python — synthetic dataset generation
