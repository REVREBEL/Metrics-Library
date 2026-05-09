---
title: REVREBEL BI Table Architecture
nav_order: 3
has_toc: true
permalink: /revrebel-bi-table-architecture/
---

# REVREBEL BI Table Architecture

This document maps the proposed standard table structure for the REVREBEL BI Platform. The goal is to maintain a stable set of standardized tables and columns that can power dashboards even when source reports arrive from different PMS, RMS, CRS, booking engine, and reporting systems with inconsistent formats and metric availability.

## Design Principles

1. Keep fact tables separated by business grain: property, segment, source, and roomtype.
2. Keep core pace/actual tables wide enough for BI tools to use easily.
3. Keep pickup tables long/narrow because pickup windows and comparison periods expand quickly.
4. Store additive/source-provided metrics in fact tables.
5. Calculate derived KPIs such as ADR, OCC, and RevPAR in marts or semantic views when base metrics are available.
6. Use mapping tables to preserve source-system values and normalize inconsistent source labels.
7. Use standardized column names from the Database Column Naming Standards.

## Table List

### Core Dimensions

| Table | Purpose |
|---|---|
| `dim_property` | Standard property/hotel reference table. |
| `dim_date` | Calendar/date dimension. |
| `dim_segment` | Standard segment reference table. |
| `dim_source` | Standard source/channel reference table. |
| `dim_roomtype` | Standard room type and room class reference table. |
| `dim_metric` | Metric dictionary and calculation rules. |
| `dim_source_report` | Metadata for imported files/reports/systems. |

### Mapping Tables

| Table | Purpose |
|---|---|
| `map_segment` | Maps source segment names/codes to standardized segment values. |
| `map_source` | Maps source/channel names/codes to standardized source and channel values. |
| `map_roomtype` | Maps source room type names/codes to standardized roomtype values. |
| `map_source_metric` | Maps raw source report columns to standardized metric codes/columns. |

### Pace Fact Tables

| Table | Purpose |
|---|---|
| `fact_pace_property` | Property-level on-the-books pace snapshot metrics. |
| `fact_pace_segment` | Segment-level on-the-books pace snapshot metrics. |
| `fact_pace_source` | Source/channel-level on-the-books pace snapshot metrics. |
| `fact_pace_roomtype` | Roomtype-level on-the-books pace snapshot metrics. |

### Actual Fact Tables

| Table | Purpose |
|---|---|
| `fact_actual_property` | Property-level actualized historical performance. |
| `fact_actual_segment` | Segment-level actualized historical performance. |
| `fact_actual_source` | Source/channel-level actualized historical performance. |
| `fact_actual_roomtype` | Roomtype-level actualized historical performance. |

### Pickup Fact Tables

| Table | Purpose |
|---|---|
| `fact_pickup_property` | Property-level pickup metrics by comparison and pickup window. |
| `fact_pickup_segment` | Segment-level pickup metrics by comparison and pickup window. |
| `fact_pickup_source` | Source/channel-level pickup metrics by comparison and pickup window. |
| `fact_pickup_roomtype` | Roomtype-level pickup metrics by comparison and pickup window. |

### Flexible/Sparse Metric Table

| Table | Purpose |
|---|---|
| `fact_metric_observation` | Stores sparse or irregular metrics that do not fit cleanly into standard wide fact tables. |

### BI Mart / Semantic Views

| Table/View | Purpose |
|---|---|
| `mart_property_daily` | Dashboard-ready property daily performance table/view. |
| `mart_segment_daily` | Dashboard-ready segment daily performance table/view. |
| `mart_source_daily` | Dashboard-ready source/channel daily performance table/view. |
| `mart_roomtype_daily` | Dashboard-ready roomtype daily performance table/view. |

## Table Columns

## Core Dimensions

### `dim_property`

| Column | Type | Notes |
|---|---|---|
| `property_code` | STRING | Primary property code. |
| `property_name` | STRING | Standard property name. |
| `property_shortname` | STRING | Standard property name. |
| `property_status` | STRING | Active, inactive, onboarding, archived. |
| `rating` | STRING | Star Rating. |
| `brand` | STRING | Brand or collection. |
| `market` | STRING | Primary market. |
| `city` | STRING | City. |
| `state` | STRING | State/province. |
| `country` | STRING | Country. |
| `timezone` | STRING | IANA timezone. |
| `str_id` | STRING | Standard STR / CoStar identifier. |
| `crs_id` | STRING | CRS identifier. |
| `pms_id` | STRING | PMS identifier. |
| `rateshop_id` | STRING | Rateshop identifier. |
| `available_rms` | INT64 | Default room inventory, if stable. |
| `open_date` | DATE | Property open date. |
| `close_date` | DATE | Property close date, if applicable. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### `dim_date`

