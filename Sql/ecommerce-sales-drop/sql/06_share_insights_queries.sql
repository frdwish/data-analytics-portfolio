-- Top negative revenue changes by region between two periods
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
    region,
    SUM(revenue) AS revenue
  FROM orders, params
  WHERE order_date BETWEEN period1_start AND period1_end
  GROUP BY region
  UNION ALL
  SELECT
    'Period 2',
    region,
    SUM(revenue)
  FROM orders, params
  WHERE order_date BETWEEN period2_start AND period2_end
  GROUP BY region
),
joined AS (
  SELECT
    p1.region,
    p1.revenue AS period1_revenue,
    p2.revenue AS period2_revenue
  FROM period_agg p1
  JOIN period_agg p2
    ON p1.region = p2.region
   AND p1.period_label = 'Period 1'
   AND p2.period_label = 'Period 2'
)
SELECT
  region,
  period1_revenue,
  period2_revenue,
  ROUND(period2_revenue - period1_revenue, 2) AS revenue_change
FROM joined
ORDER BY revenue_change ASC
LIMIT 5;
