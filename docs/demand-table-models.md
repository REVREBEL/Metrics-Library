---
title: Demand Table Models
nav_order: 7
has_toc: true
permalink: /demand-table-models/
---

# Demand Table Models

Demand data should be modeled as its own table family because it contains market, compset, index, rank, and demand-change metrics that are different from PMS/RMS pace, actuals, pickup, event, manual planning, and price-shop data.

Demand tables are used to support market demand analysis, occupancy index review, ADR and RevPAR ranking, comp-set benchmarking, and demand variance tracking.

## Recommendation

Create three standardized demand fact tables:

```text
fact_demand_property
fact_demand_segment
fact_demand_source
```

The source table named `Demand Channel` should map to `fact_demand_source` to align with the broader REVREBEL standard that uses `source` / `source_code` / `channel` / `channel_code` for distribution-oriented cuts.

## Why demand should be separate

Demand data should not be forced into pace or actual fact tables because it includes:

1. Market and compset metrics.
2. Occupancy index and ranking.
3. ADR and RevPAR ranking.
4. Prior-year and prior-week comparisons.
5. Market-excluding-property metrics.
6. Demand fields that may not reconcile directly to PMS rooms or revenue.
7. Snapshot-based competitive demand observations.

## Naming Standard Notes

Apply the standard naming conventions:

| Source Pattern | Standard Pattern |
|---|---|
| `snapshot_date` | `snap_date` |
| `stay_date` or `date` | `date` |
| `room_nights` | `rms` when the value represents rooms / room nights sold |
| `compset` | `cs` |
| `prior_year` | `ly` |
| `prior_week` | `lw` |
| `chg` | change / variance |
| `pct_chg` | percent change |
| `market_excl` | market excluding the subject property |
| `booking_source` | `source` |
| `etl_date` | `insert_date` or `etl_date`, depending on whether it is a technical ETL timestamp to preserve |

## Table List

| Table | Purpose |
|---|---|
| `fact_demand_property` | Property-level demand, market, compset, index, and rank metrics. |
| `fact_demand_segment` | Segment-level demand, market, compset, index, and rank metrics. |
| `fact_demand_source` | Source/channel-level demand, market, compset, index, and rank metrics. |

---

## `fact_demand_property`

### Grain

Recommended grain:

```text
property_code + snap_date + date + market_segment + segment
```

If the property-level data is truly property-wide and `market_segment` / `segment` are always null or total values, the effective grain becomes:

```text
property_code + snap_date + date
```

### Standardized columns

| Source Field | Standard Field | Type | Notes |
|---|---|---|---|
| `market_segment` | `market_segment` | STRING | Market segment from the demand source. |
| `segment` | `segment` | STRING | Standard or source segment value, depending on mapping maturity. |
| `month` | `month` | DATE | Month value; use DATE normalized to first day of month where possible. |
| `stay_date` | `date` | DATE | Stay/date value for the demand observation. |
| `compset_rooms_sold` | `cs_rms_sold` | FLOAT64 | Compset rooms sold. |
| `occ_index` | `occ_index` | FLOAT64 | Property occupancy index versus compset/market. |
| `occ_rank` | `occ_rank` | STRING | Occupancy rank. Consider INT64 if source is numeric. |
| `property_adr` | `adr` | FLOAT64 | Property ADR. |
| `compset_adr` | `cs_adr` | FLOAT64 | Compset ADR. |
| `adr_rank` | `adr_rank` | STRING | ADR rank. Consider INT64 if source is numeric. |
| `revpar_rank` | `revpar_rank` | STRING | RevPAR rank. Consider INT64 if source is numeric. |
| `property_occ_yoy` | `occ_yoy` | FLOAT64 | Property occupancy YoY value/change as provided by source. |
| `compset_occ_yoy` | `cs_occ_yoy` | FLOAT64 | Compset occupancy YoY value/change as provided by source. |
| `occ_index_yoy` | `occ_index_yoy` | FLOAT64 | Occupancy index YoY value/change. |
| `property_adr_yoy` | `adr_yoy` | FLOAT64 | Property ADR YoY value/change. |
| `compset_adr_yoy` | `cs_adr_yoy` | FLOAT64 | Compset ADR YoY value/change. |
| `snapshot_date` | `snap_date` | DATE | Demand snapshot date. |
| `property_code` | `property_code` | STRING | Property code. |
| `etl_date` | `etl_date` | TIMESTAMP | ETL timestamp/date from source process. |

