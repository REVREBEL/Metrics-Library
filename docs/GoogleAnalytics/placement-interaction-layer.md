---
title: "GA4 Placement Interaction Layer"
sidebarTitle: "Placement Interactions"
description: "Behavioral staging model for website placement impressions and selections."
---

# GA4 Placement Interaction Layer

## `stg_web_placement_interactions`

**Purpose:**  
A unified log of every website placement interaction, including impressions and selections.

This table tracks how users interact with defined areas of the website where promotional content, offers, rooms, packages, CTAs, or booking modules appear.

**Primary Source:**  
Raw GA4 event export

**Grain:**

```text
property_code + event_date + event_timestamp + user_pseudo_id + ga_session_id + placement_id + interaction_type
```

| Column | Type | Business Logic / Source |
| --- | --- | --- |
| `property_code` | STRING | The property identifier. |
| `event_date` | DATE | Interaction date. |
| `event_timestamp` | TIMESTAMP | Event timestamp used for sequencing and attribution. |
| `user_pseudo_id` | STRING | Anonymous GA4 user/device ID. |
| `ga_session_id` | STRING | Session anchor key extracted from GA4 event parameters. |
| `placement_id` | STRING | Placement identifier, mapped from `itemPromotionId`, `promotion_id`, or equivalent tracking value. |
| `placement_name` | STRING | Placement name, mapped from `itemPromotionName`, `promotion_name`, or equivalent tracking value. |
| `placement_type` | STRING | Type of placement, such as banner, promo card, CTA, room module, package module, or booking widget. |
| `placement_zone` | STRING | Enriched lookup value, such as Hero, Sidebar, Offer Grid, Booking Widget, Room Detail, Package Detail, or Footer. |
| `placement_location` | STRING | Page or site area where the placement appears, such as homepage, rooms page, offers page, or booking path. |
| `placement_yield_weight` | FLOAT64 | Enriched lookup multiplier used to weight placement value. |
| `interaction_type` | STRING | Standardized interaction type: `impression` or `selection`. |
| `source_event_name` | STRING | Native GA4 event name, such as `view_promotion` or `select_promotion`. |
| `page_location` | STRING | Full page URL or path where the interaction occurred. |
| `insert_date` | DATE | Record ingestion date. |

## Notes

Use lowercase standardized values for `interaction_type`:

```text
impression
selection
```

Avoid using `rms_` prefixes for placement metrics because RMS is commonly understood in hospitality as Revenue Management System.
