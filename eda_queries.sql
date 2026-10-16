
USE fraud_db;


-- 1. VIEW SAMPLE DATA
SELECT *
FROM credit_card_fraud
LIMIT 10;


-- 2. TOTAL CUSTOMERS
SELECT COUNT(*) AS total_records
FROM credit_card_fraud;


-- 3. DISTINCT CUSTOMERS
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM credit_card_fraud;


-- 4. CHECK DUPLICATE CUSTOMER IDS
SELECT
    customer_id,
    COUNT(*) AS occurrences
FROM credit_card_fraud
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;


-- 5. CHECK DUPLICATE CHURN IDS
SELECT
    churn_id,
    COUNT(*) AS occurrences
FROM credit_card_fraud
GROUP BY churn_id
HAVING COUNT(*) > 1;


-- 6. CHECK MISSING VALUES IN KEY COLUMNS
SELECT
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(customer_segment IS NULL) AS missing_segment,
    SUM(customer_country IS NULL) AS missing_country,
    SUM(is_churned IS NULL) AS missing_churn_status,
    SUM(churn_flag IS NULL) AS missing_churn_flag,
    SUM(total_spend_usd IS NULL) AS missing_total_spend,
    SUM(satisfaction_score IS NULL) AS missing_satisfaction,
    SUM(churn_date IS NULL) AS missing_churn_date
FROM credit_card_fraud;


-- 7. CHURNED VS ACTIVE CUSTOMERS
SELECT
    is_churned,
    COUNT(*) AS customer_count
FROM credit_card_fraud
GROUP BY is_churned
ORDER BY customer_count DESC;


-- 8. OVERALL CHURN RATE
SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
    SUM(CASE WHEN churn_flag = 0 THEN 1 ELSE 0 END)
        AS active_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage
FROM credit_card_fraud;


-- 9. CHURN RATE BY CUSTOMER SEGMENT
SELECT
    customer_segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage
FROM credit_card_fraud
GROUP BY customer_segment
ORDER BY churn_rate_percentage DESC;

-- question for dashboard 8,7,23,9,10,11,15,16,17,19,20,22


-- 10. CHURN RATE BY COUNTRY
SELECT
    customer_country,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage
FROM credit_card_fraud
GROUP BY customer_country
ORDER BY churn_rate_percentage DESC;


-- 11. CHURN REASONS
SELECT
    churn_reason,
    COUNT(*) AS churn_count
FROM credit_card_fraud
WHERE churn_flag = 1
GROUP BY churn_reason
ORDER BY churn_count DESC;


-- 12. CHURN CATEGORY ANALYSIS
SELECT
    churn_category,
    COUNT(*) AS churn_count
FROM credit_card_fraud
WHERE churn_flag = 1
GROUP BY churn_category
ORDER BY churn_count DESC;


-- 13. CHURN RATE BY SUBSCRIPTION TYPE
SELECT
    subscription_type,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage
FROM credit_card_fraud
GROUP BY subscription_type
ORDER BY churn_rate_percentage DESC;


-- 14. CUSTOMER SPENDING ANALYSIS BY CHURN STATUS
SELECT
    is_churned,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spend_usd), 2) AS avg_total_spend,
    ROUND(AVG(avg_order_value_usd), 2) AS avg_order_value,
    ROUND(AVG(num_purchases), 2) AS avg_purchases,
    ROUND(AVG(customer_lifetime_value_usd), 2)
        AS avg_lifetime_value
FROM credit_card_fraud
GROUP BY is_churned;


-- 15. SATISFACTION ANALYSIS BY CHURN STATUS
SELECT
    is_churned,
    COUNT(*) AS customer_count,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction,
    ROUND(AVG(feedback_score), 2) AS avg_feedback,
    ROUND(AVG(loyalty_score), 2) AS avg_loyalty
FROM credit_card_fraud
GROUP BY is_churned;


-- 16. SUPPORT TICKETS AND RETURNS BY CHURN STATUS
SELECT
    is_churned,
    ROUND(AVG(support_tickets), 2) AS avg_support_tickets,
    ROUND(AVG(support_interactions), 2) AS avg_support_interactions,
    ROUND(AVG(returns_count), 2) AS avg_returns,
    ROUND(AVG(days_since_last_purchase), 2)
        AS avg_days_since_purchase
FROM credit_card_fraud
GROUP BY is_churned;


-- 17. MARKETING ENGAGEMENT ANALYSIS
SELECT
    is_churned,
    SUM(marketing_emails_sent) AS emails_sent,
    SUM(marketing_emails_opened) AS emails_opened,
    SUM(marketing_emails_clicked) AS emails_clicked,
    SUM(marketing_conversions) AS conversions,
    ROUND(
        100.0 * SUM(marketing_emails_opened)
        / NULLIF(SUM(marketing_emails_sent), 0),
        2
    ) AS email_open_rate_pct,
    ROUND(
        100.0 * SUM(marketing_emails_clicked)
        / NULLIF(SUM(marketing_emails_sent), 0),
        2
    ) AS email_click_rate_pct
