
/*SECTION 5 — CHURN QUERIES
   ============================================================ */

-- CHURN 1: Full patient churn status table
SELECT
    patient_name, gender, total_visits, total_net,
    avg_net_per_visit, visited_jan, visited_feb, visited_mar,
    churn_label, churn_risk,
    CASE
        WHEN churn_risk = 'High Risk (High Value)' THEN 'PRIORITY — Personal call + 15% offer'
        WHEN churn_label = 'Churned'               THEN 'SMS recall + 10% loyalty discount'
        WHEN churn_label = 'Active'                THEN 'Maintain — offer annual package'
        ELSE 'Verify'
    END AS recommended_action
FROM vw_churn_labels
ORDER BY CASE churn_label WHEN 'Churned' THEN 1 WHEN 'Active' THEN 2 ELSE 3 END,
         total_net DESC;


-- CHURN 2: Patients who visited for chronic condition tests — recall list
SELECT DISTINCT
    pt.patient_name, pt.gender, pt.test_name,
    MAX(pt.bill_date)                           AS last_test_date,
    (CURRENT_DATE - MAX(pt.bill_date)::DATE)    AS days_since_test,
    cl.churn_label,
    CASE
        WHEN pt.test_name ILIKE '%HbA1c%'       THEN 'Diabetic — recall in 90 days'
        WHEN pt.test_name ILIKE '%Thyroid%'
          OR pt.test_name ILIKE '%TSH%'         THEN 'Thyroid — recall in 90 days'
        WHEN pt.test_name ILIKE '%Kidney%'
          OR pt.test_name ILIKE '%Creatinine%'  THEN 'Kidney — recall in 60 days'
        WHEN pt.test_name ILIKE '%Lipid%'
          OR pt.test_name ILIKE '%Cholesterol%' THEN 'Cardiac — recall in 180 days'
        ELSE 'General — recall in 90 days'
    END AS recall_reason
FROM patient_tests pt
JOIN vw_churn_labels cl ON pt.patient_name = cl.patient_name
WHERE pt.test_name IN (
    'HbA1c (Glycated Haemoglobin)',
    'Thyroid Profile Total',
    'Thyroid Stimulating Hormone (TSH), Ultrasensitive',
    'Kidney/Renal Function Tests Gold (KFT Gold /RFT Gold)',
    'Creatinine, Serum','LIPID PROFILE','LDL Cholesterol, Direct',
    'Blood Glucose Fasting (FBS)','Blood Glucose Post prandial (PPBS)'
)
GROUP BY pt.patient_name, pt.gender, pt.test_name, cl.churn_label
ORDER BY days_since_test DESC;


-- CHURN 3: Retention cohort analysis
SELECT
    'January Cohort' AS cohort,
    COUNT(DISTINCT CASE WHEN visited_jan=1 THEN patient_name END) AS started,
    COUNT(DISTINCT CASE WHEN visited_jan=1 AND visited_feb=1 THEN patient_name END) AS kept_feb,
    COUNT(DISTINCT CASE WHEN visited_jan=1 AND visited_mar=1 THEN patient_name END) AS kept_mar,
    ROUND(COUNT(DISTINCT CASE WHEN visited_jan=1 AND visited_feb=1 THEN patient_name END)
        ::NUMERIC / NULLIF(COUNT(DISTINCT CASE WHEN visited_jan=1 THEN patient_name END),0)*100,1) AS feb_ret_pct,
    ROUND(COUNT(DISTINCT CASE WHEN visited_jan=1 AND visited_mar=1 THEN patient_name END)
        ::NUMERIC / NULLIF(COUNT(DISTINCT CASE WHEN visited_jan=1 THEN patient_name END),0)*100,1) AS mar_ret_pct
FROM vw_churn_labels
UNION ALL
SELECT
    'February Cohort',
    COUNT(DISTINCT CASE WHEN visited_feb=1 THEN patient_name END), NULL,
    COUNT(DISTINCT CASE WHEN visited_feb=1 AND visited_mar=1 THEN patient_name END),
    NULL,
    ROUND(COUNT(DISTINCT CASE WHEN visited_feb=1 AND visited_mar=1 THEN patient_name END)
        ::NUMERIC / NULLIF(COUNT(DISTINCT CASE WHEN visited_feb=1 THEN patient_name END),0)*100,1)
FROM vw_churn_labels;


-- CHURN 4: Priority recall list ranked by revenue
SELECT
    ROW_NUMBER() OVER (ORDER BY total_net DESC)  AS priority_rank,
    patient_name, gender, churn_risk,
    total_visits, total_net                      AS lifetime_revenue,
    last_visit_date,
    (CURRENT_DATE - last_visit_date::DATE)       AS days_since_last_visit
FROM vw_churn_labels
WHERE churn_label = 'Churned'
ORDER BY total_net DESC;
