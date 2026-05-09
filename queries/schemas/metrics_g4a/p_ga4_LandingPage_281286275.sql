CREATE TABLE `devrebel-big-query-database.dev_hotel_g4a.p_ga4_LandingPage_281286275`
(
  landingPage STRING OPTIONS(description="The page path associated with the first pageview in a session."),
  activeUsers INT64 OPTIONS(description="The number of distinct users who visited your website or application."),
  keyEvents FLOAT64 OPTIONS(description="The number of key events that occurred."),
  newUsers INT64 OPTIONS(description="The number of users who interacted with your site or launched your app for the first time (event triggered: first_open or first_visit)."),
  sessionKeyEventRate FLOAT64 OPTIONS(description="The percentage of sessions in which any key event was triggered."),
  sessions INT64 OPTIONS(description="The number of sessions that began on your site or app (event triggered: session_start)."),
  totalRevenue FLOAT64 OPTIONS(description="The sum of revenue from purchases, subscriptions, and advertising (Purchase revenue plus Subscription revenue plus Ad revenue) minus refunded transaction revenue."),
  userEngagementDurationPerSession FLOAT64 OPTIONS(description="Average engagement time per session")
)
PARTITION BY DATE(_PARTITIONTIME);