---
title: Forecast Budget and Pricing Table Models
nav_order: 6
has_toc: true
permalink: /forecast-budget-and-pricing-table-models/
---

# Forecast Budget and Pricing Table Models

This document defines two additional table models for the REVREBEL BI Platform:

1. A manual forecast and budget writeback table for user-entered forecasts, budgets, and planning values from Google Sheets or other user-facing input tools.
2. A pricing observation table for rate shop, OTA, CRS, booking engine, and public pricing data.

These should be modeled separately from pace, actual, pickup, and event tables because they have different grains, update patterns, and governance needs.

---

## 1. Manual Forecast and Budget Writeback

## Recommendation

Create a dedicated writeback table:

```text
fact_manual_plan
```

This table should store user-submitted forecast, budget, override, and planning values. It should be easy to write to from Google Sheets, Apps Script, n8n, API forms, or future REVREBEL platform interfaces.

## Why this should be separate

Manual forecast and budget values are not source-system facts. They are user-managed planning inputs.

A separate table is better because it:

1. Supports writeback without touching source-loaded fact tables.
2. Preserves user-entered values separately from PMS/RMS/CRS data.
3. Allows versioning and approval workflow.
4. Allows multiple planning scenarios.
5. Makes it easy to pull data back into Sheets for editing.
6. Supports overrides at property, segment, source, or roomtype grain.
7. Creates a clear audit trail of who changed what and when.

## `fact_manual_plan`

### Grain

One row per property, date, plan type, scenario, version, and optional business grain.

Recommended grain:

```text
property_code + date + plan_type + scenario + version + grain_type + grain_key + metric_code
```

This table should be long/narrow because user planning inputs can vary widely. Some forecasts may include rooms and revenue. Others may include ADR, OCC, demand, wash, LRV, or custom assumptions.

### Columns

| Column | Type | Notes |
|---|---|---|
| `plan_id` | STRING | Unique planning row identifier. |
| `property_code` | STRING | Property code. |
| `property_name` | STRING | Property name, optional convenience field. |
| `date` | DATE | Date the plan value applies to. |
| `plan_type` | STRING | Forecast, budget, override, target, scenario, reforecast. |
| `scenario` | STRING | Planning scenario name, such as Base, Upside, Downside, Owner, Stretch. |
| `version` | STRING | Version value such as `v001`, `v002`, `final`. |
| `status` | STRING | Draft, submitted, approved, locked, archived. |
| `grain_type` | STRING | Property, segment, source, roomtype, roompool, event, other. |
| `grain_key` | STRING | Standard grain value or combined key for the planning row. |
| `segment` | STRING | Standard segment, if applicable. |
| `segment_code` | STRING | Standard segment code, if applicable. |
| `source` | STRING | Standard source, if applicable. |
| `source_code` | STRING | Standard source code, if applicable. |
| `roomtype` | STRING | Standard roomtype, if applicable. |
| `roomtype_code` | STRING | Standard roomtype code, if applicable. |
| `roompool` | STRING | Standard roompool, if applicable. |
| `roompool_code` | STRING | Standard roompool code, if applicable. |
| `metric_code` | STRING | Standard metric code, such as `rms`, `rev`, `adr`, `occ`, `available_rms`, `demand_total`, `wash_pct`, `lrv`, `bar_price`. |
| `metric_value` | FLOAT64 | User-entered metric value. |
| `metric_value_type` | STRING | Count, currency, percent, ratio, text. |
| `currency_code` | STRING | Currency code, if applicable. |
| `source_system` | STRING | Source of the writeback, such as Google Sheets, app, API, manual upload. |
| `source_sheet_id` | STRING | Google Sheet ID, if loaded from Sheets. |
| `source_sheet_name` | STRING | Google Sheet tab name, if loaded from Sheets. |
| `source_cell` | STRING | Optional source cell reference for auditability. |
| `submitted_by` | STRING | User who submitted or edited the value. |
| `submitted_at` | TIMESTAMP | Timestamp when the value was submitted. |
| `approved_by` | STRING | Approver, if applicable. |
| `approved_at` | TIMESTAMP | Approval timestamp, if applicable. |
| `plan_notes` | STRING | User-entered notes. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

## Standard plan type values

Use the field:

```text
plan_type
```

Recommended values:

| Value | Use Case |
|---|---|
| `Forecast` | User-generated forecast values. |
| `Budget` | Approved budget values. |
| `Reforecast` | Updated forecast after original budget/forecast. |
| `Override` | Manual override to system-generated forecast. |
| `Target` | Goal or target value. |
| `Scenario` | Scenario planning value. |

## Standard status values

Use the field:

```text
status
```

Recommended values:

| Value |
|---|
| `Draft` |
| `Submitted` |
| `Approved` |
| `Locked` |
| `Archived` |

