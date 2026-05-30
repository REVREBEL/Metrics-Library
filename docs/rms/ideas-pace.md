---
title: IDeaS Pace
has_toc: true
permalink: /source-files/ideas-pace/
---

# IDeaS Pace

The IDeaS Pace source file family standardizes IDeaS PaceData workbook tabs into REVREBEL pace facts for property, segment, room class, and room type reporting.

## Source System Overview

| Field | Value |
|---|---|
| Source system | `IDeaS` |
| Source family | PaceData workbook |
| Business purpose | Pace, pickup, forecast, budget, demand, room type, room class, and segment reporting |
| Ingestion utility | `notebooks/utilities/ideas_pace_sheet_config.py` |
| Column standardizer | `notebooks/utilities/revrebel_column_standardizer.py` |
| Standard output pattern | `fact_pace_*` tables / BigQuery-ready standardized files |

## Raw Workbook Tabs

The active BI ingestion tabs are configured in `IDEAS_PACE_SHEET_CONFIGS`.

| Raw workbook tab | Source report | Final target table | BI grain | Status |
|---|---|---|---|---|
| Property | `snap_property` | `fact_pace_property` | Property by stay date / snapshot date | Active |
| Room Type | `snap_pace_roomtype` | `fact_pace_roomtype` | Room type by stay date / snapshot date | Active |
| Room Class | `snap_pace_roomclass` | `fact_pace_roomclass` | Room class by stay date / snapshot date | Active |
| Business View | `snap_pace_segment` | `fact_pace_segment` | Segment by stay date / snapshot date | Active |

## Retained But Excluded Tabs

These tabs may be retained for audit, mapping, or RMS troubleshooting, but should not feed standard BI facts unless a specific use case requires them.

| Raw workbook tab | Source report | Default target | Reason |
|---|---|---|---|
| Market Segment | `snap_pace_segment_raw_market_segment` | `fact_metric_observation` | Raw system codes before IDeaS grouping / cleanup. Use Business View for standardized BI segment reporting. |
| Forecast Group | `snap_pace_forecast_group` | `fact_metric_observation` | RMS internal forecast grain. Use only for RMS troubleshooting, forecast audit, or model diagnostics. |

## IDeaS Export Configuration

Inside IDeaS, the PaceData export should be configured to produce a workbook that includes the active BI tabs listed above.

| Configuration Area | Required Direction |
|---|---|
| Date scope | Export the full pace window required by the reporting workflow. |
| Snapshot date | Preserve the report generation / snapshot date as `snap_date` during processing. |
| Stay date | Preserve the occupancy / business date as `stay_date`. |
| Tabs | Include Property, Room Type, Room Class, and Business View. |
| Segment reporting | Use Business View as the standardized segment layer. |
| Room hierarchy | Treat Room Class as `roomclass`; treat Room Type as `roomtype`. |
| Exclusions | Do not use Market Segment or Forecast Group for standard BI facts unless the use case is explicitly diagnostic. |

## Raw Column Mapping

The standardizer first normalizes source headers to safe snake case, then maps known source columns to REVREBEL standard names.

### Common Date and Property Columns

| Original / normalized source column | Standard column |
|---|---|
| `date`, `day`, `staydate`, `occupancy_date`, `business_date`, `service_date` | `stay_date` |
| `snapshot_date`, `snap_date` | `snap_date` |
| `comparison_date_last_year`, `comparison_date_ly` | `comparison_date_ly` |
| `hotel`, `hotel_name`, `property` | `property_name` |
| `property_id`, `property_code` | `property_code` |

### Rooms, Occupancy, and Capacity

| Original / normalized source column | Standard column |
|---|---|
| `rooms`, `room_nights`, `room_nights_sold`, `rooms_sold` | `rms` |
| `available_rooms`, `physical_capacity`, `capacity_this_year` | `available_rms` |
| `available_rooms_ly`, `physical_capacity_last_year_actual`, `capacity_last_year_actual` | `available_rms_ly` |
| `remaining_capacity_this_year` | `remaining_rms` |
| `remaining_capacity_last_year_actual` | `remaining_rms_ly` |
| `occupancy_on_books_this_year`, `rooms_otb`, `rooms_on_the_books` | `rms_otb` |
| `occupancy_on_books_last_year_actual`, `rooms_ly_actual` | `rms_ly` |
| `occupancy_on_books_stly`, `rooms_stly` | `rms_stly` |
| `occupancy_on_books_st2y`, `rooms_st2y` | `rms_st2y` |