### Recommended additional metadata columns

| Column | Type | Notes |
|---|---|---|
| `source_system` | STRING | Source system or provider. |
| `source_report` | STRING | Source report/feed name. |
| `source_file` | STRING | Source file path or name. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

---

## `fact_demand_segment`

### Grain

Recommended grain:

```text
property_code + snap_date + date + market_segment + detail
```

`detail` should eventually be mapped into the standard segment model where possible.

### Standardized columns

| Source Field | Standard Field | Type | Notes |
|---|---|---|---|
| `month` | `month` | DATE | Month value; normalize to first day of month where possible. |
| `date` | `date` | DATE | Demand observation date / stay date. |
| `occ` | `occ` | FLOAT64 | Property occupancy. |
| `compset_occ` | `cs_occ` | FLOAT64 | Compset occupancy. |
| `occ_index` | `occ_index` | FLOAT64 | Property occupancy index versus compset/market. |
| `occ_rank` | `occ_rank` | STRING | Occupancy rank. Consider INT64 if source is numeric. |
| `occ_index_vs_prior_year_pct` | `occ_index_pct_chg_ly` | FLOAT64 | Occupancy index percent change versus prior year. |
| `occ_index_chg_vs_prior_week_pct` | `occ_index_pct_chg_lw` | FLOAT64 | Occupancy index percent change versus prior week. |
| `room_nights_current_my_hotel_totals` | `rms` | INT64 | Current property room nights / rooms sold. |
| `room_nights_chg_from_last_wk_my_hotel_totals` | `rms_chg_lw` | INT64 | Property room nights change versus last week. |
| `room_nights_var_pct_to_last_yr_my_hotel_totals` | `rms_pct_chg_ly` | FLOAT64 | Property room nights percent variance versus last year. |
| `room_nights_var_pct_to_last_yr_market_excl_totals` | `market_excl_rms_pct_chg_ly` | FLOAT64 | Market-excluding-property room nights percent variance versus last year. |
| `room_nights_chg_pct_from_last_wk_my_hotel_totals` | `rms_pct_chg_lw` | FLOAT64 | Property room nights percent change versus last week. |
| `room_nights_chg_pct_from_last_wk_market_excl_totals` | `market_excl_rms_pct_chg_lw` | FLOAT64 | Market-excluding-property room nights percent change versus last week. |
| `adr` | `adr` | FLOAT64 | Property ADR. |
| `adr_rank` | `adr_rank` | FLOAT64 | ADR rank. |
| `revpar` | `revpar` | FLOAT64 | Property RevPAR. |
| `revpar_rank` | `revpar_rank` | FLOAT64 | RevPAR rank. |
| `market_segment` | `market_segment` | STRING | Market segment from source. |
| `detail` | `segment_detail` | STRING | Source detail field; may map into `segment` / `segment_code`. |
| `compset_no` | `cs_no` | INT64 | Compset number/identifier. |
| `snapshot_date` | `snap_date` | DATE | Demand snapshot date. |
| `property_code` | `property_code` | STRING | Property code. |

### Recommended mapped segment columns

| Column | Type | Notes |
|---|---|---|
| `segment` | STRING | Standard segment, if mapped. |
| `segment_code` | STRING | Standard segment code, if mapped. |
| `segment_category` | STRING | Standard segment category, if mapped. |
| `segment_map` | STRING | Source segment/detail value. |
| `segment_code_map` | STRING | Source segment code, if available. |

### Recommended additional metadata columns

| Column | Type | Notes |
|---|---|---|
| `source_system` | STRING | Source system or provider. |
| `source_report` | STRING | Source report/feed name. |
| `source_file` | STRING | Source file path or name. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

---

## `fact_demand_source`

### Grain

