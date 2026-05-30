---
title: "GA4 Merchandise Interaction Layer"
sidebarTitle: "Merchandise Interactions"
description: "Behavioral staging model for room, package, offer, add-on, and event funnel movement."
---

# GA4 Merchandise Interaction Layer

## `stg_web_merchandise_interactions`

**Purpose:**  
Tracks how specific rooms, packages, offers, add-ons, events, and other bookable merchandise move through the digital funnel.

**Primary Source:**  
Raw GA4 event export

**Grain:**

```text
property_code + event_date + event_timestamp + user_pseudo_id + ga_session_id + item_id + source_event_name
```

| Column | Type | Business Logic / Source |
| --- | --- | --- |
| `property_code` | STRING | The property identifier. |
| `event_date` | DATE | Interaction date. |
| `event_timestamp` | TIMESTAMP | Event timestamp used for funnel sequencing. |
| `user_pseudo_id` | STRING | Anonymous GA4 user/device ID. |
| `ga_session_id` | STRING | Session anchor key. |
| `item_id` | STRING | Native GA4 item ID; should bridge back to PMS, CRS, room type, offer, or package code where possible. |
| `item_name` | STRING | Native GA4 item name. |
| `room_type_name` | STRING | Room name if the item represents room inventory. |
| `room_class` | STRING | Mapped room class, such as Standard, Deluxe, Premium, Suite, or Specialty. |
| `package_id` | STRING | Package or offer identifier, mapped from `itemVariant` or a package lookup. |
| `package_name` | STRING | Human-readable package or offer name. |
| `source_event_name` | STRING | Native GA4 event name, such as `view_item`, `add_to_cart`, `begin_checkout`, or `purchase`. |
| `is_viewed` | BOOL | True when `source_event_name = 'view_item'`. |
| `is_added_to_cart` | BOOL | True when `source_event_name = 'add_to_cart'`. |
| `is_checked_out` | BOOL | True when `source_event_name = 'begin_checkout'`. |
| `is_purchased` | BOOL | True when `source_event_name = 'purchase'`. |
| `transaction_id` | STRING | Transaction identifier used for purchase reconciliation. |
| `revenue_usd` | FLOAT64 | Item revenue associated with the merchandise interaction, usually populated on purchase events. |
| `insert_date` | DATE | Record ingestion date. |

## Notes

This table should remain event-level or near-event-level. Aggregated performance should happen later in the fact layer.
