# Database Column Naming Standards


## Metrics Library & Analytics Warehouse

This document defines the canonical naming system used across the REVREBEL Metrics Library and analytics warehouse.

The objective is consistency — not just in naming, but in how data is interpreted across dashboards, pipelines, models, reporting layers, automation workflows, and operational analysis.

The warehouse is designed as a durable semantic layer where analysts, systems, and documentation can infer meaning directly from a field name without needing to inspect every upstream source table manually.

**Clean naming is not cosmetic, it is operational infrastructure.**



# Core Naming Standard

All database columns use lowercase `snake_case`.

Column names follow this structure:

```text
{metric_or_entity}_{usage_or_context}_{period_or_comparison}_{numeric_window_or_sequence}
```

The structure prioritizes:

1. Metric or entity first
2. Context or usage second
3. Comparison or reporting period third
4. Numeric windows or sequence identifiers last

This ordering keeps related metric families grouped together logically and alphabetically across warehouse schemas.



# Naming Philosophy
The warehouse naming system is designed around semantic predictability.

A field name should communicate:
- what the metric represents,
- how it is used,
- what reporting context applies,
- and whether a comparison, ranking, or rolling window exists.

The naming structure intentionally favors consistency over source-system terminology. 

**Hospitality systems rarely agree on naming conventions. The warehouse does.**



# Core Naming Examples

| Current Variant | Warehouse Standard | Reason |
|---|---|---|
| `rooms_budget` | `rms_bgt` | Metric first using approved abbreviations. |
| `available_rooms_ly` | `available_rms_ly` | Standardized room inventory naming. |
| `rev_ly_actual` | `rev_ly` | Comparison context already defines the metric. |
| `rooms_ly_actual` | `rms_ly` | Concise prior-year structure. |
| `rev_ly_actual_change_30_day` | `rev_chg_ly_030` | Standardized ordering and rolling-window formatting. |
| `compset_rev` | `cs_rev` | Standardized competitive-set prefix. |
| `compset_occ` | `cs_occ` | Standardized competitive-set prefix. |
| `adr_index_pct_chg_py` | `adr_index_pct_chg_ly` | Warehouse standard uses `ly`. |



# Standard Formatting Rules

## Lowercase Snake Case

All fields use:
- lowercase letters
- underscores
- numeric suffixes where applicable

### Preferred

```text
property_code
arrival_date
roomtype_code
revpar_rank
```

### Avoid

```text
PropertyCode
ArrivalDate
roomTypeCode
RevPAR_Rank
segment_code_Map
```



# Approved Metric Abbreviations

The warehouse standard consolidates recurring business concepts into a single approved naming structure.

| Concept | Standard |
|---|---|
| Rooms | `rms` |
| Available Rooms | `available_rms` |
| Revenue | `rev` |
| Occupancy | `occ` |
| Budget | `bgt` |
| Forecast | `fct` |
| Actual | `act` |
| Last Year | `ly` |
| Current Year | `cy` |
| Same Time Last Year | `stly` |
| Same Time Two Years Ago | `st2y` |
| Year Over Year | `yoy` |
| Percentage | `pct` |
| Change | `chg` |
| Percentage Change | `pct_chg` |
| Competitive Set | `cs` |
| Cancellation | `cx` |
| No Show | `ns` |
| Reservations | `rsvn` |

This standard removes synonym drift across operational systems, vendor exports, reporting tools, and manually built datasets.



# Metric Ordering Logic

## Metric First

Metric names begin with the measure or business entity being described.

### Preferred

```text
rms_bgt
rev_bgt
rms_fct
rev_fct
rms_act
rev_act
rms_pace_stly
```

### Avoid

```text
rooms_budget
rev_budget
budget_rooms
actualroomrevenue
```



## Comparison & Period Suffixes

Reporting context appears after the metric.

### Preferred

```text
adr_ly
adr_cy
adr_stly
revpar_ly
rms_bgt_ly
rms_pace_stly
```

### Avoid

```text
ly_adr
prior_year_adr
stly_rms_pace
```

This keeps related metric families grouped together naturally during schema inspection and downstream modeling.



# Numeric Window Standards

Rolling windows and sequence identifiers always appear last while numeric windows use three-digit formatting for predictable sorting behavior.

### Preferred

```text
rev_chg_ly_030
rms_chg_ly_030
adr_chg_ly_030
revpar_pct_chg_ly_090
```

### Avoid

```text
rev_chg_30_day_ly
rev_30_day_chg_ly
```



# Competitive Set Standards

Competitive-set metrics use the `cs_` prefix.

### Standard

```text
cs_adr
cs_occ
cs_rev
cs_revpar
cs_rms
cs_adr_yoy
```

The warehouse standard treats competitive benchmarking as a first-class reporting layer, not an exception case.



# Revenue Naming Standards

Revenue defaults to room revenue unless another revenue category is explicitly prefixed.

