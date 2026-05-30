---
title: "GA4 Source and Staging Layers"
sidebarTitle: "Source + Staging"
description: "Defines how raw GA4 event exports and regular GA4 reporting tables should be staged for Metrics."
---

# GA4 Source and Staging Layers

## Source Layer

The GA4 data model should support both source types currently available in the dataset:

1. **Raw GA4 event export data**
2. **Regular GA4 reporting / processed tables**

These should remain separate at the source layer because they serve different analytical purposes.

```text
GA4 Source
├── Raw GA4 Event Export
│   ├── raw_ga4_events
│   ├── raw_ga4_event_params
│   └── raw_ga4_items
│
└── Regular GA4 Reporting Tables
    ├── p_ga4_Events
    ├── p_ga4_Audiences
    ├── p_ga4_DemographicDetails
    ├── p_ga4_EcommercePurchases
    ├── p_ga4_LandingPage
    ├── p_ga4_PagesAndScreens
    ├── p_ga4_Promotions
    ├── p_ga4_TechDetails
    ├── p_ga4_TrafficAcquisition
    └── p_ga4_UserAcquisition
```

## Source Layer Purpose

The **raw GA4 event export** should be used for behavioral modeling, session stitching, attribution, pathing, placement yield, and merchandise funnel analysis.

The **regular GA4 reporting tables** should be used for fast dashboard summaries, executive reporting, validation, source/medium performance, content performance, audience analysis, demographic analysis, and technology reporting.

## Staging Layer

The staging layer normalizes both raw and regular GA4 sources into cleaner, typed, and analysis-ready tables.

## Raw GA4 Staging

Raw GA4 staging tables flatten the nested event export structure.

```text
stg_ga4_events_flattened
stg_ga4_event_params_flattened
stg_ga4_items_flattened
stg_ga4_sessions_flattened
```

These tables should preserve event-level detail, including:

```text
property_code
event_date
event_timestamp
event_name
user_pseudo_id
ga_session_id
transaction_id
page_location
page_referrer
source
medium
campaign
item_id
item_name
item_category
item_variant
promotion_id
promotion_name
creative_name
revenue_usd
insert_date
```

## Regular GA4 Staging

Regular GA4 staging tables clean and normalize the existing processed GA4 report tables.

```text
stg_ga4_regular_events
stg_ga4_regular_audiences
stg_ga4_regular_demographic_details
stg_ga4_regular_ecommerce_purchases
stg_ga4_regular_landing_page
stg_ga4_regular_pages_and_screens
stg_ga4_regular_promotions
stg_ga4_regular_tech_details
stg_ga4_regular_traffic_acquisition
stg_ga4_regular_user_acquisition
```

These tables are not intended for user/session path modeling. They are best used for aggregate reporting, validation, and dashboard summaries.