## Recommended views from `fact_manual_plan`

Create BI-friendly wide views after values are stored in long format.

```text
vw_manual_plan_property_daily
vw_manual_plan_segment_daily
vw_manual_plan_source_daily
vw_manual_plan_roomtype_daily
```

These can pivot `metric_code` values into columns such as:

```text
rms_bgt
rev_bgt
adr_bgt
rms_fct
rev_fct
adr_fct
occ_fct
demand_total
wash_pct
lrv
bar_price
```

---

## 2. Pricing Observation Table

## Recommendation

Create a dedicated pricing table:

```text
fact_price_shop
```

This table should store observed prices from rate shopping tools, OTA scrapes, CRS/booking engine extracts, brand.com checks, and manual price collection.

## Why this should be separate

Pricing data is not the same as pace, actuals, or forecast. It is an observed market signal with its own grain.

A separate table is better because it:

1. Supports multiple shop dates and stay dates.
2. Supports channel/source-specific pricing.
3. Supports LOS, occupancy/guest count, room type, rate plan, and cancellation policy dimensions.
4. Keeps pricing history for competitive and price-sensitivity analysis.
5. Enables price-position and compression analysis when joined to pace and event tables.
6. Can store both BAR and lowest available rate observations without adding fragile columns to pace facts.

## `fact_price_shop`

### Grain

One row per observed price.

Recommended grain:

```text
property_code + shop_date + date + los + guest_count + shop_channel + roomtype_code + rate_plan_code + price_type
```

### Columns

| Column | Type | Notes |
|---|---|---|
| `price_shop_id` | STRING | Unique pricing observation identifier. |
| `property_code` | STRING | Property code. |
| `property_name` | STRING | Property name, optional convenience field. |
| `shop_date` | DATE | Date the price was observed or scraped. |
| `shop_ts` | TIMESTAMP | Timestamp the price was observed or scraped. |
| `date` | DATE | Stay/arrival date the price applies to. |
| `los` | INT64 | Length of stay used in the price search. |
| `guest_count` | INT64 | Guest count used in the price search. |
| `adult_count` | INT64 | Adult count, if provided separately. |
| `child_count` | INT64 | Child count, if provided. |
| `shop_channel` | STRING | Channel shopped, such as Booking.com, Expedia, Brand.com, Google Hotels. |
| `shop_channel_code` | STRING | Standard shop channel code. |
| `source_system` | STRING | Source system, scraper, rate shop provider, or manual source. |
| `source_report` | STRING | Source report/feed name. |
| `source_file` | STRING | Source file path/name, if imported. |
| `rate_type` | STRING | BAR, lowest, member, package, promo, opaque, mobile, etc. |
| `price_type` | STRING | BAR, lowest_available, public_rate, member_rate, package_rate, promo_rate. |
| `currency_code` | STRING | Currency code. |
| `price_amt` | FLOAT64 | Observed price amount. |
| `price_amt_tax_incl` | FLOAT64 | Observed price including taxes/fees, if available. |
| `tax_amt` | FLOAT64 | Tax amount, if available. |
| `fee_amt` | FLOAT64 | Fee amount, if available. |
| `is_available` | BOOL | Whether the rate was available. |
| `is_soldout` | BOOL | Whether the stay date/channel was sold out. |
| `availability_status` | STRING | Available, unavailable, soldout, closed, error, unknown. |
| `roomtype` | STRING | Standard roomtype, if available. |
| `roomtype_code` | STRING | Standard roomtype code, if available. |
| `roomtype_map` | STRING | Source room type value, if needed. |
| `roomtype_code_map` | STRING | Source room type code, if needed. |
| `roomclass` | STRING | Room class/category, if available. |
| `roompool` | STRING | Standard roompool, if available. |
| `roompool_code` | STRING | Standard roompool code, if available. |
| `rate_plan` | STRING | Rate plan name, if available. |
| `rate_plan_code` | STRING | Rate plan code, if available. |
| `rate_plan_map` | STRING | Source rate plan value, if needed. |
| `rate_plan_code_map` | STRING | Source rate plan code, if needed. |
| `meal_plan` | STRING | Meal plan or breakfast inclusion, if available. |
| `cancel_policy` | STRING | Cancellation policy text/category. |
| `payment_policy` | STRING | Pay now, pay later, prepaid, deposit, etc. |
| `is_refundable` | BOOL | Refundability flag. |
| `is_member_rate` | BOOL | Member/private rate flag. |
| `is_mobile_rate` | BOOL | Mobile-only rate flag. |
| `is_package_rate` | BOOL | Package rate flag. |
| `promo_text` | STRING | Promotion or rate text, if available. |
| `price_rank` | INT64 | Rank of the observed price in the shop result, if available. |
| `comp_property_code` | STRING | Competitor property code, if the observation is for a comp property. |
| `comp_property_name` | STRING | Competitor property name, if applicable. |
| `is_comp` | BOOL | True if the observation is a competitor property rate. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

