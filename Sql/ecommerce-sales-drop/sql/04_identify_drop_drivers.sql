-- Identify drop drivers by category between two periods
WITH params AS (
  SELECT
    DATE('2025-11-03') AS period1_start,
    DATE('2025-12-02') AS period1_end,
    DATE('2025-12-03') AS period2_start,
    DATE('2026-01-01') AS period2_end
),
period_agg AS (
  SELECT
    'Period 1' AS period_label,
    category,
    SUM(revenue) AS revenue,
    COUNT(*) AS orders,
    AVG(revenue) AS aov
  FROM orders, params
  WHERE order_date BETWEEN period1_start AND period1_end
  GROUP BY category
  UNION ALL
  SELECT
    'Period 2',
    category,
    SUM(revenue),
    COUNT(*),
    AVG(revenue)
  FROM orders, params
  WHERE order_date BETWEEN period2_start AND period2_end
  GROUP BY category
),
joined AS (
  SELECT
    p1.category,
    p1.revenue AS period1_revenue,
    p2.revenue AS period2_revenue,
    p1.orders AS period1_orders,
    p2.orders AS period2_orders,
    p1.aov AS period1_aov,
    p2.aov AS period2_aov
  FROM period_agg p1
  JOIN period_agg p2
    ON p1.category = p2.category
   AND p1.period_label = 'Period 1'
   AND p2.period_label = 'Period 2'
)
SELECT
  category,
  period1_revenue,
  period2_revenue,
  ROUND(period2_revenue - period1_revenue, 2) AS revenue_change,
  period1_orders,
  period2_orders,
  (period2_orders - period1_orders) AS orders_change,
  ROUND(period1_aov, 2) AS period1_aov,
  ROUND(period2_aov, 2) AS period2_aov,
  ROUND(period2_aov - period1_aov, 2) AS aov_change
FROM joined
ORDER BY revenue_change ASC;