FROM credit_card_fraud
GROUP BY is_churned;


-- 18. CHURN RISK CATEGORY DISTRIBUTION
SELECT
    churn_risk_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(churn_risk_score), 2) AS avg_risk_score,
    ROUND(AVG(churn_probability), 4) AS avg_churn_probability
FROM credit_card_fraud
GROUP BY churn_risk_category
ORDER BY customer_count DESC;


-- 19. HIGH-RISK CUSTOMERS
SELECT
    customer_id,
    customer_segment,
    customer_country,
    churn_risk_score,
    churn_probability,
    satisfaction_score,
    days_since_last_purchase,
    total_spend_usd
FROM credit_card_fraud
WHERE is_high_risk_customer = 'Yes'
ORDER BY churn_risk_score DESC
LIMIT 20;


-- 20. CHURN BY CUSTOMER HEALTH CATEGORY
SELECT
    customer_health_category,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage
FROM credit_card_fraud
GROUP BY customer_health_category
ORDER BY churn_rate_percentage DESC;


-- 21. CHURN BY ENGAGEMENT LEVEL
SELECT
    engagement_level,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage
FROM credit_card_fraud
GROUP BY engagement_level
ORDER BY churn_rate_percentage DESC;


-- 22. MONTHLY CHURN TREND
SELECT
    churn_month,
    COUNT(*) AS churned_customers,
    ROUND(SUM(churn_revenue_impact_usd), 2)
        AS revenue_impact_usd
FROM credit_card_fraud
WHERE churn_flag = 1
GROUP BY churn_month
ORDER BY churn_month;


-- 23. FINANCIAL IMPACT OF CHURN
SELECT
    COUNT(*) AS total_churned_customers,
    ROUND(SUM(churn_revenue_impact_usd), 2)
        AS total_revenue_impact_usd,
    ROUND(AVG(churn_revenue_impact_usd), 2)
        AS avg_impact_per_churned_customer,
    ROUND(SUM(customer_retention_cost_usd), 2)
        AS total_retention_cost_usd,
    ROUND(SUM(recovery_revenue_usd), 2)
        AS total_recovery_revenue_usd,
    ROUND(SUM(net_churn_loss), 2)
        AS total_net_churn_loss
FROM credit_card_fraud
WHERE churn_flag = 1;


-- 24. CHURN RATE BY CUSTOMER VALUE CATEGORY
SELECT
    customer_value_category,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage,
    ROUND(AVG(customer_lifetime_value_usd), 2)
        AS avg_lifetime_value
FROM credit_card_fraud
GROUP BY customer_value_category
ORDER BY churn_rate_percentage DESC;


-- 25. CUSTOMER RETENTION PROBABILITY BY CHURN STATUS
SELECT
    is_churned,
    COUNT(*) AS customer_count,
    ROUND(AVG(retention_probability), 4)
        AS avg_retention_probability
FROM credit_card_fraud
GROUP BY is_churned;


-- 26. CUSTOMER TENURE ANALYSIS
SELECT
    CASE
        WHEN customer_age_months < 6 THEN '0-5 months'
        WHEN customer_age_months < 12 THEN '6-11 months'
        WHEN customer_age_months < 24 THEN '12-23 months'
        ELSE '24+ months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage
FROM credit_card_fraud
GROUP BY tenure_group
ORDER BY MIN(customer_age_months);


-- 27. TOP CUSTOMERS BY REVENUE IMPACT
SELECT
    customer_id,
    customer_segment,
    customer_country,
    total_spend_usd,
    customer_lifetime_value_usd,
    churn_revenue_impact_usd,
    net_churn_loss
FROM credit_card_fraud
WHERE churn_flag = 1
ORDER BY churn_revenue_impact_usd DESC
LIMIT 20;


-- 28. PREVENTION METHOD ANALYSIS
SELECT
    prevention_method,
    COUNT(*) AS customer_count,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage
FROM credit_card_fraud
GROUP BY prevention_method
ORDER BY churn_rate_percentage;


-- 29. CHURN RATE INDICATOR DISTRIBUTION
SELECT
    churn_rate_indicator,
    COUNT(*) AS customer_count
FROM credit_card_fraud
GROUP BY churn_rate_indicator
ORDER BY customer_count DESC;


-- 30. EXECUTIVE KPI SUMMARY
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
    SUM(CASE WHEN churn_flag = 0 THEN 1 ELSE 0 END)
        AS active_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage,
    ROUND(AVG(total_spend_usd), 2) AS avg_customer_spend,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction,
    ROUND(SUM(churn_revenue_impact_usd), 2)
        AS total_churn_revenue_impact_usd,
    ROUND(SUM(net_churn_loss), 2) AS total_net_churn_loss
FROM credit_card_fraud;