## Standard price type values

Use the field:

```text
price_type
```

Recommended values:

| Value | Use Case |
|---|---|
| `BAR` | Best available rate observation. |
| `Lowest Available` | Lowest publicly available observed rate. |
| `Public Rate` | Public retail rate. |
| `Member Rate` | Member/private observed rate. |
| `Package Rate` | Package rate observation. |
| `Promo Rate` | Promotional rate observation. |
| `Comp BAR` | Competitor BAR observation. |
| `Comp Lowest Available` | Competitor lowest available rate observation. |

## Recommended pricing marts/views

Create BI-friendly views for common pricing questions.

```text
mart_pricing_daily
mart_pricing_roomtype_daily
mart_pricing_comp_daily
```

Recommended derived fields:

| Column | Definition |
|---|---|
| `price_chg_ly` | Price amount change versus prior year, if comparable data exists. |
| `price_pct_chg_ly` | Price percent change versus prior year. |
| `price_vs_bar` | Difference between observed price and BAR. |
| `price_vs_comp_avg` | Difference between property price and comp average. |
| `price_index` | Property price divided by comp average price. |
| `is_price_leader` | True when property price is highest or leading the comp set. |
| `is_price_lagging` | True when property price is materially below comp set. |

---

## Relationship to Existing Fact Tables

## Manual plan table joins

`fact_manual_plan` can be joined into pace/actual marts by:

```text
property_code + date + grain_type + grain_key + metric_code
```

For property-level planning:

```text
property_code + date + plan_type + scenario + version
```

For segment planning:

```text
property_code + date + segment_code + plan_type + scenario + version
```

For roomtype planning:

```text
property_code + date + roomtype_code + plan_type + scenario + version
```

## Pricing table joins

`fact_price_shop` can be joined to pace and demand models by:

```text
property_code + date
```

For roomtype-level pricing:

```text
property_code + date + roomtype_code
```

For roompool-level pricing:

```text
property_code + date + roompool_code
```

For event impact analysis:

```text
property_code + date
```

join to:

```text
bridge_property_event_date
```

---

## Example BigQuery DDL

