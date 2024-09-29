/* CLV, retention analysis, Google Merch shop data  */

WITH
-- first time visit of unique user id
  subscription_start AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(DATE(TIMESTAMP_MICROS(MIN(event_timestamp))), WEEK) AS cohort_week
  FROM
    `raw_events`
-- WHERE campaign = "(organic)"  /* Change to get retention data based on campaign */
  GROUP BY
    user_pseudo_id ),
-- Last event date of a customer
  subscription_end AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(DATE(TIMESTAMP_MICROS(MAX(event_timestamp))), WEEK) AS cohort_week
  FROM
    `raw_events`
  GROUP BY
    user_pseudo_id),
  subscription_info AS (
  SELECT
    t1.user_pseudo_id,
    t1.cohort_week AS subscription_start,
    t2.cohort_week AS subscription_end
  FROM
    subscription_start AS t1
  JOIN
    subscription_end t2
  ON
    t1.user_pseudo_id = t2.user_pseudo_id )
SELECT
  DATE_TRUNC(subscription_start, WEEK) AS subscription_start,
  COUNT(*) AS week_0,
  SUM(CASE
      WHEN subscription_end IS NULL OR subscription_end > DATE_TRUNC(subscription_start, WEEK) + INTERVAL 1 WEEK THEN 1
      ELSE 0
  END
    ) AS week_1,
  SUM(CASE
      WHEN subscription_end IS NULL OR subscription_end > DATE_TRUNC(subscription_start, WEEK) + INTERVAL 2 WEEK THEN 1
      ELSE 0
  END
    ) AS week_2,
  SUM(CASE
      WHEN subscription_end IS NULL OR subscription_end > DATE_TRUNC(subscription_start, WEEK) + INTERVAL 3 WEEK THEN 1
      ELSE 0
  END
    ) AS week_3,
  SUM(CASE
      WHEN subscription_end IS NULL OR subscription_end > DATE_TRUNC(subscription_start, WEEK) + INTERVAL 4 WEEK THEN 1
      ELSE 0
  END
    ) AS week_4,
  SUM(CASE
      WHEN subscription_end IS NULL OR subscription_end > DATE_TRUNC(subscription_start, WEEK) + INTERVAL 5 WEEK THEN 1
      ELSE 0
  END
    ) AS week_5,
  SUM(CASE
      WHEN subscription_end IS NULL OR subscription_end > DATE_TRUNC(subscription_start, WEEK) + INTERVAL 6 WEEK THEN 1
      ELSE 0
  END
    ) AS week_6
FROM
  subscription_info
GROUP BY
  ALL