### Revenue, Forecast, Budget, and Rate Metrics

| Original / normalized source column | Standard column |
|---|---|
| `revenue`, `room_revenue` | `rev` |
| `booked_room_revenue_this_year`, `revenue_otb`, `rev_otb` | `rev_otb` |
| `booked_room_revenue_last_year_actual`, `rev_ly_actual` | `rev_ly` |
| `booked_room_revenue_stly`, `rev_stly` | `rev_stly` |
| `booked_room_revenue_st2y`, `rev_st2y` | `rev_st2y` |
| `rooms_forecast`, `occupancy_forecast_this_year`, `occupancy_forecast_total_this_year` | `rms_fct` |
| `forecasted_room_revenue_this_year`, `rev_forecast` | `rev_fct` |
| `rooms_budget`, `budget_occupancy_total_this_year` | `rms_bgt` |
| `budget_room_revenue_this_year`, `budget_revenue_this_year`, `rev_budget` | `rev_bgt` |
| `adr_on_books_this_year` | `adr_otb` |
| `revpar_on_books_this_year` | `revpar_otb` |
| `bar`, `bar_this_year` | `bar_price` |

### Segment, Room Class, and Room Type

| Original / normalized source column | Standard column |
|---|---|
| `business_view` | `segment` |
| `forecast_group` | `segment` when used diagnostically |
| `market_code` | `segment_code` |
| `detail` | `segment_detail` |
| `room_type`, `roomtype` | `roomtype` |
| `room_type_code` | `roomtype_code` |
| `room_class`, `roomclass` | `roomclass` |
| `room_class_code` | `roomclass_code` |
| `bed_type` | `bedtype` |
| `room_pool` | `roompool` |

## New / Amended Data

The processing utilities add or amend the following columns during standardization and alignment.

| Column / Logic | Applies To | Purpose |
|---|---|---|
| `source_system` | All active tabs | Preserves source system lineage, normally `IDeaS`. |
| `source_report` | All active tabs | Preserves the normalized report / tab family. |
| `source_file` | All active tabs | Preserves original workbook or file name. |
| `load_ts` | All active tabs | Adds UTC load timestamp. |
| `insert_date` | All active tabs | Adds row insert date. |
| `updated_date` | All active tabs | Adds row update date. |
| `segment_map`, `segment_code_map` | Segment | Lookup placeholders for standardized segment enrichment. |
| `roomclass_map`, `roomclass_code_map` | Room Class | Lookup placeholders for standardized room class enrichment. |
| `roomtype_map`, `roomtype_code_map` | Room Type | Lookup placeholders for standardized room type enrichment. |
| `demand_total`, `demand_group`, `demand_transient` | Property | Derived from system demand fields when generic property demand fields are missing. |
| `day_of_week` | All pace grains | Dropped during final alignment when present. |

## Final Transformed Specs

### Property Output: `fact_pace_property`

| Column Group | Columns |
|---|---|
| Keys / dates | `property_code`, `property_name`, `snap_date`, `stay_date`, `comparison_date_ly` |
| Capacity / rooms | `available_rms`, `available_rms_ly`, `remaining_rms`, `remaining_rms_ly`, `rms_otb`, `rms_ly`, `rms_stly`, `rms_st2y` |
| Revenue | `rev_otb`, `rev_ly`, `rev_stly`, `rev_st2y`, `rev_bgt`, `rev_fct` |
| Forecast / budget | `rms_bgt`, `rms_fct`, `adr_fct`, `property_rms_fct`, `property_rms_fct_ly`, `property_rev_fct`, `property_rev_fct_ly` |
| Group / transient | `group_rms_otb`, `group_rms_ly`, `group_rms_stly`, `group_rms_st2y`, `transient_rms_otb`, `transient_rms_ly`, `transient_rms_stly`, `transient_rms_st2y` |
| Demand | `demand_total`, `demand_total_ly`, `demand_group`, `demand_group_ly`, `demand_transient`, `demand_transient_ly`, `system_demand_*`, `user_demand_*` |
| Operational | `arrival_rms`, `departure_rms`, `cx_rms`, `ns_rms`, `ooo_rms`, `na_other_rms`, `overbook_rms` and LY variants |
| Rate metrics | `adr_otb`, `adr_ly`, `adr_fct_ly`, `revpar_otb`, `revpar_ly`, `revpar_fct`, `revpar_fct_ly`, `lrv`, `wash_pct`, `bar_price` and LY variants |
| Event / lineage | `primary_event`, `primary_event_ly`, `source_system`, `source_report`, `source_file`, `load_ts`, `insert_date`, `updated_date` |

