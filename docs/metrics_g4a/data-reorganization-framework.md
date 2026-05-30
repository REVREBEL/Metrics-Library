---
title: "GA4 Data Reorganization Framework"
sidebarTitle: "Data Reorganization"
description: "Architecture for organizing raw GA4 event export data and regular GA4 reporting tables into Metrics-ready models."
---

# GA4 Data Reorganization Framework

The GA4 data model should support both source types currently available in the dataset:

1. **Raw GA4 event export data**
2. **Regular GA4 reporting / processed tables**

These source families should remain separate at the source and staging layers because they serve different analytical purposes.

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

## Source Lane Responsibilities

Use **raw GA4 data** for:

```text
pathing
session stitching
attribution
placement yield
merchandise funnel velocity
dead weight analysis
```

Use **regular GA4 reporting tables** for:

```text
fast dashboard summaries
executive reporting
validation
source / medium performance
content performance
audience reporting
demographic reporting
technology reporting
```

Use **reconciliation tables** to compare both lanes and explain any variance.

## Recommended Final Structure

```text
GA4 Source
├── raw_ga4_events
├── raw_ga4_event_params
├── raw_ga4_items
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

Staging
├── stg_ga4_events_flattened
├── stg_ga4_event_params_flattened
├── stg_ga4_items_flattened
├── stg_ga4_sessions_flattened
├── stg_web_placement_interactions
├── stg_web_merchandise_interactions
├── stg_ga4_regular_events
├── stg_ga4_regular_audiences
├── stg_ga4_regular_demographic_details
├── stg_ga4_regular_ecommerce_purchases
├── stg_ga4_regular_landing_page
├── stg_ga4_regular_pages_and_screens
├── stg_ga4_regular_promotions
├── stg_ga4_regular_tech_details
├── stg_ga4_regular_traffic_acquisition
└── stg_ga4_regular_user_acquisition

Mapping
├── map_ga4_property
├── map_web_placements
├── map_web_merchandise
├── map_web_event_taxonomy
└── map_ga4_channel_grouping

Reporting
├── rpt_ga4_acquisition_daily
├── rpt_ga4_content_daily
├── rpt_ga4_commerce_daily
├── rpt_ga4_audience_daily
├── rpt_ga4_demographic_daily
└── rpt_ga4_technology_daily

Quality Assurance
└── qa_ga4_raw_vs_regular_daily

Intermediate
├── int_web_placement_merchandise_attribution
└── int_web_merchandise_funnel_sessions

Facts
├── fct_web_placement_yield_daily
├── fct_web_merchandise_velocity_daily
├── fct_ga4_acquisition_daily
├── fct_ga4_content_daily
├── fct_ga4_commerce_daily
├── fct_ga4_audience_daily
├── fct_ga4_demographic_daily
└── fct_ga4_technology_daily
```

## Core Business Question

This structure turns GA4 from a reporting feed into a commercial intelligence model that can identify which website placements are creating value, which are wasting attention, and where merchandising opportunities are being lost or gained.