| Column | Type | Notes |
|---|---|---|
| `date` | DATE | Primary date. |
| `date_key` | INT64 | YYYYMMDD key. |
| `year` | INT64 | Calendar year. |
| `quarter` | INT64 | Calendar quarter. |
| `month` | INT64 | Calendar month. |
| `month_name` | STRING | Month name. |
| `week` | INT64 | Week number. |
| `day_of_week` | STRING | Day of week name. |
| `day_of_week_no` | INT64 | Day of week number. |
| `is_weekend` | BOOL | Weekend flag. |

### `dim_segment`

| Column | Type | Notes |
|---|---|---|
| `segment` | STRING | Standard segment name. |
| `segment_code` | STRING | Standard segment code. |
| `segment_group` | STRING | Standard group segment name. |
| `segment_group_code` | STRING | Standard group segment code. |
| `finance_segment` | STRING | Finance segment name. |
| `finance_segment_code` | STRING | Finance segment code. |
| `gl_code` | STRING | Guest ledger code. |
| `segment_category` | STRING | Group, transient, contract, complimentary, etc. |
| `rate_basis` | STRING | full rate reported, net, mixed, discount |
| `segment_sort` | INT64 | BI sort order. |
| `is_active` | BOOL | Active flag. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### `dim_source`

| Column | Type | Notes |
|---|---|---|
| `source` | STRING | Standard source name. |
| `source_code` | STRING | Standard source code. |
| `channel` | STRING | Standard channel name. |
| `channel_code` | STRING | Standard channel code. |
| `source_category` | STRING | Direct, OTA, GDS, wholesale, brand, voice, etc. |
| `source_sort` | INT64 | BI sort order. |
| `is_active` | BOOL | Active flag. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### `dim_roomtype`

| Column | Type | Notes |
|---|---|---|
| `property_code` | STRING | Property code. |
| `roomtype` | STRING | Standard room type name. |
| `roomtype_code` | STRING | Standard room type code. |
| `bedtype` | STRING | Standard room type name. |
| `bedtype_code` | STRING | Standard room type code. |
| `roomclass` | STRING | Room class/category. |
| `roomfeature` | STRING | Primary Feature, size, view, amenity. |
| `related_roomtypes` | STRING | Room types that share ideinital feaures but may be seperated by bedtype or floor |
| `available_rms` | INT64 | Default inventory for the roomtype, if stable. |
| `roomtype_sort` | INT64 | BI sort order. |
| `is_active` | BOOL | Active flag. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### `dim_metric`

| Column | Type | Notes |
|---|---|---|
| `metric_code` | STRING | Standard metric code. |
| `metric_name` | STRING | Display name. |
| `metric_category` | STRING | Revenue, rooms, rate, occupancy, demand, pickup, etc. |
| `metric_type` | STRING | Count, currency, percent, ratio, text. |
| `is_additive` | BOOL | Whether the metric can be summed. |
| `calc_method` | STRING | Source, derived, mapped, manual. |
| `formula` | STRING | Formula for derived metrics. |
| `display_format` | STRING | BI display format. |
| `description` | STRING | Metric definition. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### `dim_source_report`

| Column | Type | Notes |
|---|---|---|
| `source_report_id` | STRING | Unique source report identifier. |
| `source_system` | STRING | PMS, RMS, CRS, booking engine, manual, etc. |
| `source_report` | STRING | Source report name. |
| `source_file` | STRING | Source file name or path. |
| `property_code` | STRING | Property code, if report is property-specific. |
| `report_grain` | STRING | Property, segment, source, roomtype, mixed, unknown. |
| `report_type` | STRING | Pace, actual, pickup, forecast, budget, mapping, etc. |
| `extract_date` | DATE | Date extracted. |
| `insert_date` | DATE | Insert date. |

## Mapping Tables

### `map_segment`

| Column | Type | Notes |
|---|---|---|
| `property_code` | STRING | Property code. |
| `source_system` | STRING | Source system. |
| `segment_map` | STRING | Source segment value. |
| `segment_code_map` | STRING | Source segment code. |
| `segment` | STRING | Standard segment. |
| `segment_code` | STRING | Standard segment code. |
| `segment_category` | STRING | Standard segment category. |
| `is_active` | BOOL | Active flag. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### `map_source`

