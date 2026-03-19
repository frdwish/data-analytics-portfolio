-- Segment by category (edit dates as needed)
SELECT
  category,
  COUNT(*) AS orders,
  SUM(revenue) AS revenue,
  ROUND(AVG(revenue), 2) AS aov
FROM orders
WHERE order_date BETWEEN DATE('2025-12-03') AND DATE('2026-01-01')
GROUP BY category
ORDER BY revenue DESC;

-- Segment by region (edit dates as needed)
SELECT
  region,
  COUNT(*) AS orders,
  SUM(revenue) AS revenue,
  ROUND(AVG(revenue), 2) AS aov
FROM orders
WHERE order_date BETWEEN DATE('2025-12-03') AND DATE('2026-01-01')
GROUP BY region
ORDER BY revenue DESC;
