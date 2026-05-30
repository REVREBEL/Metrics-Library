---
title: "p_ga4_LandingPage"
sidebarTitle: "Landing Page"
description: "Initial user entry paths and post-arrival conversion performance."
---

# File 6: Landing Page Table

**File Path:** `/docs/metrics_g4a/p_ga4_LandingPage_281286275.md`

## Schema Purpose

The `p_ga4_LandingPage_281286275` table isolates the initial web page paths or application screens that served as the entry point for user sessions. This table is critical for assessing marketing landing page performance, tracking user acquisition efficiency, and evaluating down-funnel key events originating from the first touch of a session.

## Table Schema

| Column Name           | Data Type | Column Definition & Calculated Metric Representation                                                                                                                 |
| --------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `landingPage`         | STRING    | The explicit page path associated with the first pageview in a session.                                                                                              |
| `activeUsers`         | INTEGER   | The number of distinct users who visited your website or application starting on the specified landing page.                                                         |
| `keyEvents`           | INTEGER   | The number of key conversion events completed by users whose sessions began on the specified landing page.                                                           |
| `newUsers`            | INTEGER   | The count of brand-new users whose initial interaction with the brand started on the specified landing page.                                                         |
| `sessionKeyEventRate` | FLOAT     | The percentage of sessions in which any key event was triggered. Formulated as:<br><br>$$\text{Session Key Event Rate} = \frac{\text{Key Events}}{\text{Sessions}}$$ |
| `sessions`            | INTEGER   | The total number of sessions that initiated directly on the specified landing page.                                                                                  |
| `totalRevenue`        | FLOAT     | The sum of purchase, subscription, and advertising revenue generated during sessions that initiated on the specified landing page.                                   |

## Analytical Considerations

Analyzing landing page data is key to evaluating top-of-funnel conversion rates. If a landing page drives a high volume of `sessions` but has a low `sessionKeyEventRate`, it may indicate a mismatch between the ad creative and the on-page content, or technical performance issues on that page.

In line with Google's schema updates, the historical conversions column has been renamed to `keyEvents` in this table.
