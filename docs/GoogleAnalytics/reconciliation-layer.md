---
title: "GA4 Reconciliation Layer"
sidebarTitle: "Reconciliation QA"
description: "Quality assurance model for comparing raw GA4 event export metrics against processed GA4 reporting tables."
---

# GA4 Reconciliation Layer

## `qa_ga4_raw_vs_regular_daily`

**Purpose:**  
Compares raw-event-derived metrics against regular GA4 reporting table metrics.

This layer keeps both GA4 lanes honest and helps identify differences caused by attribution models, privacy thresholding, consent mode, data processing windows, or aggregation logic.

**Grain:**

```text
property_code + event_date + metric_name + comparison_scope
```

| Column | Type | Business Logic / Source |
| --- | --- | --- |
| `property_code` | STRING | Property identifier. |
| `event_date` | DATE | Reporting date. |
| `comparison_scope` | STRING | Scope of comparison, such as acquisition, content, commerce, promotion, audience, or technology. |
| `metric_name` | STRING | Metric being reconciled. |
| `raw_value` | FLOAT64 | Value derived from raw GA4 event export. |
| `regular_report_value` | FLOAT64 | Value from processed regular GA4 reporting table. |
| `variance_value` | FLOAT64 | `raw_value - regular_report_value`. |
| `variance_pct` | FLOAT64 | `SAFE_DIVIDE(variance_value, regular_report_value)`. |
| `tolerance_pct` | FLOAT64 | Acceptable variance threshold. |
| `is_within_tolerance` | BOOL | True when variance is within the accepted tolerance. |
| `notes` | STRING | Optional explanation or known issue. |
| `updated_date` | DATE | Last record update. |

## Notes

GA4 raw export and GA4 regular reporting tables may not tie perfectly. The goal is not always a zero variance. The goal is to understand whether the variance is explainable and within tolerance.

## Example Comparison Scopes

```text
acquisition
content
commerce
promotion
placement
audience
demographic
technology
```

## Example Reconciled Metrics

```text
sessions
active_users
new_users
key_events
impressions
selections
items_viewed
items_purchased
revenue_usd
```
