CREATE TABLE `devrebel-big-query-database.dev_hotel_g4a.p_ga4_PagesAndScreens_281286275`
(
  contentGroup STRING OPTIONS(description="A category that applies to items of published content. Populated by the event parameter content_group."),
  unifiedPagePathScreen STRING OPTIONS(description="The page path (web) or screen class (app) on which the event was logged."),
  unifiedScreenClass STRING OPTIONS(description="The page title (web) or screen class (app) on which the event was logged."),
  unifiedScreenName STRING OPTIONS(description="The page title (web) or screen name (app) on which the event was logged."),
  activeUsers INT64 OPTIONS(description="The number of distinct users who visited your website or application."),
  eventCount INT64 OPTIONS(description="The count of events."),
  keyEvents FLOAT64 OPTIONS(description="The number of key events that occurred."),
  screenPageViews INT64 OPTIONS(description="The number of app screens or web pages your users viewed. Repeated views of a single page or screen are counted. (screen_view + page_view events)."),
  screenPageViewsPerUser FLOAT64 OPTIONS(description="The number of app screens or web pages your users viewed per active user. Repeated views of a single page or screen are counted. (screen_view + page_view events) / active users."),
  totalRevenue FLOAT64 OPTIONS(description="The sum of revenue from purchases, subscriptions, and advertising (Purchase revenue plus Subscription revenue plus Ad revenue) minus refunded transaction revenue."),
  userEngagementDuration FLOAT64 OPTIONS(description="The total amount of time (in seconds) your website or app was in the foreground of users` devices.")
)
PARTITION BY DATE(_PARTITIONTIME);