### Segment Output: `fact_pace_segment`

| Column Group | Columns |
|---|---|
| Keys / dates | `property_code`, `property_name`, `snap_date`, `stay_date`, `comparison_date_ly` |
| Segment | `segment`, `segment_code`, `segment_group`, `segment_group_code`, `finance_segment`, `finance_segment_code`, `segment_category`, `rate_basis`, `segment_map`, `segment_code_map` |
| Metrics | `available_rms`, `rms_otb`, `rev_otb`, `rms_ly`, `rev_ly`, `rms_stly`, `rev_stly`, `rms_st2y`, `rev_st2y`, `rms_bgt`, `rev_bgt`, `rms_fct`, `rev_fct`, `adr_fct`, `cx_rms`, `cx_rms_ly`, `ns_rms`, `ns_rms_ly` |
| Lineage | `source_system`, `source_report`, `source_file`, `load_ts`, `insert_date`, `updated_date` |

### Room Class Output: `fact_pace_roomclass`

| Column Group | Columns |
|---|---|
| Keys / dates | `property_code`, `property_name`, `snap_date`, `stay_date`, `comparison_date_ly` |
| Room class | `roomclass`, `roomclass_code`, `roomclass_map`, `roomclass_code_map` |
| Metrics | `available_rms`, `rms_otb`, `rev_otb`, `rms_ly`, `rev_ly`, `rms_stly`, `rev_stly`, `rms_st2y`, `rev_st2y`, `rms_bgt`, `rev_bgt`, `rms_fct`, `rev_fct`, `adr_fct`, `system_unconstrained_demand`, `system_unconstrained_demand_ly`, `user_demand`, `user_demand_ly`, `system_wash_pct`, `system_wash_pct_ly`, `user_wash_pct`, `user_wash_pct_ly`, `cx_rms`, `cx_rms_ly`, `ns_rms`, `ns_rms_ly` |
| Lineage | `source_system`, `source_report`, `source_file`, `load_ts`, `insert_date`, `updated_date` |

### Room Type Output: `fact_pace_roomtype`

| Column Group | Columns |
|---|---|
| Keys / dates | `property_code`, `property_name`, `snap_date`, `stay_date`, `comparison_date_ly` |
| Room type | `roomtype`, `roomtype_code`, `roomtype_map`, `roomtype_code_map` |
| Hierarchy | `roomclass`, `roomclass_code`, `bedtype`, `bedtype_code`, `roomfeature`, `roompool`, `roompool_code` |
| Metrics | `available_rms`, `rms_otb`, `rev_otb`, `rms_ly`, `rev_ly`, `rms_stly`, `rev_stly`, `rms_st2y`, `rev_st2y`, `rms_bgt`, `rev_bgt`, `rms_fct`, `rev_fct`, `adr_fct`, `cx_rms`, `cx_rms_ly`, `ns_rms`, `ns_rms_ly` |
| Lineage | `source_system`, `source_report`, `source_file`, `load_ts`, `insert_date`, `updated_date` |

## Agent-Readable Contract

```yaml
source_system: IDeaS
source_family: PaceData workbook
active_tabs:
  Property:
    source_report: snap_property
    target_table: fact_pace_property
    grain: property
  Room Type:
    source_report: snap_pace_roomtype
    target_table: fact_pace_roomtype
    grain: roomtype
  Room Class:
    source_report: snap_pace_roomclass
    target_table: fact_pace_roomclass
    grain: roomclass
  Business View:
    source_report: snap_pace_segment
    target_table: fact_pace_segment
    grain: segment
excluded_tabs:
  Market Segment: use only for raw audit or troubleshooting
  Forecast Group: use only for RMS diagnostics
standardization_flow:
  - normalize raw headers to snake_case
  - map known headers to REVREBEL standard names
  - add ingestion metadata
  - add lookup placeholder columns
  - derive property demand fields when needed
  - align output to pace grain column spec
lineage_columns:
  - source_system
  - source_report
  - source_file
  - load_ts
  - insert_date
  - updated_date
```
