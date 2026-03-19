-- Compare two time periods (edit dates as needed)
WITH params AS (
  SELECT
    DATE('2025-11-03') AS period1_start,
    DATE('2025-12-02') AS period1_end,
    DATE('2025-12-03') AS period2_start,
    DATE('2026-01-01') AS period2_end
),
periods AS (
  SELECT 'Period 1' AS period_label, period1_start AS start_date, period1_end AS end_date FROM params
  UNION ALL
  SELECT 'Period 2', period2_start, period2_end FROM params
)
SELECT
  p.period_label,
  COUNT(*) AS orders,
  SUM(o.revenue) AS revenue,
  ROUND(AVG(o.revenue), 2) AS aov
FROM periods p
JOIN orders o
  ON o.order_date BETWEEN p.start_date AND p.end_date
GROUP BY p.period_label;


