# Table: `metrics_ga4`

## Purpose
This table provides the context for the user. While the `events` table tells us *what* happened, this table tells us *who* the visitor is and *how* they arrived at our digital real estate.

## Column Breakdown

| Column | Type | Definition / Business Logic |
| :--- | :--- | :--- |
| `user_pseudo_id` | STRING | The unique identifier for the browser/device. Links to the `events` table. |
| `user_first_touch_timestamp` | INTEGER | The time the user first visited the site. Used for Cohort and LTV analysis. |
| `traffic_source` | RECORD | Includes `name`, `medium`, and `source`. Defines the "Marketing Real Estate" that drove the visit. |
| `device` | RECORD | Nested data including `category` (Mobile/Desktop), `operating_system`, and `web_info_browser`. |
| `geo` | RECORD | Includes `country`, `region`, and `city`. Used to identify high-value geographic "Yield Zones." |
| `user_properties` | RECORD (REPEATED) | Custom attributes sent from the site (e.g., `loyalty_status` or `member_id`). |

## Key Metrics Captured
* **New vs. Returning Users:** Calculated by comparing `first_touch_timestamp` to the current session.
* **Source Efficiency:** Measuring which marketing channels (Search, Social, Direct) produce the highest RPI.
* **Mobile vs. Desktop Yield:** Identifying if specific "Real Estate" layouts perform better on different device categories.