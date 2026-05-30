---
title: "p_ga4_Events"
sidebarTitle: "Events"
description: "Unified telemetry event tracking and frequency metrics."
---

## Schema Purpose
The `p_ga4_Events_281286275` table serves as the primary aggregation matrix for all custom and default telemetry events triggered across web and mobile platforms.[1] This table simplifies standard event analysis by isolating the total event counts, active tracking frequencies, and overall financial values associated with individual event types. This table is the "Transaction Log" of the website. It records every interaction. For our **Merchandising Strategy**, this is where we track which "Real Estate" (banners/widgets) led to which "Inventory" (rooms/packages) being viewed or booked.

## Table Schema

| Column Name | Data Type | Column Definition & Calculated Metric Representation |
| :--- | :--- | :--- |
| eventName | STRING | The designated name or identifier of the triggered telemetry event.[1] |
| eventCount | INTEGER | The total frequency count of the specified event name triggered during the reporting window.[1] |
| eventCountPerUser | FLOAT | The average number of events per active user.[1] Formulated as: $$\text{Event Count Per User} = \frac{\text{Event Count}}{\text{Active Users}}$$ |
| totalRevenue | FLOAT | The sum of revenue generated from purchases, subscriptions, and advertising minus refunded transaction revenue.[1] |
| totalUsers | INTEGER | The count of distinct users who have logged at least one event during the active period.[1] |

## Analytical Considerations
Analyzing event frequencies is essential for identifying friction points in the user experience. A high `eventCountPerUser` on error events (such as form submission errors) can indicate technical issues or design challenges within a registration or checkout flow.[1] 

By comparing total events and unique active users, teams can quickly isolate features or elements that drive repetitive user interactions.


## Column Breakdown

| Column | Type | Definition / Business Logic |
| :--- | :--- | :--- |
| `event_date` | STRING | The date the event was logged (YYYYMMDD). Used for partitioning. |
| `event_timestamp` | INTEGER | The microsecond-precision time of the event. Essential for sequencing the "Path to Purchase." |
| `event_name` | STRING | The action type (e.g., `view_item`, `select_promotion`, `purchase`). |
| `event_params` | RECORD (REPEATED) | **The Key Vault.** A nested array containing `key` and `value` pairs (e.g., `page_location`, `session_id`). |
| `user_pseudo_id` | STRING | The anonymous device ID. The primary key for stitching sessions together. |
| `items` | RECORD (REPEATED) | **The Merchandising Array.** Contains data about specific rooms or packages (e.g., `item_id`, `item_category`). |
| `ecommerce` | RECORD | Summary data for transactions, including `total_item_quantity` and `purchase_revenue_in_usd`. |

## Key Metrics Captured
* **Total Impressions:** Derived from `view_promotion` and `view_item_list` events.
* **Selection Rate:** The ratio of `select_content` to impressions per section.
* **Add-to-Cart (Room Selection):** Count of `add_to_cart` events categorized by `item_category` (Room Type).
* **Gross Web Revenue:** The `value` parameter associated with the `purchase` event.