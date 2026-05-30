---
title: "GA4 Regular Reporting Layer"
sidebarTitle: "Regular Reporting"
description: "Reporting models that organize processed p_ga4 tables into broader dashboard concepts."
---

# GA4 Regular Reporting Layer

The regular reporting layer organizes the processed `p_ga4_*` tables into broader reporting concepts. These tables are useful for dashboards, executive summaries, and validating raw-event-derived models.

## Recommended Reporting Tables

```text
rpt_ga4_acquisition_daily
rpt_ga4_content_daily
rpt_ga4_commerce_daily
rpt_ga4_audience_daily
rpt_ga4_demographic_daily
rpt_ga4_technology_daily
```

## `rpt_ga4_acquisition_daily`

**Sources:**

```text
p_ga4_TrafficAcquisition
p_ga4_UserAcquisition
```

**Purpose:**  
Compare session-scoped acquisition performance against first-user acquisition performance.

| Column | Type | Business Logic / Source |
| --- | --- | --- |
| `property_code` | STRING | Property identifier. |
| `event_date` | DATE | Reporting date. |
| `scope_type` | STRING | `session` or `first_user`. |
| `source` | STRING | Source value from GA4. |
| `medium` | STRING | Medium value from GA4. |
| `source_medium` | STRING | Combined source / medium value. |
| `campaign_name` | STRING | Campaign name. |
| `default_channel_group` | STRING | GA4 default channel group. |
| `sessions` | INT64 | Session count, when available. |
| `engaged_sessions` | INT64 | Engaged session count, when available. |
| `engagement_rate` | FLOAT64 | Engagement rate. |
| `active_users` | INT64 | Active user count. |
| `new_users` | INT64 | New user count. |
| `key_events` | INT64 | Key event count. |
| `total_revenue` | FLOAT64 | Total revenue. |

## `rpt_ga4_content_daily`

**Sources:**

```text
p_ga4_LandingPage
p_ga4_PagesAndScreens
```

**Purpose:**  
Understand entry-page performance and in-session content engagement.

## `rpt_ga4_commerce_daily`

**Sources:**

```text
p_ga4_EcommercePurchases
p_ga4_Promotions
```

**Purpose:**  
Summarize product, room, package, and internal promotion performance from GA4 regular exports.

## `rpt_ga4_technology_daily`

**Source:**

```text
p_ga4_TechDetails
```

**Purpose:**  
Analyze user behavior and revenue by device, browser, operating system, and platform.

## `rpt_ga4_audience_daily`

**Source:**

```text
p_ga4_Audiences
```

**Purpose:**  
Compare performance across GA4-defined user cohorts.

## `rpt_ga4_demographic_daily`

**Source:**

```text
p_ga4_DemographicDetails
```

**Purpose:**  
Analyze performance by geography, language, gender, age bracket, and interest category.