| Column | Type | Notes |
|---|---|---|
| `property_code` | STRING | Property code. |
| `source_system` | STRING | Source system. |
| `source_map` | STRING | Source value from report. |
| `source_code_map` | STRING | Source code from report. |
| `source` | STRING | Standard source. |
| `source_code` | STRING | Standard source code. |
| `channel` | STRING | Standard channel. |
| `channel_code` | STRING | Standard channel code. |
| `source_category` | STRING | Source category. |
| `is_active` | BOOL | Active flag. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### `map_roomtype`

| Column | Type | Notes |
|---|---|---|
| `property_code` | STRING | Property code. |
| `source_system` | STRING | Source system. |
| `roomtype_map` | STRING | Source room type value. |
| `roomtype_code_map` | STRING | Source room type code. |
| `roomtype` | STRING | Standard roomtype. |
| `roomtype_code` | STRING | Standard roomtype code. |
| `roomclass` | STRING | Standard room class. |
| `available_rms` | INT64 | Roomtype inventory, if known. |
| `is_active` | BOOL | Active flag. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### `map_source_metric`

| Column | Type | Notes |
|---|---|---|
| `source_report_id` | STRING | Source report identifier. |
| `source_system` | STRING | Source system. |
| `source_report` | STRING | Report name. |
| `source_column` | STRING | Raw source column name. |
| `standard_column` | STRING | Standard column name, if mapped to a wide fact field. |
| `metric_code` | STRING | Standard metric code. |
| `comparison` | STRING | cy, ly, stly, st2y, st3y, st4y, bgt, fct, act. |
| `pickup_window` | STRING | 007, 014, 030, 060, 090, etc. |
| `calc_method` | STRING | Source, derived, mapped. |
| `data_type` | STRING | Source data type. |
| `notes` | STRING | Mapping notes. |
| `insert_date` | DATE | Insert date. |

## Pace Fact Tables

### `fact_pace_property`

| Column | Type |
|---|---|
| `property_code` | STRING |
| `property_name` | STRING |
| `snap_date` | DATE |
| `date` | DATE |
| `special_events` | STRING |
| `special_events_ly` | STRING |
| `available_rms` | INT64 |
| `available_rms_ly` | INT64 |
| `rms_otb` | INT64 |
| `rev_otb` | FLOAT64 |
| `rms_ly` | INT64 |
| `rev_ly` | FLOAT64 |
| `rms_stly` | INT64 |
| `rev_stly` | FLOAT64 |
| `rms_st2y` | INT64 |
| `rev_st2y` | FLOAT64 |
| `rms_st3y` | INT64 |
| `rev_st3y` | FLOAT64 |
| `rms_st4y` | INT64 |
| `rev_st4y` | FLOAT64 |
| `rms_bgt` | INT64 |
| `rev_bgt` | FLOAT64 |
| `rms_fct` | INT64 |
| `rev_fct` | FLOAT64 |
| `adr_fct` | FLOAT64 |
| `ns_rms` | INT64 |
| `ns_rms_ly` | INT64 |
| `cx_rms` | INT64 |
| `cx_rms_ly` | INT64 |
| `demand_total` | INT64 |
| `demand_total_ly` | INT64 |
| `demand_group` | INT64 |
| `demand_group_ly` | INT64 |
| `demand_transient` | INT64 |
| `demand_transient_ly` | INT64 |
| `wash_pct` | FLOAT64 |
| `wash_pct_ly` | FLOAT64 |
| `lrv` | FLOAT64 |
| `bar_price` | FLOAT64 |
| `source_system` | STRING |
| `source_report` | STRING |
| `source_file` | STRING |
| `insert_date` | DATE |
| `updated_date` | DATE |

### `fact_pace_segment`

| Column | Type |
|---|---|
| `property_code` | STRING |
| `property_name` | STRING |
| `snap_date` | DATE |
| `date` | DATE |
| `segment` | STRING |
| `segment_code` | STRING |
| `segment_category` | STRING |
| `segment_map` | STRING |
| `segment_code_map` | STRING |
| `rms_otb` | INT64 |
| `rev_otb` | FLOAT64 |
| `rms_ly` | INT64 |
| `rev_ly` | FLOAT64 |
| `rms_stly` | INT64 |
| `rev_stly` | FLOAT64 |
| `rms_st2y` | INT64 |
| `rev_st2y` | FLOAT64 |
| `rms_st3y` | INT64 |
| `rev_st3y` | FLOAT64 |
| `rms_st4y` | INT64 |
| `rev_st4y` | FLOAT64 |
| `rms_bgt` | INT64 |
| `rev_bgt` | FLOAT64 |
| `rms_fct` | INT64 |
| `rev_fct` | FLOAT64 |
| `cx_rms` | INT64 |
| `cx_rms_ly` | INT64 |
| `ns_rms` | INT64 |
| `ns_rms_ly` | INT64 |
| `source_system` | STRING |
| `source_report` | STRING |
| `source_file` | STRING |
| `insert_date` | DATE |
| `updated_date` | DATE |

