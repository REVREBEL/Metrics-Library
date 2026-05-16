---
title: Demand Table Models
nav_order: 7
has_toc: true
permalink: /demand-table-models/
---

# Demand Table Models

Demand data has its own table family because it does not behave like PMS actuals, RMS pace, pickup, manual planning, event, or price-shop data. It is a market signal layer. It tells us how the hotel is positioned against the market, not just what the hotel produced.

The demand model supports market demand analysis, occupancy index review, ADR and RevPAR rank tracking, comp-set benchmarking, market-excluding-property comparisons, and demand variance analysis.

## How We View Demand Data

We intentionally separate demand data from pace and actual performance datasets because demand behaves differently — and forcing it into operational fact tables creates more confusion than clarity.

Demand data is observational by nature. It includes market and compset intelligence, occupancy indexing, ADR and RevPAR rankings, prior-period comparisons, and market-level performance metrics that don’t always reconcile directly to PMS revenue or room-night production. It also captures snapshot-based competitive positioning data that reflects market movement at a specific point in time.

By structuring demand as its own dataset, we preserve the integrity of operational reporting while creating a cleaner framework for forecasting, benchmarking, and strategic analysis. It allows us to evaluate not just how the hotel performed — but how the market behaved around it.

## Demand Table Family

Demand is stored in three standardized snapshot tables:

```text
snap_demand_property
snap_demand_segment
snap_demand_source
```

The source report often named `Demand Channel` maps to `snap_demand_source`. In the REVREBEL model, `source` represents the distribution-oriented view of demand, while `channel` remains available as a standardized grouping when the data supports it.

## Naming Standard Notes

Demand tables follow the same column naming standards as the rest of the Metrics Library.

| Source Pattern | Standard Pattern | Usage |
|---|---|---|
| `snapshot_date` | `snap_date` | Point-in-time date when the demand observation was captured. |
| `stay_date` or source `date` | `stay_date` | Hotel stay / occupancy / service date. |
| `room_nights` | `rms` | Room nights or rooms sold. |
| `compset` | `cs` | Competitive set. Short, readable, and mercifully not thirty characters long. |
| `prior_year` | `ly` | Prior-year comparison. |
| `prior_week` | `lw` | Prior-week comparison. |
| `chg` | `chg` | Absolute change / variance. |
| `pct_chg` | `pct_chg` | Percent change. |
| `market_excl` | `market_excl` | Market excluding the subject property. |
| `booking_source` | `source` | Source-oriented distribution cut. |
| `etl_date` | `etl_date` | Technical ETL timestamp when it needs to be preserved from the source. |

## Table List

| Table | Purpose |
|---|---|
| `snap_demand_property` | Property-level demand, market, compset, index, and rank metrics. |
| `snap_demand_segment` | Segment-level demand, market, compset, index, rank, and variance metrics. |
| `snap_demand_source` | Source/channel-level demand, market, compset, index, rank, and variance metrics. |

---

## `snap_demand_property`

### Grain

The property demand table is keyed at:

```text
property_code + snap_date + stay_date + market_segment + segment
```

When the source data is truly property-wide and `market_segment` or `segment` are null, total, or not supplied, the effective grain becomes:

```text
property_code + snap_date + stay_date
```

### Standardized Columns

| Source Field | Standard Field | Type | Notes |
|---|---|---|---|
| `market_segment` | `market_segment` | STRING | Market segment from the demand source. |
| `segment` | `segment` | STRING | Standard or source segment value, depending on mapping maturity. |
| `month` | `month` | DATE | Month value normalized to the first day of month. |
| `stay_date`, `date` | `stay_date` | DATE | Stay date for the demand observation. |
| `compset_rooms_sold` | `cs_rms_sold` | FLOAT64 | Competitive-set rooms sold. |
| `occ_index` | `occ_index` | FLOAT64 | Property occupancy index versus compset or market. |
| `occ_rank` | `occ_rank` | STRING | Occupancy rank. Cast in views if the source is consistently numeric. |
| `property_adr` | `adr` | FLOAT64 | Property ADR. |
| `compset_adr` | `cs_adr` | FLOAT64 | Competitive-set ADR. |
| `adr_rank` | `adr_rank` | STRING | ADR rank. Cast in views if the source is consistently numeric. |
| `revpar_rank` | `revpar_rank` | STRING | RevPAR rank. Cast in views if the source is consistently numeric. |
| `property_occ_yoy` | `occ_yoy` | FLOAT64 | Property occupancy year-over-year value or change as provided by source. |
| `compset_occ_yoy` | `cs_occ_yoy` | FLOAT64 | Competitive-set occupancy year-over-year value or change as provided by source. |
| `occ_index_yoy` | `occ_index_yoy` | FLOAT64 | Occupancy index year-over-year value or change. |
| `property_adr_yoy` | `adr_yoy` | FLOAT64 | Property ADR year-over-year value or change. |
| `compset_adr_yoy` | `cs_adr_yoy` | FLOAT64 | Competitive-set ADR year-over-year value or change. |
| `snapshot_date` | `snap_date` | DATE | Demand snapshot date. |
| `property_code` | `property_code` | STRING | Property code. |
| `etl_date` | `etl_date` | TIMESTAMP | Technical ETL timestamp from the source process. |

