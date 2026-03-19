-- Daily trend for dashboard
SELECT
  order_date,
  COUNT(*) AS orders,
  SUM(revenue) AS revenue,
  ROUND(AVG(revenue), 2) AS aov
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- Category trend for dashboard
SELECT
  category,
  COUNT(*) AS orders,
  SUM(revenue) AS revenue,
  ROUND(AVG(revenue), 2) AS aov
FROM orders
GROUP BY category
ORDER BY revenue DESC;

-- Region trend for dashboard
SELECT
  region,
  COUNT(*) AS orders,
  SUM(revenue) AS revenue,
  ROUND(AVG(revenue), 2) AS aov
FROM orders
GROUP BY region
ORDER BY revenue DESC;
