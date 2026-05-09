CREATE TABLE `devrebel-big-query-database.dev_hotel_g4a.p_ga4_TrafficAcquisition_281286275`
(
  sessionCampaignName STRING OPTIONS(description="The marketing campaign name for a session. Includes Google Ads Campaigns, Manual Campaigns, & other Campaigns."),
  sessionDefaultChannelGroup STRING OPTIONS(description="The session's default channel group is based primarily on source and medium. An enumeration which includes Direct, Organic Search, Paid Social, Organic Social, Email, Affiliates, Referral, Paid Search, Video, and Display."),
  sessionMedium STRING OPTIONS(description="The medium that initiated a session on your website or app."),
  sessionPrimaryChannelGroup STRING OPTIONS(description="The primary channel group that led to the session. Primary channel groups are the channel groups used in standard reports in Google Analytics and serve as an active record of your property's data in alignment with channel grouping over time."),
  sessionSource STRING OPTIONS(description="The source that initiated a session on your website or app."),
  sessionSourceMedium STRING OPTIONS(description="The combined values of the dimensions sessionSource and sessionMedium."),
  sessionSourcePlatform STRING OPTIONS(description="The source platform of the session's campaign. Don't depend on this field returning Manual for traffic that uses UTMs; this field will update from returning Manual to returning (not set) for an upcoming feature launch."),
  engagedSessions INT64 OPTIONS(description="The number of sessions that lasted longer than 10 seconds, or had a key event, or had 2 or more screen views."),
  engagementRate FLOAT64 OPTIONS(description="The percentage of engaged sessions (Engaged sessions divided by Sessions). This metric is returned as a fraction; for example, 0.7239 means 72.39% of sessions were engaged sessions."),
  eventCount INT64 OPTIONS(description="The count of events."),
  eventsPerSession FLOAT64 OPTIONS(description="The average number of events per session (Event count divided by Sessions)."),
  keyEvents FLOAT64 OPTIONS(description="The number of key events that occurred."),
  sessionKeyEventRate FLOAT64 OPTIONS(description="The percentage of sessions in which any key event was triggered."),
  sessions INT64 OPTIONS(description="The number of sessions that began on your site or app (event triggered: session_start)."),
  totalRevenue FLOAT64 OPTIONS(description="The sum of revenue from purchases, subscriptions, and advertising (Purchase revenue plus Subscription revenue plus Ad revenue) minus refunded transaction revenue."),
  userEngagementDurationPerSession FLOAT64 OPTIONS(description="Average engagement time per session")
)
PARTITION BY DATE(_PARTITIONTIME);