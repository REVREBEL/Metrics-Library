# Table: `metrics_ga4_events`

## Purpose
This table is the "Transaction Log" of the website. It records every interaction. For our **Merchandising Strategy**, this is where we track which "Real Estate" (banners/widgets) led to which "Inventory" (rooms/packages) being viewed or booked.

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