| Revenue Type | Standard |
|---|---|
| Room Revenue | `rev` |
| Food & Beverage Revenue | `fb_rev` |
| Other Revenue | `other_rev` |
| No Show Revenue | `ns_rev` |
| Cancellation Revenue | `cx_rev` |
| Total Revenue | `total_rev` |

This keeps operational reporting concise while preserving semantic clarity for non-room revenue categories.



# Date Naming Standards

Date fields describe business meaning rather than storage type.

The warehouse standard daily grain field is:

```text
date
```

| Concept | Standard |
|---|---|
| Daily Reporting Grain | `date` |
| Booking Date | `book_date` |
| Arrival Date | `arrival_date` |
| Departure Date | `departure_date` |
| Inserted Date | `insert_date` |
| Updated Date | `updated_date` |
| Snapshot Date | `snap_date` |

The goal is immediate interpretability during reporting, transformation, and operational analysis.

---

# Identifier Standards

The warehouse uses standardized identifiers across all operational systems.

| Concept | Standard |
|---|---|
| Universal Reservation Identifier | `source_id` |
| Property Identifier | `property_code` |
| STR / CoStar Identifier | `str_id` |
| Rate Code | `rate_code` |
| Room Type Code | `roomtype_code` |
| Segment Code | `segment_code` |
| Source Code | `source_code` |

This structure normalizes identifier inconsistencies across PMS, CRS, booking engine, OTA, and third-party exports.



# Name & Code Pair Standards

Where a business concept contains both a readable label and a system identifier, the distinction remains explicit.

| Concept | Name Field | Code Field |
|---|---|---|
| Rate | `rate` | `rate_code` |
| Source | `source` | `source_code` |
| Channel | `channel` | `channel_code` |
| Segment | `segment` | `segment_code` |
| Room Type | `roomtype` | `roomtype_code` |
| Property | `property_name` | `property_code` |

---

# Source Mapping Standards

Standardized warehouse values may preserve source-system references when traceability or reconciliation is required.

Mapping fields use:

```text
{domain}_map
{domain}_code_map
```

Examples:

```text
segment_map
segment_code_map
rate_map
rate_code_map
source_map
source_code_map
```

The warehouse prioritizes standardized operational reporting while preserving source-level traceability where necessary.

---

# Core Metric Dictionary

| Standard | Definition |
|---|---|
| `rms` | Room count / room production metric |
| `available_rms` | Available room inventory |
| `rev` | Room revenue |
| `occ` | Occupancy |
| `adr` | Average Daily Rate |
| `revpar` | Revenue Per Available Room |
| `bgt` | Budget |
| `fct` | Forecast |
| `act` | Actual |
| `ly` | Last year / prior year |
| `cy` | Current year |
| `stly` | Same time last year |
| `st2y` | Same time two years ago |
| `yoy` | Year-over-year |
| `pct` | Percentage |
| `chg` | Change / variance |
| `pct_chg` | Percentage change |
| `rank` | Ranking metric |
| `cs` | Competitive set |
| `cx` | Cancellation |
| `ns` | No show |
| `nts` | Nights |
| `rsvn` | Reservations |



# Pattern Library

## Budget / Forecast / Actual

```text
{metric}_{bgt|fct|act}
{metric}_{bgt|fct|act}_{period}
```

Examples:

```text
rms_bgt
rev_bgt
rms_fct
rev_fct
rms_act
rev_act
```



## Pace Metrics

```text
{metric}_pace_{period}
```

Examples:

```text
rms_pace_stly
rev_pace_stly
adr_pace_stly
revpar_pace_stly
```



## Ranking Metrics

```text
{metric}_rank
{metric}_rank_{period}
cs_{metric}_rank
```

Examples:

```text
adr_rank
revpar_rank
cs_adr_rank
```



## Change Metrics

```text
{metric}_chg
{metric}_pct_chg
{metric}_chg_{period}
{metric}_pct_chg_{period}
```

Examples:

```text
occ_chg
adr_chg
revpar_chg
available_rms_pct_chg_ly
adr_index_pct_chg_ly
rev_chg_ly_030
```



# Required Common Columns

| Column | Purpose |
|---|---|
| `property_code` | Property-level reporting alignment |
| `date` | Daily reporting grain |
| `snap_date` | Snapshot reporting context |
| `source_id` | Reservation / source-system traceability |
| `insert_date` | Data ingestion timestamp |
| `updated_date` | Record update timestamp |

These fields establish baseline reporting consistency across fact, dimension, snapshot, and reporting layers.



# Warehouse Philosophy

The warehouse naming standard exists to create a reporting environment where:
- metrics group together logically,
- schemas remain predictable,
- dashboards remain stable,
- documentation stays aligned,
- and automation workflows can infer semantic meaning directly from structure.

**The objective is not shorter column names., the objective is operational clarity at scale.**



