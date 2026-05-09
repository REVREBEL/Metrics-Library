CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_CalendarV`
AS
WITH RECURSIVE date_range AS (
  SELECT 
    MIN(stay_date) AS start_date,
    MAX(stay_date) AS end_date
  FROM `devrebel-big-query-database.Pace.Pace_Property`
),
recursive_calendar AS (
  SELECT start_date AS calendar_date
  FROM date_range
  UNION ALL
  SELECT DATE_ADD(recursive_calendar.calendar_date, INTERVAL 1 DAY)
  FROM recursive_calendar
  JOIN date_range ON TRUE
  WHERE recursive_calendar.calendar_date < date_range.end_date
)
SELECT
  calendar_date AS `Date`,
  FORMAT_DATE('%Y-%m-%d', calendar_date) AS `Date ISO`,
  EXTRACT(YEAR FROM calendar_date) AS `Year`,
  EXTRACT(MONTH FROM calendar_date) AS `Month of Year`,
  FORMAT_DATE('%B', calendar_date) AS `Month`,
  EXTRACT(DAY FROM calendar_date) AS `Day of Month`,
  EXTRACT(DAYOFYEAR FROM calendar_date) AS `Day of Year`,
  EXTRACT(WEEK FROM calendar_date) AS `Week`,
  EXTRACT(DAYOFWEEK FROM calendar_date) AS `Day of Week`,
  FORMAT_DATE('%A', calendar_date) AS `Day Name`
FROM recursive_calendar
