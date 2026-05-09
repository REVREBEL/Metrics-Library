CREATE TABLE `devrebel-big-query-database.dev_hotel_g4a.p_ga4_Audiences_281286275`
(
  audienceName STRING OPTIONS(description="The given name of an Audience. Users are reported in the audiences to which they belonged during the report's date range. Current user behavior does not affect historical audience membership in reports."),
  averageSessionDuration FLOAT64 OPTIONS(description="The average duration (in seconds) of users` sessions."),
  newUsers INT64 OPTIONS(description="The number of users who interacted with your site or launched your app for the first time (event triggered: first_open or first_visit)."),
  screenPageViewsPerSession FLOAT64 OPTIONS(description="The number of app screens or web pages your users viewed per session. Repeated views of a single page or screen are counted. (screen_view + page_view events) / sessions."),
  sessions INT64 OPTIONS(description="The number of sessions that began on your site or app (event triggered: session_start)."),
  totalRevenue FLOAT64 OPTIONS(description="The sum of revenue from purchases, subscriptions, and advertising (Purchase revenue plus Subscription revenue plus Ad revenue) minus refunded transaction revenue."),
  totalUsers INT64 OPTIONS(description="The number of distinct users who have logged at least one event, regardless of whether the site or app was in use when that event was logged.")
)
PARTITION BY DATE(_PARTITIONTIME);