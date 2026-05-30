---
title: "p_ga4_Audiences"
sidebarTitle: "Audiences"
description: "Dimensions and metrics for user audience cohorts processed via GA4 transformations."
---

## Schema Purpose
The `p_ga4_Audiences_281286275` table processes performance metrics broken down by designated user audience cohorts.[1] It identifies how specific user segments behave over time, tracking session volumes, engagement, and direct revenue generation.[1] Users are reported in the audiences to which they belonged during the report's date range, meaning current user behavior does not retroactively alter historical audience membership.[1]

## Table Schema

| Column Name | Data Type | Column Definition & Calculated Metric Representation |
| :--- | :--- | :--- |
| audienceName | STRING | The given name of an Audience. Users are reported in the audiences to which they belonged during the report's date range.[1] |
| averageSessionDuration | FLOAT | The average duration, measured in seconds, of users' sessions.[1] Formulated as: $$\text{Average Session Duration} = \frac{\text{Total Session Duration}}{\text{Sessions}}$$ |
| newUsers | INTEGER | The number of users who interacted with your site or launched your app for the first time, triggered by a `first_open` or `first_visit` event.[1] |
| screenPageViewsPerSession | FLOAT | The average number of app screens or web pages viewed per session, counting repeated views.[1] Formulated as: $$\text{Screen Page Views Per Session} = \frac{\text{screen\_view Events} + \text{page\_view Events}}{\text{sessions}}$$ |
| sessions | INTEGER | The total number of sessions that began on your site or app, triggered by the `session_start` event.[1] |
| totalRevenue | FLOAT | The sum of revenue generated from purchases, subscriptions, and advertising minus refunded transaction revenue.[1] Formulated as: $$\text{Total Revenue} = \text{Purchase Revenue} + \text{Subscription Revenue} + \text{Ad Revenue} - \text{Refunded Revenue}$$ |
| totalUsers | INTEGER | The total count of distinct users who have logged at least one event, regardless of active foreground engagement status.[1] |

## Analytical Considerations
When analyzing audience cohorts, data teams should note that a single user can belong to multiple audience segments simultaneously.[1] This multi-membership can lead to duplicate counts when aggregating metrics across audiences. 

The `averageSessionDuration` and `screenPageViewsPerSession` metrics are valuable for comparing engagement quality across different user cohorts, such as comparing newly acquired users to high-value, repeat shoppers.[1]