### Metadata Columns

| Column | Type | Notes |
|---|---|---|
| `source_system` | STRING | Source system or provider. |
| `source_report` | STRING | Source report or feed name. |
| `source_file` | STRING | Source file path or name. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

---

## `snap_demand_segment`

### Grain

The segment demand table is keyed at:

```text
property_code + snap_date + stay_date + market_segment + segment_detail
```

`segment_detail` preserves the source detail field. Where mapping exists, it resolves into the standard segment model using `segment`, `segment_code`, and related segment attributes.

### Standardized Columns

| Source Field | Standard Field | Type | Notes |
|---|---|---|---|
| `month` | `month` | DATE | Month value normalized to the first day of month. |
| `date`, `stay_date` | `stay_date` | DATE | Demand observation date / stay date. |
| `occ` | `occ` | FLOAT64 | Property occupancy. |
| `compset_occ` | `cs_occ` | FLOAT64 | Competitive-set occupancy. |
| `occ_index` | `occ_index` | FLOAT64 | Property occupancy index versus compset or market. |
| `occ_rank` | `occ_rank` | STRING | Occupancy rank. Cast in views if the source is consistently numeric. |
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
| `detail` | `segment_detail` | STRING | Source detail field. |
| `compset_no` | `cs_no` | INT64 | Competitive-set number or identifier. |
| `snapshot_date` | `snap_date` | DATE | Demand snapshot date. |
| `property_code` | `property_code` | STRING | Property code. |

### Segment Mapping Columns

| Column | Type | Notes |
|---|---|---|
| `segment` | STRING | Standard segment, when mapped. |
| `segment_code` | STRING | Standard segment code, when mapped. |
| `segment_category` | STRING | Standard segment category, when mapped. |
| `segment_map` | STRING | Source segment/detail value. |
| `segment_code_map` | STRING | Source segment code, when supplied. |

### Metadata Columns

| Column | Type | Notes |
|---|---|---|
| `source_system` | STRING | Source system or provider. |
| `source_report` | STRING | Source report or feed name. |
| `source_file` | STRING | Source file path or name. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

---

## `snap_demand_source`

### Grain

The source demand table is keyed at:

```text
property_code + snap_date + stay_date + source
```

Source values can be mapped into the broader source/channel model as the library matures.

### Standardized Columns

| Source Field | Standard Field | Type | Notes |
|---|---|---|---|
| `month` | `month` | DATE | Month value normalized to the first day of month. |
| `booking_source` | `source` | STRING | Booking source from the source table. |
| `date`, `stay_date` | `stay_date` | DATE | Demand observation date / stay date. |
| `occ` | `occ` | FLOAT64 | Property occupancy. |
| `compset_occ` | `cs_occ` | FLOAT64 | Competitive-set occupancy. |
| `occ_index` | `occ_index` | FLOAT64 | Property occupancy index versus compset or market. |
| `occ_rank` | `occ_rank` | STRING | Occupancy rank. Cast in views if the source is consistently numeric. |
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
| `compset_no` | `cs_no` | INT64 | Competitive-set number or identifier. |
| `snapshot_date` | `snap_date` | DATE | Demand snapshot date. |
| `property_code` | `property_code` | STRING | Property code. |

### Source and Channel Mapping Columns