### `fact_pace_source`

| Column | Type |
|---|---|
| `property_code` | STRING |
| `property_name` | STRING |
| `snap_date` | DATE |
| `date` | DATE |
| `source` | STRING |
| `source_code` | STRING |
| `source_group` | STRING |
| `source_group_code` | STRING |
| `channel` | STRING |
| `channel_code` | STRING |
| `source_map` | STRING |
| `source_code_map` | STRING |
| `rms_otb` | INT64 |
| `rev_otb` | FLOAT64 |
| `rms_ly` | INT64 |
| `rev_ly` | FLOAT64 |
| `rms_stly` | INT64 |
| `rev_stly` | FLOAT64 |
| `rms_st2y` | INT64 |
| `rev_st2y` | FLOAT64 |
| `rms_st3y` | INT64 |
| `rev_st3y` | FLOAT64 |
| `rms_st4y` | INT64 |
| `rev_st4y` | FLOAT64 |
| `rms_fct` | INT64 |
| `rev_fct` | FLOAT64 |
| `cx_rms` | INT64 |
| `cx_rms_ly` | INT64 |
| `ns_rms` | INT64 |
| `ns_rms_ly` | INT64 |
| `source_system` | STRING |
| `source_report` | STRING |
| `source_file` | STRING |
| `insert_date` | DATE |
| `updated_date` | DATE |

### `fact_pace_roomtype`

| Column | Type |
|---|---|
| `property_code` | STRING |
| `property_name` | STRING |
| `snap_date` | DATE |
| `date` | DATE |
| `roomtype` | STRING |
| `roomtype_code` | STRING |
| `roomclass` | STRING |
| `roomtype_map` | STRING |
| `roomtype_code_map` | STRING |
| `available_rms` | INT64 |
| `rms_otb` | INT64 |
| `rev_otb` | FLOAT64 |
| `rms_ly` | INT64 |
| `rev_ly` | FLOAT64 |
| `rms_stly` | INT64 |
| `rev_stly` | FLOAT64 |
| `rms_st2y` | INT64 |
| `rev_st2y` | FLOAT64 |
| `rms_st3y` | INT64 |
| `rev_st3y` | FLOAT64 |
| `rms_st4y` | INT64 |
| `rev_st4y` | FLOAT64 |
| `rms_fct` | INT64 |
| `rev_fct` | FLOAT64 |
| `adr_fct` | FLOAT64 |
| `cx_rms` | INT64 |
| `cx_rms_ly` | INT64 |
| `ns_rms` | INT64 |
| `ns_rms_ly` | INT64 |
| `source_system` | STRING |
| `source_report` | STRING |
| `source_file` | STRING |
| `insert_date` | DATE |
| `updated_date` | DATE |

## Actual Fact Tables

Actual tables use the same dimensional grain as their matching pace tables but remove `snap_date` unless the actual source is itself snapshotted.

### Shared actual metric columns

| Column | Type |
|---|---|
| `rms` | INT64 |
| `rev` | FLOAT64 |
| `fb_rev` | FLOAT64 |
| `other_rev` | FLOAT64 |
| `total_rev` | FLOAT64 |
| `available_rms` | INT64 |
| `guest_count` | INT64 |
| `arrival_rms` | INT64 |
| `cx_rms` | INT64 |
| `ns_rms` | INT64 |
| `source_system` | STRING |
| `source_report` | STRING |
| `source_file` | STRING |
| `insert_date` | DATE |
| `updated_date` | DATE |

### `fact_actual_property`

| Column | Type |
|---|---|
| `property_code` | STRING |
| `property_name` | STRING |
| `date` | DATE |
| Shared actual metric columns | See shared list |

### `fact_actual_segment`

| Column | Type |
|---|---|
| `property_code` | STRING |
| `property_name` | STRING |
| `date` | DATE |
| `segment` | STRING |
| `segment_code` | STRING |
| `segment_category` | STRING |
| `segment_map` | STRING |
| `segment_code_map` | STRING |
| Shared actual metric columns | See shared list |

### `fact_actual_source`

| Column | Type |
|---|---|
| `property_code` | STRING |
| `property_name` | STRING |
| `date` | DATE |
| `source` | STRING |
| `source_code` | STRING |
| `channel` | STRING |
| `channel_code` | STRING |
| `source_map` | STRING |
| `source_code_map` | STRING |
| Shared actual metric columns | See shared list |

