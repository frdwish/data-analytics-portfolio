-- KPI 1 : Monthly Revenue Summary
-- ─────────────────────────────────────────────────────────────
SELECT
    month_name,
    COUNT(DISTINCT visit_id)                            AS total_visits,
    COUNT(DISTINCT patient_name)                        AS unique_patients,
    COUNT(*)                                            AS total_tests,
    SUM(gross)                                          AS gross_revenue,
    SUM(discount)                                       AS total_discount,
    SUM(net)                                            AS net_revenue,
    ROUND(SUM(net) / COUNT(DISTINCT visit_id), 2)      AS avg_net_per_visit,
    ROUND(SUM(discount) / NULLIF(SUM(gross),0) * 100, 1) AS discount_rate_pct
FROM patient_tests
GROUP BY month_name
ORDER BY CASE month_name
    WHEN 'January' THEN 1 WHEN 'February' THEN 2 WHEN 'March' THEN 3 END;


 