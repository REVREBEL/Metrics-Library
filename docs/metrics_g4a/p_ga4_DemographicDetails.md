---
title: "p_ga4_DemographicDetails"
sidebarTitle: "Demographic Details"
description: "Geographic, linguistic, and demographic attributes of user activity."
---

## Schema Purpose
The `p_ga4_DemographicDetails_281286275` table segmentizes user engagement, acquisition, and transaction metrics across geographic territories, language settings, ages, genders, and consumer interest patterns.[1] This schema isolates user locations and browser characteristics, allowing teams to determine which demographical segments generate the highest direct value and user engagement.[1]

## Table Schema

| Column Name | Data Type | Column Definition & Calculated Metric Representation |
| :--- | :--- | :--- |
| brandingInterest | STRING | Interests demonstrated by users who are higher in the shopping funnel.[1] Users can be counted in multiple interest categories.[1] |
| city | STRING | The specific city from which the user activity originated, resolved from client IP lookup.[1] |
| country | STRING | The country from which the user activity originated, resolved from client IP lookup.[1] |
| language | STRING | The default language code setting of the user's browser or device operating system.[1] |
| region | STRING | The geographic administrative region or state from which the user activity originated, derived from their IP address.[1] |
| userAgeBracket | STRING | The designated age group bracket of the active user cohort.[1] |
| userGender | STRING | The declared or inferred gender category of the user cohort.[1] |
| activeUsers | INTEGER | The number of distinct users who visited your website or application.[1] |
| newUsers | INTEGER | The count of first-time visitors who interacted with your site or launched your app for the first time.[1] |
| keyEvents | INTEGER | The total count of key events (high-value conversion actions) completed by users belonging to the demographic cohort.[1] |
| totalRevenue | FLOAT | The total sum of purchase, subscription, and advertising revenue generated, net of refunds.[1] |

## Analytical Considerations
Geographic data is resolved using client IP lookups during data collection. Privacy protections and IP masking can sometimes result in missing or categorized 'unknown' values for specific cities and regions.[1] 

Interest and age brackets rely on third-party tracking signals. As privacy regulations limit identifier tracking, the percentage of unclassified demographic traffic may fluctuate depending on the region.