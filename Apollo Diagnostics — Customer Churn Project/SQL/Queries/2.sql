-- KPI 2: Churn Rate Month-over-Month
WITH jan_p AS (SELECT DISTINCT patient_name FROM patient_tests WHERE month_name='January'),
     feb_p AS (SELECT DISTINCT patient_name FROM patient_tests WHERE month_name='February'),
     mar_p AS (SELECT DISTINCT patient_name FROM patient_tests WHERE month_name='March')
SELECT
    'January → February'                                    AS period,
    (SELECT COUNT(*) FROM jan_p)                            AS base_patients,
    (SELECT COUNT(*) FROM jan_p WHERE patient_name NOT IN (SELECT patient_name FROM feb_p)) AS churned,
    ROUND((SELECT COUNT(*) FROM jan_p WHERE patient_name NOT IN
        (SELECT patient_name FROM feb_p))::NUMERIC /
        (SELECT COUNT(*) FROM jan_p) * 100, 1)             AS churn_rate_pct
UNION ALL
SELECT
    'February → March',
    (SELECT COUNT(*) FROM feb_p),
    (SELECT COUNT(*) FROM feb_p WHERE patient_name NOT IN (SELECT patient_name FROM mar_p)),
    ROUND((SELECT COUNT(*) FROM feb_p WHERE patient_name NOT IN
        (SELECT patient_name FROM mar_p))::NUMERIC /
        (SELECT COUNT(*) FROM feb_p) * 100, 1);

