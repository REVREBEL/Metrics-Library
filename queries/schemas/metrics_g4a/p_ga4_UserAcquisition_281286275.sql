CREATE TABLE `devrebel-big-query-database.dev_hotel_g4a.p_ga4_UserAcquisition_281286275`
(
  firstUserCampaignName STRING OPTIONS(description="Name of the marketing campaign that first acquired the user. Includes Google Ads Campaigns, Manual Campaigns, & other Campaigns."),
  firstUserDefaultChannelGroup STRING OPTIONS(description="The default channel group that first acquired the user. Default channel group is based primarily on source and medium. An enumeration which includes Direct, Organic Search, Paid Social, Organic Social, Email, Affiliates, Referral, Paid Search, Video, and Display."),
  firstUserMedium STRING OPTIONS(description="The medium that first acquired the user to your website or app."),
  firstUserPrimaryChannelGroup STRING OPTIONS(description="The primary channel group that originally acquired a user. Primary channel groups are the channel groups used in standard reports in Google Analytics and serve as an active record of your property's data in alignment with channel grouping over time."),
  firstUserSource STRING OPTIONS(description="The source that first acquired the user to your website or app."),
  firstUserSourceMedium STRING OPTIONS(description="The combined values of the dimensions firstUserSource and firstUserMedium."),
  firstUserSourcePlatform STRING OPTIONS(description="The source platform that first acquired the user. Don't depend on this field returning Manual for traffic that uses UTMs; this field will update from returning Manual to returning (not set) for an upcoming feature launch."),
  activeUsers INT64 OPTIONS(description="The number of distinct users who visited your website or application."),
  engagedSessions INT64 OPTIONS(description="The number of sessions that lasted longer than 10 seconds, or had a key event, or had 2 or more screen views."),
  eventCount INT64 OPTIONS(description="The count of events."),
  keyEvents FLOAT64 OPTIONS(description="The number of key events that occurred."),
  newUsers INT64 OPTIONS(description="The number of users who interacted with your site or launched your app for the first time (event triggered: first_open or first_visit)."),
  totalRevenue FLOAT64 OPTIONS(description="The sum of revenue from purchases, subscriptions, and advertising (Purchase revenue plus Subscription revenue plus Ad revenue) minus refunded transaction revenue."),
  totalUsers INT64 OPTIONS(description="The number of distinct users who have logged at least one event, regardless of whether the site or app was in use when that event was logged."),
  userEngagementDuration FLOAT64 OPTIONS(description="The total amount of time (in seconds) your website or app was in the foreground of users` devices."),
  userKeyEventRate FLOAT64 OPTIONS(description="The percentage of users who triggered any key event.")
)
PARTITION BY DATE(_PARTITIONTIME);