Swiggy Food Delivery — SQL Business Intelligence

Tools: PostgreSQL · pgAdmin · Tableau Public

Domain: Food Tech · Business Analytics

Dataset: Synthetic dataset modeled on Swiggy's real operational structure


Problem Statement

Swiggy operates across 500+ cities in India with 1.5 lakh+ restaurant partners. The business needs to understand:


Which cities and cuisines are driving the most revenue?
Where are delivery operations underperforming?
Which customers are high-value and at risk of churning?
Does premium pricing actually deliver better quality?


This project answers these questions using a structured SQL analysis across a 4-table relational database.


Database Schema

restaurants (5,000 rows)
├── restaurant_id (PK)
├── name, city, area, cuisine
├── rating, rating_count
├── avg_cost_for_two
└── address

customers (2,000 rows)
├── customer_id (PK)
├── name, email, city, age
├── signup_date
└── is_premium

orders (15,000 rows)
├── order_id (PK)
├── customer_id (FK → customers)
├── restaurant_id (FK → restaurants)
├── order_date, order_time
├── quantity, order_amount
├── discount, final_amount
├── status, payment_method

deliveries (8,980 rows)
├── delivery_id (PK)
├── order_id (FK → orders)
├── rider_id
├── delivery_time_min
├── distance_km
├── delivery_rating
└── on_time


Business Questions Solved

#Business QuestionSQL Concepts Used1What is the overall scale of Swiggy's operations?Subqueries2Which cities generate the most revenue?JOIN, GROUP BY3Which restaurant partners drive the most business?JOIN, GROUP BY4Who are Swiggy's most valuable customers?JOIN, CASE, GROUP BY5How has revenue grown month over month?TO_CHAR, GROUP BY6Who are the top 3 restaurants in each city?Window Function (RANK)7Which customers placed only 1 order and churned?JOIN, HAVING8Which cities have the worst delivery performance?3-Table JOIN, CASE9Are high-value customers being served by poor restaurants?CTE, Multi-table JOIN10What is the cumulative revenue growth 2023-2024?CTE, LAG, SUM OVER11Which payment methods drive highest order values?GROUP BY, AVG12Which cuisines generate the most revenue and best delivery?3-Table JOIN13Do premium customers actually spend more?JOIN, GROUP BY14Which restaurants have the highest cancellation rates?JOIN, CASE, HAVING15Full city-level business health scorecard4-Table JOIN


Key Findings

Revenue


Total platform revenue: ₹77.7 lakh across 15,000 orders
Average order value: ₹865.78
Kolkata leads city revenue at ₹13.9 lakh; Chennai lowest at ₹11.8 lakh
Ahmedabad leads order volume but has the worst delivery performance


Customer Insights


Premium vs non-premium revenue per customer is nearly identical (₹3,973 vs ₹3,887) — premium membership shows weak ROI
Top customer spent ₹15,760 — 18x the average customer
Multiple high-value customers are repeatedly ordering from restaurants rated below 3.0 — retention risk


Delivery Performance


Ahmedabad has the worst late delivery rate at 51.5% — critical operational issue
Jaipur performs best at 46.4% late rate
Average delivery time is ~45 mins consistently across all cities


Cuisine Performance


Burgers generate the highest revenue (₹5.85 lakh) despite not having the most restaurants
South Indian has the best delivery rating (4.31) among all cuisines
High-volume cuisines don't always mean high quality — weighted rating analysis reveals the gap


Risk Areas


Restaurants with 66.7% cancellation rate identified — immediate partnership review needed
Premium membership pricing not justified by current behavioral data



SQL Highlights

Window Function — Rank Restaurants Within Each City

sqlSELECT * FROM (
    SELECT
        r.name, r.city, r.cuisine,
        COUNT(o.order_id) AS total_orders,
        RANK() OVER (PARTITION BY r.city ORDER BY COUNT(o.order_id) DESC) AS city_rank
    FROM orders o
    JOIN restaurants r ON o.restaurant_id = r.restaurant_id
    WHERE o.status = 'Delivered'
    GROUP BY r.restaurant_id, r.name, r.city, r.cuisine
) ranked
WHERE city_rank <= 3
ORDER BY city, city_rank;

CTE — High Value Customers Ordering From Low Rated Restaurants

sqlWITH high_value_customers AS (
    SELECT customer_id, SUM(final_amount) AS total_spent
    FROM orders WHERE status = 'Delivered'
    GROUP BY customer_id
    HAVING SUM(final_amount) > 3000
),
low_rated_restaurants AS (
    SELECT restaurant_id, name, rating
    FROM restaurants
    WHERE rating < 3.0 AND rating IS NOT NULL
)
SELECT c.name, c.city, hvc.total_spent,
       r.name AS restaurant_name, r.rating,
       COUNT(o.order_id) AS orders_from_low_rated
FROM high_value_customers hvc
JOIN customers c ON hvc.customer_id = c.customer_id
JOIN orders o ON c.customer_id = o.customer_id
JOIN low_rated_restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY c.name, c.city, hvc.total_spent, r.name, r.rating
ORDER BY hvc.total_spent DESC;

Running Revenue With MoM Growth (LAG Window Function)

sqlWITH monthly AS (
    SELECT TO_CHAR(order_date, 'YYYY-MM') AS month,
           SUM(final_amount) AS monthly_revenue
    FROM orders WHERE status = 'Delivered'
    GROUP BY TO_CHAR(order_date, 'YYYY-MM')
)
SELECT month, monthly_revenue,
       SUM(monthly_revenue) OVER (ORDER BY month) AS cumulative_revenue,
       ROUND(100.0 * (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month))
             / LAG(monthly_revenue) OVER (ORDER BY month), 2) AS mom_growth_pct
FROM monthly ORDER BY month;


Tableau Dashboard

Interactive dashboard with cross-filters built on Tableau Public.

Visuals included:


Revenue by City (bar chart)
Monthly Revenue Trend 2023-2024 (line chart)
Top 10 Cuisines by Orders (horizontal bar)
Order Status Distribution (pie chart)


🔗 View Live Dashboard ← paste your Tableau Public link here


Project Structure

Swiggy Food Delivery — SQL Business Intelligence/
├── data/
│   ├── restaurants.csv
│   ├── customers.csv
│   ├── orders.csv
│   └── deliveries.csv
├── queries/
│   └── swiggy_analysis.sql
├── Sql Queries and Results/
│   ├── 1.png  (Platform Overview)
│   ├── 2.png  (City Revenue)
│   └── ... (all 15 query screenshots)
├── Swiggy Dashboards/
│   └── dashboard.png
└── README.md


Tools Used


PostgreSQL 18 via pgAdmin — database design, querying
Tableau Public — interactive dashboard
Python — dataset generation