```sql
CREATE TABLE IF NOT EXISTS `PROJECT_ID.DATASET.fact_manual_plan` (
  plan_id STRING OPTIONS(description="Unique planning row identifier."),
  property_code STRING OPTIONS(description="Property code."),
  property_name STRING OPTIONS(description="Property name, optional convenience field."),
  date DATE OPTIONS(description="Date the plan value applies to."),
  plan_type STRING OPTIONS(description="Forecast, budget, override, target, scenario, or reforecast."),
  scenario STRING OPTIONS(description="Planning scenario name."),
  version STRING OPTIONS(description="Planning version such as v001, v002, or final."),
  status STRING OPTIONS(description="Planning status such as Draft, Submitted, Approved, Locked, or Archived."),
  grain_type STRING OPTIONS(description="Property, segment, source, roomtype, roompool, event, or other."),
  grain_key STRING OPTIONS(description="Standard grain value or combined key for the planning row."),
  segment STRING OPTIONS(description="Standard segment, if applicable."),
  segment_code STRING OPTIONS(description="Standard segment code, if applicable."),
  source STRING OPTIONS(description="Standard source, if applicable."),
  source_code STRING OPTIONS(description="Standard source code, if applicable."),
  roomtype STRING OPTIONS(description="Standard roomtype, if applicable."),
  roomtype_code STRING OPTIONS(description="Standard roomtype code, if applicable."),
  roompool STRING OPTIONS(description="Standard roompool, if applicable."),
  roompool_code STRING OPTIONS(description="Standard roompool code, if applicable."),
  metric_code STRING OPTIONS(description="Standard metric code."),
  metric_value FLOAT64 OPTIONS(description="User-entered metric value."),
  metric_value_type STRING OPTIONS(description="Count, currency, percent, ratio, or text."),
  currency_code STRING OPTIONS(description="Currency code, if applicable."),
  source_system STRING OPTIONS(description="Source of the writeback, such as Google Sheets, app, API, or manual upload."),
  source_sheet_id STRING OPTIONS(description="Google Sheet ID, if loaded from Sheets."),
  source_sheet_name STRING OPTIONS(description="Google Sheet tab name, if loaded from Sheets."),
  source_cell STRING OPTIONS(description="Optional source cell reference for auditability."),
  submitted_by STRING OPTIONS(description="User who submitted or edited the value."),
  submitted_at TIMESTAMP OPTIONS(description="Timestamp when the value was submitted."),
  approved_by STRING OPTIONS(description="Approver, if applicable."),
  approved_at TIMESTAMP OPTIONS(description="Approval timestamp, if applicable."),
  plan_notes STRING OPTIONS(description="User-entered planning notes."),
  insert_date DATE OPTIONS(description="Insert date."),
  updated_date DATE OPTIONS(description="Updated date.")
)
OPTIONS(description="Manual forecast, budget, scenario, and override writeback table for user-entered planning values.");

CREATE TABLE IF NOT EXISTS `PROJECT_ID.DATASET.fact_price_shop` (
  price_shop_id STRING OPTIONS(description="Unique pricing observation identifier."),
  property_code STRING OPTIONS(description="Property code."),
  property_name STRING OPTIONS(description="Property name, optional convenience field."),
  shop_date DATE OPTIONS(description="Date the price was observed or scraped."),
  shop_ts TIMESTAMP OPTIONS(description="Timestamp the price was observed or scraped."),
  date DATE OPTIONS(description="Stay or arrival date the price applies to."),
  los INT64 OPTIONS(description="Length of stay used in the price search."),
  guest_count INT64 OPTIONS(description="Guest count used in the price search."),
  adult_count INT64 OPTIONS(description="Adult count, if provided separately."),
  child_count INT64 OPTIONS(description="Child count, if provided."),
  shop_channel STRING OPTIONS(description="Channel shopped, such as Booking.com, Expedia, Brand.com, or Google Hotels."),
  shop_channel_code STRING OPTIONS(description="Standard shop channel code."),
  source_system STRING OPTIONS(description="Source system, scraper, rate shop provider, or manual source."),
  source_report STRING OPTIONS(description="Source report or feed name."),
  source_file STRING OPTIONS(description="Source file path or name, if imported."),
  rate_type STRING OPTIONS(description="BAR, lowest, member, package, promo, opaque, mobile, etc."),
  price_type STRING OPTIONS(description="BAR, lowest available, public rate, member rate, package rate, promo rate, or comp pricing type."),
  currency_code STRING OPTIONS(description="Currency code."),
  price_amt FLOAT64 OPTIONS(description="Observed price amount."),
  price_amt_tax_incl FLOAT64 OPTIONS(description="Observed price including taxes and fees, if available."),
  tax_amt FLOAT64 OPTIONS(description="Tax amount, if available."),
  fee_amt FLOAT64 OPTIONS(description="Fee amount, if available."),
  is_available BOOL OPTIONS(description="Whether the rate was available."),
  is_soldout BOOL OPTIONS(description="Whether the stay date or channel was sold out."),
  availability_status STRING OPTIONS(description="Available, unavailable, soldout, closed, error, or unknown."),
  roomtype STRING OPTIONS(description="Standard roomtype, if available."),
  roomtype_code STRING OPTIONS(description="Standard roomtype code, if available."),
  roomtype_map STRING OPTIONS(description="Source room type value, if needed."),
  roomtype_code_map STRING OPTIONS(description="Source room type code, if needed."),
  roomclass STRING OPTIONS(description="Room class or category, if available."),
  roompool STRING OPTIONS(description="Standard roompool, if available."),
  roompool_code STRING OPTIONS(description="Standard roompool code, if available."),
  rate_plan STRING OPTIONS(description="Rate plan name, if available."),
  rate_plan_code STRING OPTIONS(description="Rate plan code, if available."),
  rate_plan_map STRING OPTIONS(description="Source rate plan value, if needed."),
  rate_plan_code_map STRING OPTIONS(description="Source rate plan code, if needed."),
  meal_plan STRING OPTIONS(description="Meal plan or breakfast inclusion, if available."),
  cancel_policy STRING OPTIONS(description="Cancellation policy text or category."),
  payment_policy STRING OPTIONS(description="Pay now, pay later, prepaid, deposit, etc."),
  is_refundable BOOL OPTIONS(description="Refundability flag."),
  is_member_rate BOOL OPTIONS(description="Member/private rate flag."),
  is_mobile_rate BOOL OPTIONS(description="Mobile-only rate flag."),
  is_package_rate BOOL OPTIONS(description="Package rate flag."),
  promo_text STRING OPTIONS(description="Promotion or rate text, if available."),
  price_rank INT64 OPTIONS(description="Rank of the observed price in the shop result, if available."),
  comp_property_code STRING OPTIONS(description="Competitor property code, if the observation is for a comp property."),
  comp_property_name STRING OPTIONS(description="Competitor property name, if applicable."),
  is_comp BOOL OPTIONS(description="True if the observation is for a competitor property rate."),
  insert_date DATE OPTIONS(description="Insert date."),
  updated_date DATE OPTIONS(description="Updated date.")
)
OPTIONS(description="Pricing observation table for BAR, lowest available, OTA, CRS, booking engine, rate shop, and competitive pricing data.");
```
