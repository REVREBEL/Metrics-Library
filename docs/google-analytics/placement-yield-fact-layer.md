---
title: "GA4 Placement Yield Fact Layer"
sidebarTitle: "Yield Facts"
description: "Final fact tables for placement yield, dead weight analysis, and merchandise velocity reporting."
---

# GA4 Placement Yield Fact Layer

The fact layer answers the primary business questions:

1. Which website placements are creating value?
2. Which placements are underperforming?
3. Which room classes, packages, or offers are gaining visibility but failing to convert?
4. Where is the site creating commercial lift or dead weight?

## `fct_web_placement_yield_daily`

**Purpose:**  
Final reporting table for identifying placement yield, opportunity cost, and dead weight.

**Grain:**

```text
property_code + event_date + placement_id
```

| Column | Type | Formula / Logic |
| --- | --- | --- |
| `property_code` | STRING | Property identifier. |
| `event_date` | DATE | Daily reporting grain. |
| `placement_id` | STRING | Placement identifier. |
| `placement_name` | STRING | Human-readable placement name. |
| `placement_type` | STRING | Banner, promo card, CTA, room module, package module, booking widget, etc. |
| `placement_zone` | STRING | Hero, Sidebar, Offer Grid, Booking Widget, Room Detail, Package Detail, Footer, etc. |
| `placement_yield_weight` | FLOAT64 | Lookup-based placement value multiplier. |
| `impressions` | INT64 | Count of placement impressions, typically from `view_promotion`. |
| `selections` | INT64 | Count of placement selections, typically from `select_promotion`. |
| `selection_pct` | FLOAT64 | `SAFE_DIVIDE(selections, impressions)`. |
| `attributed_item_views` | INT64 | Downstream item views attributed to the placement. |
| `attributed_add_to_carts` | INT64 | Downstream add-to-cart events attributed to the placement. |
| `attributed_checkouts` | INT64 | Downstream checkout starts attributed to the placement. |
| `attributed_purchases` | INT64 | Downstream purchases attributed to the placement. |
| `attributed_revenue_usd` | FLOAT64 | Sum of attributed revenue. |
| `revenue_per_impression_usd` | FLOAT64 | `SAFE_DIVIDE(attributed_revenue_usd, impressions)`. |
| `revenue_per_selection_usd` | FLOAT64 | `SAFE_DIVIDE(attributed_revenue_usd, selections)`. |
| `property_avg_revenue_per_impression_usd` | FLOAT64 | Average revenue per impression across the property. |
| `placement_yield_index` | FLOAT64 | `SAFE_DIVIDE(revenue_per_impression_usd, property_avg_revenue_per_impression_usd) * 100`. |
| `regular_ga4_impressions` | INT64 | Promotion impressions from regular GA4 reporting tables, when available. |
| `regular_ga4_selections` | INT64 | Promotion selections from regular GA4 reporting tables, when available. |
| `regular_ga4_item_revenue_usd` | FLOAT64 | Item revenue from regular GA4 reporting tables, when available. |
| `raw_regular_variance_pct` | FLOAT64 | Variance between raw-derived and regular GA4 reported values. |
| `is_dead_weight` | BOOL | True when the placement yield index falls below the configured threshold. |
| `dead_weight_reason` | STRING | Diagnostic explanation for the flag. |
| `updated_date` | DATE | Last record update. |

## Suggested Dead Weight Logic

```sql
CASE
  WHEN impressions >= 100
   AND placement_yield_index < 50
  THEN TRUE
  ELSE FALSE
END AS is_dead_weight
```

The minimum impression threshold prevents low-volume placements from being unfairly flagged.

## `fct_web_merchandise_velocity_daily`

**Purpose:**  
Measures room-type, package, and offer sales speed against site visibility.

**Grain:**

```text
property_code + event_date + room_class
```

| Column | Type | Formula / Logic |
| --- | --- | --- |
| `property_code` | STRING | Property identifier. |
| `event_date` | DATE | Daily reporting grain. |
| `room_class` | STRING | Room class, such as Standard, Deluxe, Premium, Suite, or Specialty. |
| `items_viewed` | INT64 | Total item views for this room class or merchandise category. |
| `items_added_to_cart` | INT64 | Total add-to-cart events. |
| `items_checked_out` | INT64 | Total checkout starts. |
| `items_purchased` | INT64 | Total units purchased. |
| `view_to_cart_pct` | FLOAT64 | `SAFE_DIVIDE(items_added_to_cart, items_viewed)`. |
| `cart_to_checkout_pct` | FLOAT64 | `SAFE_DIVIDE(items_checked_out, items_added_to_cart)`. |
| `checkout_to_purchase_pct` | FLOAT64 | `SAFE_DIVIDE(items_purchased, items_checked_out)`. |
| `view_to_purchase_pct` | FLOAT64 | `SAFE_DIVIDE(items_purchased, items_viewed)`. |
| `revenue_usd` | FLOAT64 | Total item revenue. |
| `revenue_per_view_usd` | FLOAT64 | `SAFE_DIVIDE(revenue_usd, items_viewed)`. |
| `package_attach_pct` | FLOAT64 | Percent of purchases that include a package ID. |
| `regular_ga4_items_viewed` | INT64 | Item views from regular GA4 reporting tables, when available. |
| `regular_ga4_items_purchased` | INT64 | Items purchased from regular GA4 reporting tables, when available. |
| `regular_ga4_item_revenue_usd` | FLOAT64 | Item revenue from regular GA4 reporting tables, when available. |
| `raw_regular_variance_pct` | FLOAT64 | Variance between raw-derived and regular GA4 reported values. |
| `merchandise_velocity_index` | FLOAT64 | Room class or merchandise conversion relative to the property average. |
| `updated_date` | DATE | Last record update. |

## Core Business Question

This model is designed to answer:

> Which website placements are creating commercial value, and which placements are consuming high-value attention without producing revenue, conversion, or downstream merchandise movement?
