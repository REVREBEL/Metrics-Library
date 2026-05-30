---
title: "GA4 Placement Merchandise Attribution"
sidebarTitle: "Attribution Layer"
description: "Intermediate attribution model connecting website placement interactions to downstream merchandise behavior and revenue."
---

# GA4 Placement Merchandise Attribution

## `int_web_placement_merchandise_attribution`

**Purpose:**  
Connects website placement interactions to downstream merchandise behavior and revenue.

This table answers:

```text
Which website placements influenced room, package, offer, or product engagement and revenue?
```

**Primary Source:**  
Raw GA4 event export, enriched with placement and merchandise mappings.

**Grain:**

```text
property_code + event_date + user_pseudo_id + ga_session_id + placement_id + item_id + attribution_method
```

| Column | Type | Business Logic / Source |
| --- | --- | --- |
| `property_code` | STRING | Property identifier. |
| `event_date` | DATE | Attribution date. |
| `user_pseudo_id` | STRING | Anonymous user/device ID. |
| `ga_session_id` | STRING | Session anchor key. |
| `placement_id` | STRING | Website placement identifier. |
| `placement_name` | STRING | Human-readable placement name. |
| `placement_type` | STRING | Banner, promo card, CTA, room module, package module, booking widget, etc. |
| `placement_zone` | STRING | Hero, Sidebar, Offer Grid, Booking Widget, Room Detail, Package Detail, Footer, etc. |
| `placement_yield_weight` | FLOAT64 | Lookup-based placement value multiplier. |
| `interaction_type` | STRING | `impression` or `selection`. |
| `interaction_timestamp` | TIMESTAMP | Timestamp of the placement interaction. |
| `item_id` | STRING | Merchandise item ID. |
| `item_name` | STRING | Merchandise item name. |
| `room_class` | STRING | Mapped room class. |
| `package_id` | STRING | Package or offer identifier. |
| `downstream_event_name` | STRING | Downstream merchandise event, such as `view_item`, `add_to_cart`, `begin_checkout`, or `purchase`. |
| `downstream_event_timestamp` | TIMESTAMP | Timestamp of the downstream merchandise event. |
| `transaction_id` | STRING | Transaction identifier, when available. |
| `revenue_usd` | FLOAT64 | Revenue attached to the downstream event. |
| `attribution_weight` | FLOAT64 | Attribution credit assigned to the placement. |
| `attributed_revenue_usd` | FLOAT64 | `revenue_usd * attribution_weight`. |
| `attribution_method` | STRING | Attribution logic used. |
| `updated_date` | DATE | Last record update. |

## Recommended Attribution Methods

| Attribution Method | Logic |
| --- | --- |
| `same_session_selection` | Placement selection and downstream merchandise activity happen in the same session. |
| `same_session_impression` | Placement impression and downstream merchandise activity happen in the same session. |
| `last_touch_selection` | Most recent placement selection before a downstream merchandise event. |
| `weighted_view_through` | Impression receives partial credit even without a selection. |
| `zone_weighted` | Attribution is adjusted by placement zone or yield weight. |

## Modeling Notes

The attribution layer should not be treated as a final reporting table. It is an intermediate bridge between event-level behavior and the final placement yield facts.

Attribution logic should be explicit, repeatable, and recorded in `attribution_method` so analysts can compare different attribution strategies without changing the downstream fact table contract.
