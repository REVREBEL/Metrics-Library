CREATE TABLE `devrebel-big-query-database.dev_hotel_g4a.p_ga4_Events_281286275`
(
  eventName STRING OPTIONS(description="The name of the event."),
  eventCount INT64 OPTIONS(description="The count of events."),
  eventCountPerUser FLOAT64 OPTIONS(description="The average number of events per user (Event count divided by Active users)."),
  totalRevenue FLOAT64 OPTIONS(description="The sum of revenue from purchases, subscriptions, and advertising (Purchase revenue plus Subscription revenue plus Ad revenue) minus refunded transaction revenue."),
  totalUsers INT64 OPTIONS(description="The number of distinct users who have logged at least one event, regardless of whether the site or app was in use when that event was logged.")
)
PARTITION BY DATE(_PARTITIONTIME);