# Forecast Budget & Pricing Table Models

## Metrics Platform

This document defines the planning, pricing, and writeback table models used throughout the Metrics Platform.

These models support forecasting, budgeting, pricing intelligence, and user-managed planning workflows across hospitality reporting and revenue operations.

Unlike operational fact tables, these datasets represent:
- planning inputs,
- observed market pricing,
- user-generated assumptions,
- override logic,****
- and strategic forecasting scenarios.

Because of this, they operate independently from pace, actual, pickup, and transactional reporting datasets.

The structure intentionally separates operational production data from planning and market-observation layers to preserve:
- auditability,
- version control,
- pricing history,
- scenario modeling,
- and forecasting flexibility.

**The objective is not simply storing values. The objective is preserving planning context.**



# Manual Forecast & Budget Writeback

## Planning Layer Philosophy

Forecasting and budgeting data behaves differently than operational reporting data.

Operational systems record what happened.

Planning systems model what may happen.

That distinction matters.

Manual forecasts, overrides, budgets, and strategic planning assumptions require:
- versioning,
- scenario management,
- workflow tracking,
- approval states,
- and user-level auditability.

The Metrics Platform models these inputs as a dedicated writeback layer rather than embedding them directly into operational fact tables.

This structure preserves:
- source-system integrity,
- historical planning continuity,
- and forecasting traceability.



# `fact_manual_plan`

## Table Purpose

`fact_manual_plan` stores:
- forecast values,
- budget submissions,
- override logic,
- strategic targets,
- planning scenarios,
- and user-managed forecasting inputs.

The table is designed to support:
- Google Sheets writeback,
- Apps Script integrations,
- workflow automation,
- API submissions,
- and future Metrics Platform planning interfaces.



## Table Grain

One row per:

```text
property_code + date + plan_type + scenario + version + grain_type + grain_key + metric_code
```

The table intentionally uses a long-format structure because planning inputs vary significantly across operational and strategic use cases.

Some forecasts may include:
- rooms,
- revenue,
- ADR,
- OCC,
- demand,
- wash,
- LRV,
- or custom planning assumptions.

The structure preserves flexibility without forcing rigid schema expansion every time the business evolves.



## Standard Planning Dimensions

| Field | Purpose |
|---|---|
| `plan_type` | Forecast, budget, override, target, scenario, reforecast |
| `scenario` | Planning scenario grouping |
| `version` | Version tracking (`v001`, `v002`, `final`) |
| `status` | Draft, submitted, approved, locked, archived |
| `grain_type` | Property, segment, source, roomtype, roompool, event |
| `metric_code` | Standardized metric reference |
| `metric_value` | User-submitted planning value |



# Forecasting & Planning Standards

The planning framework supports multiple forecasting layers simultaneously.

Examples include:

| Planning Type | Purpose |
|---|---|
| `Forecast` | Operational forecast values |
| `Budget` | Approved budget values |
| `Reforecast` | Updated operational forecast |
| `Override` | Manual adjustment to modeled forecasts |
| `Target` | Goal-based planning values |
| `Scenario` | Strategic planning simulations |

This structure allows planning workflows to evolve independently from transactional reporting.

Because forecasting is rarely static for long.



# Planning Workflow States

Planning records preserve operational workflow status through:

```text
Draft
Submitted
Approved
Locked
Archived
```

This supports:
- approval tracking,
- forecasting governance,
- scenario comparison,
- and historical planning continuity.



# Planning Views & Reporting Layers

The Metrics Platform generates reporting-friendly views from the long-format planning structure.

Examples:

```text
vw_manual_plan_property_daily
vw_manual_plan_segment_daily
vw_manual_plan_source_daily
vw_manual_plan_roomtype_daily
```

These reporting views pivot standardized `metric_code` values into operational reporting structures.

Examples:

```text
rms_bgt
rev_bgt
adr_bgt
rms_fct
rev_fct
adr_fct
occ_fct
```

This preserves operational reporting usability while maintaining flexible planning architecture underneath.



# Pricing Observation Framework

## Pricing Data Philosophy

Pricing observations behave differently than:
- operational production,
- pace reporting,
- or forecasting data.

Pricing data represents observed market conditions at a specific point in time.

That distinction matters.

Observed pricing is influenced by:
- booking channel,
- LOS,
- guest count,
- cancellation rules,
- membership access,
- room type,
- market compression,
- and competitor positioning.

The Metrics Platform models pricing observations as an independent market-intelligence layer rather than embedding pricing snapshots into operational fact tables.

This preserves:
- pricing history,
- rate-position analysis,
- compression analysis,
- and competitive pricing behavior.



# `fact_price_shop`

## Table Purpose

`fact_price_shop` stores observed market pricing from:
- OTA observations,
- rate shopping tools,
- CRS exports,
- booking engine captures,
- public pricing checks,
- and competitive pricing snapshots.

The table supports:
- pricing intelligence,
- rate-position analysis,
- competitive pricing analysis,
- and pricing trend evaluation.



## Table Grain

One row per observed pricing event.

```text
property_code + shop_date + date + los + guest_count + shop_channel + roomtype_code + rate_plan_code + price_type
```

This structure preserves the full pricing context of the observed market condition.



# Standard Pricing Dimensions

| Field | Purpose |
|---|---|
| `shop_date` | Date the pricing observation occurred |
| `shop_channel` | OTA, Brand.com, CRS, Google Hotels, etc. |
| `price_type` | BAR, Lowest Available, Package, Promo, Member Rate |
| `los` | Length of stay used during pricing observation |
| `guest_count` | Guest occupancy used in pricing request |
| `availability_status` | Available, soldout, unavailable, closed |
| `is_comp` | Competitive property observation flag |



# Pricing Intelligence Standards

The pricing framework supports:
- BAR analysis,
- competitive pricing comparisons,
- rate-position tracking,
- price-index calculations,
- compression analysis,
- and historical pricing trends.

Derived pricing analytics include:

| Metric | Purpose |
|---|---|
| `price_chg_ly` | Price change versus prior year |
| `price_pct_chg_ly` | Price percentage change versus prior year |
| `price_vs_bar` | Variance against BAR |
| `price_vs_comp_avg` | Variance against comp average |
| `price_index` | Relative pricing index |
| `is_price_leader` | Highest-priced competitive position |
| `is_price_lagging` | Below-market pricing position |



# Relationship to Operational Fact Tables

Planning and pricing datasets integrate with operational reporting layers through standardized dimensional joins.

## Planning Layer Relationships

```text
property_code + date + grain_type + grain_key + metric_code
```

## Pricing Layer Relationships

```text
property_code + date
```

Additional dimensional joins support:
- roomtype-level pricing,
- roompool analysis,
- event impact evaluation,
- and competitive market positioning.



# Warehouse Design Philosophy

The Metrics Platform separates:
- operational production,
- forecasting assumptions,
- user-managed planning,
- and observed market pricing

into distinct but interoperable reporting layers.

This structure preserves:
- reporting stability,
- pricing history,
- planning auditability,
- forecasting flexibility,
- and market-intelligence continuity.

**The goal is not simply storing forecasts or pricing observations. The goal is preserving the operational and strategic context behind the numbers.**