| Column | Type | Notes |
|---|---|---|
| `source` | STRING | Standard source. |
| `source_code` | STRING | Standard source code, when mapped. |
| `source_group` | STRING | Standard source group, when mapped. |
| `source_group_code` | STRING | Standard source group code, when mapped. |
| `channel` | STRING | Standard channel. |
| `channel_code` | STRING | Standard channel code. |
| `source_map` | STRING | Source booking source value. |
| `source_code_map` | STRING | Source booking source code, when supplied. |

### Metadata Columns

| Column | Type | Notes |
|---|---|---|
| `source_system` | STRING | Source system or provider. |
| `source_report` | STRING | Source report or feed name. |
| `source_file` | STRING | Source file path or name. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

---

## BigQuery DDL Pattern

The Dataform implementation creates these tables in the demand dataset using the same naming logic:

```text
metrics_demand.snap_demand_property
metrics_demand.snap_demand_segment
metrics_demand.snap_demand_source
```

Example pattern:

```sql
CREATE TABLE IF NOT EXISTS `PROJECT_ID.metrics_demand.snap_demand_property` (
  property_code STRING OPTIONS(description="Property code."),
  snap_date DATE OPTIONS(description="Demand snapshot date."),
  stay_date DATE OPTIONS(description="Stay date for the demand observation."),
  month DATE OPTIONS(description="Month value normalized to the first day of month."),
  market_segment STRING OPTIONS(description="Market segment from the demand source."),
  segment STRING OPTIONS(description="Standard or source segment value, depending on mapping maturity."),
  cs_no STRING OPTIONS(description="Competitive set number or identifier."),
  cs_rms_sold FLOAT64 OPTIONS(description="Competitive-set rooms sold."),
  occ_index FLOAT64 OPTIONS(description="Property occupancy index versus compset or market."),
  occ_rank STRING OPTIONS(description="Occupancy rank."),
  adr FLOAT64 OPTIONS(description="Property ADR."),
  cs_adr FLOAT64 OPTIONS(description="Competitive-set ADR."),
  adr_rank STRING OPTIONS(description="ADR rank."),
  revpar_rank STRING OPTIONS(description="RevPAR rank."),
  occ_yoy FLOAT64 OPTIONS(description="Property occupancy year-over-year value or change as provided by the source."),
  cs_occ_yoy FLOAT64 OPTIONS(description="Competitive-set occupancy year-over-year value or change as provided by the source."),
  occ_index_yoy FLOAT64 OPTIONS(description="Occupancy index year-over-year value or change."),
  adr_yoy FLOAT64 OPTIONS(description="Property ADR year-over-year value or change."),
  cs_adr_yoy FLOAT64 OPTIONS(description="Competitive-set ADR year-over-year value or change."),
  etl_date TIMESTAMP OPTIONS(description="ETL timestamp/date from source process."),
  source_system STRING OPTIONS(description="Source system or provider."),
  source_report STRING OPTIONS(description="Source report or feed name."),
  source_file STRING OPTIONS(description="Source file path or name."),
  insert_date DATE OPTIONS(description="Insert date."),
  updated_date DATE OPTIONS(description="Updated date.")
)
PARTITION BY snap_date
CLUSTER BY property_code, stay_date
OPTIONS(description="Property-level demand, compset, index, and rank metrics.");
```

## Relationship to Other Tables

Demand connects to property, event, price, and pace data by:

```text
property_code + stay_date
```

Demand segment connects by:

```text
property_code + stay_date + segment / segment_code
```

Demand source connects by:

```text
property_code + stay_date + source / source_code / channel
```

BI-facing demand views use the `vw_` prefix:

```text
vw_demand_property
vw_demand_segment
vw_demand_source
```

## Operating Notes

1. Rank fields arrive as strings in some sources and numbers in others. Preserve the source-compatible type in snapshot tables and cast in BI views when the values are consistently numeric.
2. `month` is stored as a DATE using the first day of the month. This avoids the slow-motion chaos of mixing strings, datetimes, and calendar labels.
3. `snapshot_date` standardizes to `snap_date`.
4. `date` or `stay_date` standardizes to `stay_date`.
5. Demand Channel maps to `snap_demand_source`, not `snap_demand_channel`, because source is the standard distribution cut in the library.
6. `market_excl` means market excluding the subject property.