### `fact_actual_roomtype`

| Column | Type |
|---|---|
| `property_code` | STRING |
| `property_name` | STRING |
| `date` | DATE |
| `roomtype` | STRING |
| `roomtype_code` | STRING |
| `roomclass` | STRING |
| `roomtype_map` | STRING |
| `roomtype_code_map` | STRING |
| Shared actual metric columns | See shared list |

## Pickup Fact Tables

Pickup tables are long/narrow because pickup windows and comparison periods expand over time.

### Shared pickup metric columns

| Column | Type |
|---|---|
| `property_code` | STRING |
| `property_name` | STRING |
| `snap_date` | DATE |
| `date` | DATE |
| `comparison` | STRING |
| `pickup_window` | STRING |
| `rms_pickup` | INT64 |
| `rev_pickup` | FLOAT64 |
| `source_system` | STRING |
| `source_report` | STRING |
| `source_file` | STRING |
| `insert_date` | DATE |
| `updated_date` | DATE |

### `fact_pickup_property`

| Column | Type |
|---|---|
| Shared pickup metric columns | See shared list |

### `fact_pickup_segment`

| Column | Type |
|---|---|
| Shared pickup metric columns | See shared list |
| `segment` | STRING |
| `segment_code` | STRING |
| `segment_category` | STRING |
| `segment_map` | STRING |
| `segment_code_map` | STRING |

### `fact_pickup_source`

| Column | Type |
|---|---|
| Shared pickup metric columns | See shared list |
| `source` | STRING |
| `source_code` | STRING |
| `channel` | STRING |
| `channel_code` | STRING |
| `source_map` | STRING |
| `source_code_map` | STRING |

### `fact_pickup_roomtype`

| Column | Type |
|---|---|
| Shared pickup metric columns | See shared list |
| `roomtype` | STRING |
| `roomtype_code` | STRING |
| `roomclass` | STRING |
| `roomtype_map` | STRING |
| `roomtype_code_map` | STRING |

## Flexible/Sparse Metric Table

### `fact_metric_observation`

| Column | Type | Notes |
|---|---|---|
| `property_code` | STRING | Property code. |
| `date` | DATE | Metric date. |
| `snap_date` | DATE | Snapshot date, if applicable. |
| `grain_type` | STRING | Property, segment, source, roomtype, other. |
| `grain_key` | STRING | Combined grain key or source-specific grain value. |
| `metric_code` | STRING | Standard metric code. |
| `metric_value` | FLOAT64 | Metric value. |
| `metric_value_type` | STRING | Count, currency, percent, ratio, text. |
| `comparison` | STRING | cy, ly, stly, st2y, bgt, fct, act, etc. |
| `pickup_window` | STRING | 007, 014, 030, 060, 090, if applicable. |
| `calc_method` | STRING | Source, derived, mapped, manual. |
| `source_system` | STRING | Source system. |
| `source_report` | STRING | Source report. |
| `source_file` | STRING | Source file. |
| `insert_date` | DATE | Insert date. |

## BI Mart / Semantic Views

Marts should be dashboard-ready, derived from the fact tables, and may include calculated KPIs such as ADR, OCC, and RevPAR.

### Shared BI mart metrics

| Column | Type |
|---|---|
| `adr_otb` | FLOAT64 |
| `occ_otb` | FLOAT64 |
| `revpar_otb` | FLOAT64 |
| `adr_ly` | FLOAT64 |
| `occ_ly` | FLOAT64 |
| `revpar_ly` | FLOAT64 |
| `adr_bgt` | FLOAT64 |
| `occ_bgt` | FLOAT64 |
| `revpar_bgt` | FLOAT64 |
| `adr_fct` | FLOAT64 |
| `occ_fct` | FLOAT64 |
| `revpar_fct` | FLOAT64 |
| `rms_chg_ly` | INT64 |
| `rev_chg_ly` | FLOAT64 |
| `adr_chg_ly` | FLOAT64 |
| `rms_pct_chg_ly` | FLOAT64 |
| `rev_pct_chg_ly` | FLOAT64 |
| `adr_pct_chg_ly` | FLOAT64 |

### `mart_property_daily`

Derived from `fact_pace_property`, `fact_actual_property`, and property-level pickup facts.

### `mart_segment_daily`

Derived from `fact_pace_segment`, `fact_actual_segment`, and segment-level pickup facts.

### `mart_source_daily`

Derived from `fact_pace_source`, `fact_actual_source`, and source-level pickup facts.

### `mart_roomtype_daily`

Derived from `fact_pace_roomtype`, `fact_actual_roomtype`, and roomtype-level pickup facts.