Recommended grain:

```text
property_code + snap_date + date + source
```

### Standardized columns

| Source Field | Standard Field | Type | Notes |
|---|---|---|---|
| `month` | `month` | DATE | Month value; normalize to first day of month where possible. |
| `booking_source` | `source` | STRING | Booking source from source table. |
| `date` | `date` | DATE | Demand observation date / stay date. |
| `occ` | `occ` | FLOAT64 | Property occupancy. |
| `compset_occ` | `cs_occ` | FLOAT64 | Compset occupancy. |
| `occ_index` | `occ_index` | FLOAT64 | Property occupancy index versus compset/market. |
| `occ_rank` | `occ_rank` | STRING | Occupancy rank. Consider INT64 if source is numeric. |
| `occ_index_vs_prior_year_pct` | `occ_index_pct_chg_ly` | FLOAT64 | Occupancy index percent change versus prior year. |
| `occ_index_chg_vs_prior_week_pct` | `occ_index_pct_chg_lw` | FLOAT64 | Occupancy index percent change versus prior week. |
| `room_nights_current_my_hotel_totals` | `rms` | INT64 | Current property room nights / rooms sold. |
| `room_nights_var_pct_to_last_yr_my_hotel_totals` | `rms_pct_chg_ly` | FLOAT64 | Property room nights percent variance versus last year. |
| `room_nights_var_pct_to_last_yr_market_excl_totals` | `market_excl_rms_pct_chg_ly` | FLOAT64 | Market-excluding-property room nights percent variance versus last year. |
| `room_nights_chg_from_last_wk_my_hotel_totals` | `rms_chg_lw` | INT64 | Property room nights change versus last week. |
| `room_nights_chg_pct_from_last_wk_my_hotel_totals` | `rms_pct_chg_lw` | FLOAT64 | Property room nights percent change versus last week. |
| `room_nights_chg_pct_from_last_wk_market_excl_totals` | `market_excl_rms_pct_chg_lw` | FLOAT64 | Market-excluding-property room nights percent change versus last week. |
| `adr` | `adr` | FLOAT64 | Property ADR. |
| `adr_rank` | `adr_rank` | FLOAT64 | ADR rank. |
| `revpar` | `revpar` | FLOAT64 | Property RevPAR. |
| `revpar_rank` | `revpar_rank` | FLOAT64 | RevPAR rank. |
| `compset_no` | `cs_no` | INT64 | Compset number/identifier. |
| `snapshot_date` | `snap_date` | DATE | Demand snapshot date. |
| `property_code` | `property_code` | STRING | Property code. |

### Recommended mapped source/channel columns

| Column | Type | Notes |
|---|---|---|
| `source` | STRING | Standard source. |
| `source_code` | STRING | Standard source code, if mapped. |
| `source_group` | STRING | Standard source group, if mapped. |
| `source_group_code` | STRING | Standard source group code, if mapped. |
| `channel` | STRING | Standard channel. |
| `channel_code` | STRING | Standard channel code. |
| `source_map` | STRING | Source booking source value. |
| `source_code_map` | STRING | Source booking source code, if available. |

### Recommended additional metadata columns

| Column | Type | Notes |
|---|---|---|
| `source_system` | STRING | Source system or provider. |
| `source_report` | STRING | Source report/feed name. |
| `source_file` | STRING | Source file path or name. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

---

## BigQuery DDL

