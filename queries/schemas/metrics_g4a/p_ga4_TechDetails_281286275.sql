CREATE TABLE `devrebel-big-query-database.dev_hotel_g4a.p_ga4_TechDetails_281286275`
(
  appVersion STRING OPTIONS(description="The app's versionName (Android) or short bundle version (iOS)."),
  browser STRING OPTIONS(description="The browsers used to view your website."),
  deviceCategory STRING OPTIONS(description="The type of device: Desktop, Tablet, or Mobile."),
  operatingSystem STRING OPTIONS(description="The operating systems used by visitors to your app or website. Includes desktop and mobile operating systems such as Windows and Android."),
  operatingSystemVersion STRING OPTIONS(description="The operating system versions used by visitors to your website or app. For example, Android 10's version is 10, and iOS 13.5.1's version is 13.5.1."),
  operatingSystemWithVersion STRING OPTIONS(description="The operating system and version. For example, Android 10 or Windows 7."),
  platform STRING OPTIONS(description="The platform on which your app or website ran; for example, web, iOS, or Android. To determine a stream's type in a report, use both platform and streamId."),
  platformDeviceCategory STRING OPTIONS(description="The platform and type of device on which your website or mobile app ran. (example: Android / mobile)"),
  screenResolution STRING OPTIONS(description="The screen resolution of the user's monitor. For example, 1920x1080."),
  activeUsers INT64 OPTIONS(description="The number of distinct users who visited your website or application."),
  engagedSessions INT64 OPTIONS(description="The number of sessions that lasted longer than 10 seconds, or had a key event, or had 2 or more screen views."),
  engagementRate FLOAT64 OPTIONS(description="The percentage of engaged sessions (Engaged sessions divided by Sessions). This metric is returned as a fraction; for example, 0.7239 means 72.39% of sessions were engaged sessions."),
  eventCount INT64 OPTIONS(description="The count of events."),
  keyEvents FLOAT64 OPTIONS(description="The number of key events that occurred."),
  newUsers INT64 OPTIONS(description="The number of users who interacted with your site or launched your app for the first time (event triggered: first_open or first_visit)."),
  totalRevenue FLOAT64 OPTIONS(description="The sum of revenue from purchases, subscriptions, and advertising (Purchase revenue plus Subscription revenue plus Ad revenue) minus refunded transaction revenue."),
  userEngagementDuration FLOAT64 OPTIONS(description="The total amount of time (in seconds) your website or app was in the foreground of users` devices.")
)
PARTITION BY DATE(_PARTITIONTIME);