WITH registration_cohort AS (
SELECT
user_pseudo_id AS user_pseudo_id,
MIN(DATE_TRUNC(DATE(TIMESTAMP_MICROS(event_timestamp)), WEEK)) AS first_visit_week
FROM
`raw_events` AS events
GROUP BY 1
),
revenue_by_customer AS (
SELECT
user_pseudo_id AS user_pseudo_id,
DATE_TRUNC(DATE(TIMESTAMP_MICROS(event_timestamp)), WEEK) AS purchase_week,
purchase_revenue_in_usd AS revenue
FROM
`raw_events` AS events
WHERE
event_name = 'purchase'
)
,cohort_sizes AS (
SELECT
first_visit_week,
COUNT(DISTINCT user_pseudo_id) AS cohort_size
FROM
registration_cohort
GROUP BY
first_visit_week
)
SELECT
rc.first_visit_week,
SUM(CASE WHEN DATE_DIFF(purchase_week, rc.first_visit_week, WEEK) = 0 THEN revenue ELSE 0 END) / cs.cohort_size AS week0,
SUM(CASE WHEN DATE_DIFF(purchase_week, rc.first_visit_week, WEEK) = 1 THEN revenue ELSE 0 END) / cs.cohort_size AS week1,
SUM(CASE WHEN DATE_DIFF(purchase_week, rc.first_visit_week, WEEK) = 2 THEN revenue ELSE 0 END) / cs.cohort_size AS week2,
SUM(CASE WHEN DATE_DIFF(purchase_week, rc.first_visit_week, WEEK) = 3 THEN revenue ELSE 0 END) / cs.cohort_size AS week3,
SUM(CASE WHEN DATE_DIFF(purchase_week, rc.first_visit_week, WEEK) = 4 THEN revenue ELSE 0 END) / cs.cohort_size AS week4,
SUM(CASE WHEN DATE_DIFF(purchase_week, rc.first_visit_week, WEEK) = 5 THEN revenue ELSE 0 END) / cs.cohort_size AS week5,
SUM(CASE WHEN DATE_DIFF(purchase_week, rc.first_visit_week, WEEK) = 6 THEN revenue ELSE 0 END) / cs.cohort_size AS week6,
SUM(CASE WHEN DATE_DIFF(purchase_week, rc.first_visit_week, WEEK) = 7 THEN revenue ELSE 0 END) / cs.cohort_size AS week7,
SUM(CASE WHEN DATE_DIFF(purchase_week, rc.first_visit_week, WEEK) = 8 THEN revenue ELSE 0 END) / cs.cohort_size AS week8,
SUM(CASE WHEN DATE_DIFF(purchase_week, rc.first_visit_week, WEEK) = 9 THEN revenue ELSE 0 END) / cs.cohort_size AS week9,
SUM(CASE WHEN DATE_DIFF(purchase_week, rc.first_visit_week, WEEK) = 10 THEN revenue ELSE 0 END) / cs.cohort_size AS week10,
SUM(CASE WHEN DATE_DIFF(purchase_week, rc.first_visit_week, WEEK) = 11 THEN revenue ELSE 0 END) / cs.cohort_size AS week11,
SUM(CASE WHEN DATE_DIFF(purchase_week, rc.first_visit_week, WEEK) = 12 THEN revenue ELSE 0 END) / cs.cohort_size AS week12
FROM revenue_by_customer AS rbc
JOIN registration_cohort AS rc
ON rbc.user_pseudo_id = rc.user_pseudo_id
JOIN cohort_sizes cs
ON cs.first_visit_week = rc.first_visit_week
GROUP BY
rc.first_visit_week, cs.cohort_size
ORDER BY
rc.first_visit_week
