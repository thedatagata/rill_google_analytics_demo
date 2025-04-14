SELECT
    e.user_id
  , COUNT(distinct e.session_id) AS total_sessions
  , MIN(e.session_start_time) AS first_session
  , MAX(e.session_start_time) AS last_session
  , DATEDIFF('day', MIN(e.session_start_time), CAST('2025-03-31' AS DATE)) AS customer_age
  , DATEDIFF('day', MAX(e.session_start_time), CAST('2025-03-31' AS DATE)) AS days_since_last_session
  , DATEDIFF('day', MIN(e.session_start_time), MAX(e.session_start_time)) AS recency
  , AVG(COALESCE(e.session_totals__transaction_revenue, 0) / 1000000.0) AS monetary_value
  , SUM(COALESCE(e.session_totals__transaction_revenue, 0) / 1000000.0) AS total_revenue

FROM md_source_session_facts e 
GROUP BY 1