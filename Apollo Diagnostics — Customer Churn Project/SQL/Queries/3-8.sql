

-- KPI 3: New vs Returning Patients
WITH first_visits AS (
    SELECT patient_name, MIN(bill_date) AS first_date FROM patient_tests GROUP BY patient_name
)
SELECT
    t.month_name,
    COUNT(DISTINCT t.patient_name)                      AS total_patients,
    COUNT(DISTINCT CASE
        WHEN TO_CHAR(f.first_date,'YYYY-MM') = TO_CHAR(t.bill_date,'YYYY-MM')
        THEN t.patient_name END)                        AS new_patients,
    COUNT(DISTINCT CASE
        WHEN TO_CHAR(f.first_date,'YYYY-MM') != TO_CHAR(t.bill_date,'YYYY-MM')
        THEN t.patient_name END)                        AS returning_patients
FROM patient_tests t
JOIN first_visits f ON t.patient_name = f.patient_name
GROUP BY t.month_name
ORDER BY CASE t.month_name
    WHEN 'January' THEN 1 WHEN 'February' THEN 2 WHEN 'March' THEN 3 END;


-- KPI 4: Revenue at Risk from Churned Patients
SELECT
    churn_risk,
    COUNT(*)                    AS patient_count,
    SUM(total_net)              AS revenue_at_risk,
    ROUND(AVG(total_net), 2)    AS avg_revenue_per_patient
FROM vw_churn_labels
WHERE churn_label = 'Churned'
GROUP BY churn_risk
ORDER BY revenue_at_risk DESC;


-- KPI 5: Top 10 Tests by Net Revenue
SELECT
    test_name,
    COUNT(*)                        AS times_ordered,
    SUM(net)                        AS total_net_revenue,
    ROUND(AVG(net), 2)              AS avg_price,
    COUNT(DISTINCT patient_name)    AS unique_patients
FROM patient_tests
WHERE net > 0
GROUP BY test_name
ORDER BY total_net_revenue DESC
LIMIT 10;


-- KPI 6: Gender Revenue Split
SELECT
    gender,
    COUNT(DISTINCT patient_name)    AS unique_patients,
    SUM(net)                        AS total_net,
    ROUND(AVG(net), 2)              AS avg_per_test,
    ROUND(SUM(net)::NUMERIC / (SELECT SUM(net) FROM patient_tests) * 100, 1) AS revenue_pct
FROM patient_tests
GROUP BY gender ORDER BY total_net DESC;


-- KPI 7: Visit Frequency Distribution
SELECT
    total_visits,
    COUNT(*)                AS patient_count,
    ROUND(COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM vw_patient_summary) * 100, 1) AS pct,
    SUM(total_net)          AS total_revenue
FROM vw_patient_summary
GROUP BY total_visits ORDER BY total_visits;


-- KPI 8: MoM Revenue Growth (uses LAG window function)
SELECT
    month_name,
    SUM(net) AS net_revenue,
    LAG(SUM(net)) OVER (ORDER BY CASE month_name
        WHEN 'January' THEN 1 WHEN 'February' THEN 2 WHEN 'March' THEN 3 END) AS prev_revenue,
    ROUND((SUM(net) - LAG(SUM(net)) OVER (ORDER BY CASE month_name
        WHEN 'January' THEN 1 WHEN 'February' THEN 2 WHEN 'March' THEN 3 END))
        / NULLIF(LAG(SUM(net)) OVER (ORDER BY CASE month_name
        WHEN 'January' THEN 1 WHEN 'February' THEN 2 WHEN 'March' THEN 3 END), 0) * 100, 1)
        AS mom_growth_pct
FROM patient_tests
GROUP BY month_name
ORDER BY CASE month_name WHEN 'January' THEN 1 WHEN 'February' THEN 2 WHEN 'March' THEN 3 END;

