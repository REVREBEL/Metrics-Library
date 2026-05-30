---
title: "GA4 Mapping Layer"
sidebarTitle: "Mapping Layer"
description: "Lookup tables that enrich GA4 placement and merchandise identifiers with business context."
---

# GA4 Mapping Layer

These tables enrich raw GA4 identifiers with business context.

## `map_web_placements`

**Purpose:**  
Defines known website placements, their zones, placement types, locations, and yield weights.

**Grain:**  
`property_code + placement_id`

| Column | Type | Description / Logic |
| --- | --- | --- |
| `property_code` | STRING | Standardized property identifier. |
| `placement_id` | STRING | Placement identifier from GA4 promotion tracking. |
| `placement_name` | STRING | Human-readable placement name. |
| `placement_type` | STRING | Banner, promo card, CTA, room module, package module, booking widget, etc. |
| `placement_zone` | STRING | Hero, Sidebar, Offer Grid, Booking Widget, Room Detail, Package Detail, Footer, etc. |
| `placement_location` | STRING | Site area such as homepage, rooms page, offers page, or booking path. |
| `placement_yield_weight` | FLOAT64 | Business-defined multiplier used to weight placement value. |
| `is_active` | BOOL | Whether the placement is currently active. |
| `effective_start_date` | DATE | Start date for placement mapping validity. |
| `effective_end_date` | DATE | End date for placement mapping validity. |

## `map_web_merchandise`

**Purpose:**  
Bridges GA4 item identifiers to room, package, offer, PMS, or CRS context.

**Grain:**  
`property_code + item_id`

| Column | Type | Description / Logic |
| --- | --- | --- |
| `property_code` | STRING | Standardized property identifier. |
| `item_id` | STRING | Native GA4 item ID. |
| `item_name` | STRING | Native GA4 item name. |
| `room_type_code` | STRING | PMS / CRS room type code, when applicable. |
| `room_type_name` | STRING | Human-readable room type name. |
| `room_class` | STRING | Standard, Deluxe, Premium, Suite, Specialty, etc. |
| `package_id` | STRING | Package or offer identifier. |
| `package_name` | STRING | Human-readable package or offer name. |
| `is_room` | BOOL | Whether the item represents room inventory. |
| `is_package` | BOOL | Whether the item represents a package or offer. |
| `is_add_on` | BOOL | Whether the item represents an add-on, such as early check-in or late check-out. |
| `is_event` | BOOL | Whether the item represents a specific event. |
| `is_active` | BOOL | Whether the merchandise mapping is active. |

## Recommended Supporting Maps

```text
map_ga4_property
map_web_placements
map_web_merchandise
map_web_event_taxonomy
map_ga4_channel_grouping
```

The mapping layer should be managed intentionally because it determines how anonymous GA4 identifiers become business-readable placement, room, package, offer, and channel logic.
