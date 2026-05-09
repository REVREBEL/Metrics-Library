CREATE TABLE `devrebel-big-query-database.dev_hotel_g4a.p_ga4_DemographicDetails_281286275`
(
  brandingInterest STRING OPTIONS(description="Interests demonstrated by users who are higher in the shopping funnel. Users can be counted in multiple interest categories. For example, Shoppers, Lifestyles & Hobbies/Pet Lovers, or Travel/Travel Buffs/Beachbound Travelers."),
  city STRING OPTIONS(description="The city from which the user activity originated."),
  country STRING OPTIONS(description="The country from which the user activity originated."),
  language STRING OPTIONS(description="The language setting of the user's browser or device. For example, English."),
  region STRING OPTIONS(description="The geographic region from which the user activity originated, derived from their IP address."),
  userAgeBracket STRING OPTIONS(description="User age brackets."),
  userGender STRING OPTIONS(description="User gender."),
  activeUsers INT64 OPTIONS(description="The number of distinct users who visited your website or application."),
  engagedSessions INT64 OPTIONS(description="The number of sessions that had an engaged event."),
  engagementRate FLOAT64 OPTIONS(description="The percentage of sessions that had an engaged event."),
  eventCount INT64 OPTIONS(description="The count of events."),
  keyEvents FLOAT64 OPTIONS(description="The number of key events that occurred."),
  newUsers INT64 OPTIONS(description="The number of users who interacted with your site or launched your app for the first time (event triggered: first_open or first_visit)."),
  totalRevenue FLOAT64 OPTIONS(description="The sum of revenue from purchases, subscriptions, and advertising (Purchase revenue plus Subscription revenue plus Ad revenue) minus refunded transaction revenue."),
  userEngagementDuration FLOAT64 OPTIONS(description="The total amount of time (in seconds) your website or app was in the foreground of users` devices."),
  userKeyEventRate FLOAT64 OPTIONS(description="The percentage of users who triggered any key event.")
)
PARTITION BY DATE(_PARTITIONTIME);