```sql
CREATE TABLE IF NOT EXISTS `PROJECT_ID.DATASET.fact_demand_property` (
  property_code STRING OPTIONS(description="Property code."),
  snap_date DATE OPTIONS(description="Demand snapshot date."),
  date DATE OPTIONS(description="Stay/date value for the demand observation."),
  month DATE OPTIONS(description="Month value normalized to the first day of month where possible."),
  market_segment STRING OPTIONS(description="Market segment from the demand source."),
  segment STRING OPTIONS(description="Standard or source segment value, depending on mapping maturity."),
  cs_rms_sold FLOAT64 OPTIONS(description="Compset rooms sold."),
  occ_index FLOAT64 OPTIONS(description="Property occupancy index versus compset or market."),
  occ_rank STRING OPTIONS(description="Occupancy rank."),
  adr FLOAT64 OPTIONS(description="Property average daily rate."),
  cs_adr FLOAT64 OPTIONS(description="Compset average daily rate."),
  adr_rank STRING OPTIONS(description="ADR rank."),
  revpar_rank STRING OPTIONS(description="RevPAR rank."),
  occ_yoy FLOAT64 OPTIONS(description="Property occupancy year-over-year value or change as provided by the source."),
  cs_occ_yoy FLOAT64 OPTIONS(description="Compset occupancy year-over-year value or change as provided by the source."),
  occ_index_yoy FLOAT64 OPTIONS(description="Occupancy index year-over-year value or change."),
  adr_yoy FLOAT64 OPTIONS(description="Property ADR year-over-year value or change."),
  cs_adr_yoy FLOAT64 OPTIONS(description="Compset ADR year-over-year value or change."),
  etl_date TIMESTAMP OPTIONS(description="ETL timestamp/date from source process."),
  source_system STRING OPTIONS(description="Source system or provider."),
  source_report STRING OPTIONS(description="Source report or feed name."),
  source_file STRING OPTIONS(description="Source file path or name."),
  insert_date DATE OPTIONS(description="Insert date."),
  updated_date DATE OPTIONS(description="Updated date.")
)
OPTIONS(description="Property-level demand, compset, index, and rank metrics.");

CREATE TABLE IF NOT EXISTS `PROJECT_ID.DATASET.fact_demand_segment` (
  property_code STRING OPTIONS(description="Property code."),
  snap_date DATE OPTIONS(description="Demand snapshot date."),
  date DATE OPTIONS(description="Demand observation date or stay date."),
  month DATE OPTIONS(description="Month value normalized to the first day of month where possible."),
  market_segment STRING OPTIONS(description="Market segment from source."),
  segment STRING OPTIONS(description="Standard segment, if mapped."),
  segment_code STRING OPTIONS(description="Standard segment code, if mapped."),
  segment_category STRING OPTIONS(description="Standard segment category, if mapped."),
  segment_detail STRING OPTIONS(description="Source detail field from demand source."),
  segment_map STRING OPTIONS(description="Source segment/detail value."),
  segment_code_map STRING OPTIONS(description="Source segment code, if available."),
  cs_no INT64 OPTIONS(description="Compset number or identifier."),
  occ FLOAT64 OPTIONS(description="Property occupancy."),
  cs_occ FLOAT64 OPTIONS(description="Compset occupancy."),
  occ_index FLOAT64 OPTIONS(description="Property occupancy index versus compset or market."),
  occ_rank STRING OPTIONS(description="Occupancy rank."),
  occ_index_pct_chg_ly FLOAT64 OPTIONS(description="Occupancy index percent change versus prior year."),
  occ_index_pct_chg_lw FLOAT64 OPTIONS(description="Occupancy index percent change versus last week."),
  rms INT64 OPTIONS(description="Current property room nights / rooms sold."),
  rms_chg_lw INT64 OPTIONS(description="Property room nights change versus last week."),
  rms_pct_chg_ly FLOAT64 OPTIONS(description="Property room nights percent variance versus last year."),
  market_excl_rms_pct_chg_ly FLOAT64 OPTIONS(description="Market-excluding-property room nights percent variance versus last year."),
  rms_pct_chg_lw FLOAT64 OPTIONS(description="Property room nights percent change versus last week."),
  market_excl_rms_pct_chg_lw FLOAT64 OPTIONS(description="Market-excluding-property room nights percent change versus last week."),
  adr FLOAT64 OPTIONS(description="Property ADR."),
  adr_rank FLOAT64 OPTIONS(description="ADR rank."),
  revpar FLOAT64 OPTIONS(description="Property RevPAR."),
  revpar_rank FLOAT64 OPTIONS(description="RevPAR rank."),
  source_system STRING OPTIONS(description="Source system or provider."),
  source_report STRING OPTIONS(description="Source report or feed name."),
  source_file STRING OPTIONS(description="Source file path or name."),
  insert_date DATE OPTIONS(description="Insert date."),
  updated_date DATE OPTIONS(description="Updated date.")
)
OPTIONS(description="Segment-level demand, compset, index, rank, and room-night variance metrics.");

CREATE TABLE IF NOT EXISTS `PROJECT_ID.DATASET.fact_demand_source` (
  property_code STRING OPTIONS(description="Property code."),
  snap_date DATE OPTIONS(description="Demand snapshot date."),
  date DATE OPTIONS(description="Demand observation date or stay date."),
  month DATE OPTIONS(description="Month value normalized to the first day of month where possible."),
  source STRING OPTIONS(description="Standard source."),
  source_code STRING OPTIONS(description="Standard source code, if mapped."),
  source_group STRING OPTIONS(description="Standard source group, if mapped."),
  source_group_code STRING OPTIONS(description="Standard source group code, if mapped."),
  channel STRING OPTIONS(description="Standard channel."),
  channel_code STRING OPTIONS(description="Standard channel code."),
  source_map STRING OPTIONS(description="Source booking source value."),
  source_code_map STRING OPTIONS(description="Source booking source code, if available."),
  cs_no INT64 OPTIONS(description="Compset number or identifier."),
  occ FLOAT64 OPTIONS(description="Property occupancy."),
  cs_occ FLOAT64 OPTIONS(description="Compset occupancy."),
  occ_index FLOAT64 OPTIONS(description="Property occupancy index versus compset or market."),
  occ_rank STRING OPTIONS(description="Occupancy rank."),
  occ_index_pct_chg_ly FLOAT64 OPTIONS(description="Occupancy index percent change versus prior year."),
  occ_index_pct_chg_lw FLOAT64 OPTIONS(description="Occupancy index percent change versus last week."),
  rms INT64 OPTIONS(description="Current property room nights / rooms sold."),
  rms_chg_lw INT64 OPTIONS(description="Property room nights change versus last week."),
  rms_pct_chg_ly FLOAT64 OPTIONS(description="Property room nights percent variance versus last year."),
  market_excl_rms_pct_chg_ly FLOAT64 OPTIONS(description="Market-excluding-property room nights percent variance versus last year."),
  rms_pct_chg_lw FLOAT64 OPTIONS(description="Property room nights percent change versus last week."),
  market_excl_rms_pct_chg_lw FLOAT64 OPTIONS(description="Market-excluding-property room nights percent change versus last week."),
  adr FLOAT64 OPTIONS(description="Property ADR."),
  adr_rank FLOAT64 OPTIONS(description="ADR rank."),
  revpar FLOAT64 OPTIONS(description="Property RevPAR."),
  revpar_rank FLOAT64 OPTIONS(description="RevPAR rank."),
  source_system STRING OPTIONS(description="Source system or provider."),
  source_report STRING OPTIONS(description="Source report or feed name."),
  source_file STRING OPTIONS(description="Source file path or name."),
  insert_date DATE OPTIONS(description="Insert date."),
  updated_date DATE OPTIONS(description="Updated date.")
)
OPTIONS(description="Source/channel-level demand, compset, index, rank, and room-night variance metrics.");
```

## Relationship to Other Tables

Demand joins to property, event, price, and pace tables by:

```text
property_code + date
```

Demand segment joins by:

```text
property_code + date + segment / segment_code
```

Demand source joins by:

```text
property_code + date + source / source_code / channel
```

Recommended mart views:

```text
mart_demand_property_daily
mart_demand_segment_daily
mart_demand_source_daily
```

## Notes

1. Rank fields are currently typed as STRING in some source schemas and FLOAT in others. If the source values are consistently numeric, standardize to INT64. Until then, preserve the source-compatible type and cast in marts/views.
2. `month` should be standardized as DATE, not STRING or DATETIME, where possible. Use the first day of the month.
3. `snapshot_date` should standardize to `snap_date`.
4. Demand Channel should map to `fact_demand_source`, not `fact_demand_channel`, to align with the broader REVREBEL naming model.
5. `market_excl` means market excluding the subject property.
