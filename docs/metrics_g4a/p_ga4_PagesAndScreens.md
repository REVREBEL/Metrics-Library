---
title: "p_ga4_PagesAndScreens"
sidebarTitle: "Pages and Screens"
description: "Detailed engagement and view volumes across web and app structures."
---

# File 7: Pages and Screens Table

**File Path:** `/docs/metrics_g4a/p_ga4_PagesAndScreens_281286275.md`

## Schema Purpose

The `p_ga4_PagesAndScreens_281286275` table provides a combined view of engagement across web pages and mobile screens. It acts as the core mapping sheet for content performance, detailing total views, physical time spent, and interactions occurring on individual URLs or native application screen views.

## Table Schema

| Column Name              | Data Type | Column Definition & Calculated Metric Representation |
| ------------------------ | --------- | ---------------------------------------------------- |
| `contentGroup`           | STRING    | A custom-defined structural category applied to items of published content, populated via the `content_group` event parameter. |
| `unifiedPagePathScreen`  | STRING    | The page path, for web, or screen class, for app, on which the event was logged. |
| `unifiedScreenClass`     | STRING    | The page title, for web, or screen class, for app, on which the event was logged. |
| `unifiedScreenName`      | STRING    | The page title, for web, or screen name, for app, on which the event was logged. |
| `activeUsers`            | INTEGER   | The number of distinct users who viewed and interacted with the designated page or screen asset. |
| `eventCount`             | INTEGER   | The sum of all tracking events triggered on the specific page or screen. |
| `keyEvents`              | INTEGER   | The count of key events, or conversions, triggered on the specified page or screen. |
| `screenPageViews`        | INTEGER   | The total volume of page views, for web, or screen views, for app, recorded, counting repeated views of a single page or screen. |
| `screenPageViewsPerUser` | FLOAT     | The average volume of page views or screen views completed per active user. |
| `totalRevenue`           | FLOAT     | The total purchase, subscription, and ad revenue attributed directly to interactions occurring on the specific page or screen. |
| `userEngagementDuration` | INTEGER   | The cumulative time, measured in seconds, that the specified page or screen was in the active foreground of users' devices. |

## Analytical Considerations

The `userEngagementDuration` metric tracks actual foreground visibility, providing a more accurate measure of content consumption than standard pageview counts.

Dividing `userEngagementDuration` by `activeUsers` calculates the average active time spent on a page, helping content teams identify which pages are most engaging:

$$\text{Average Engagement Time} = \frac{\text{userEngagementDuration}}{\text{activeUsers}}$$
