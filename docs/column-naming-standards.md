# Database Column Naming Standards

This document defines the standard naming system for database columns across the REVREBEL Metrics Library and hotel analytics warehouse. It consolidates the Phase 1 metadata audit findings, the embedded yellow-note working conventions, and the finalized naming decisions captured during review.

The goal is not just cleaner names. The goal is a durable semantic layer where analysts, dashboards, pipelines, and automated documentation can infer meaning from a column name without needing to inspect every upstream table.

<br>
<br>

## Status

**Version:** Draft v0.2  
**Source:** Phase 1 Metadata Audit: Hotel Analytics Data Warehouse  
**Scope:** BigQuery analytics, snapshots, views, dimensions, mapped source tables, reporting tables, and derived metrics  
**Primary objective:** Standardize column names, values, mappings, and metric references before broader schema cleanup and documentation work begins.

## Core Standard

Use lowercase `snake_case` for all columns.

Column names should follow this ordering pattern:

```text
{metric_or_entity}_{usage_or_context}_{period_or_comparison}_{numeric_window_or_sequence}
```

In practical terms:

1. **Metric or entity first** — what the column measures or identifies.
2. **Usage or context second** — what kind of value it is, where it came from, or how it is used.
3. **Period, comparison, or status third** — year comparison, pace comparison, budget/forecast/actual status, or benchmark context.
4. **Numeric window or sequence last** — rolling-window numbers, sequence numbers, or version numbers should be the final suffix and should be zero-padded.

### Examples

| Current / Variant | Standard | Reason |
|---|---|---|
| `rooms_budget` | `rms_bgt` | Metric first, concise standard abbreviation. |
| `available_rooms_ly` | `available_rms_ly` | Use `rms` consistently for rooms. |
| `rev_ly_actual` | `rev_ly` | Drop `actual` when `ly` already defines the comparison context. |
| `rooms_ly_actual` | `rms_ly` | Metric first; concise period suffix. |
| `rev_ly_actual_change_30_day` | `rev_chg_ly_030` | Metric first, change context second, comparison third, numeric window last and three characters. |
| `compset_rev` | `cs_rev` | Use `cs` as the standard compset prefix. |
| `compset_occ` | `cs_occ` | Use `cs` as the standard compset prefix. |
| `adr_index_pct_chg_py` | `adr_index_pct_chg_ly` | Use `ly` instead of `py` for prior year / last year. |

## Naming Rules

### 1. Use lowercase snake_case

Use only lowercase letters, numbers, and underscores.

**Do**

```text
property_code
arrival_date
roomtype_code
revpar_rank
```

**Do not**

```text
PropertyCode
ArrivalDate
roomTypeCode
RevPAR_Rank
segment_code_Map
```

### 2. Prefer approved abbreviations for recurring metric terms

The audit found multiple names for the same business concept, including `rooms`, `rms`, `room_nights`, and `rn`; `revenue` and `rev`; `occupancy` and `occ`; `prior_year`, `py`, and `ly`.

The standard is to use the approved short form when the term is a recurring metric component.

| Concept | Core Standard | Use Case | Other Variants Found / Disallowed |
|---|---:|---|---|
| Rooms | `rms` | Room counts, room production, room metrics. | `rooms`, `room_nights`, `rn` |
| Available rooms | `available_rms` | Physical capacity / available inventory. | `available_rooms`, `property_rooms`, `roomtype_available_rooms`, `physical_capacity` |
| Revenue | `rev` | Room revenue unless another revenue type is explicitly prefixed. | `revenue`, `property_rev`, `compset_rev`, `room_revenue` |
| Occupancy | `occ` | Occupancy metric. | `occupancy`, `hotel_occ` |
| Budget | `bgt` | Budgeted value. | `budget`, `bud` |
| Forecast | `fct` | Forecast value. | `forecast` |
| Actual | `act` | Actual value only when distinguishing budget, forecast, and actual in the same column family. | `actual` |
| Last year / prior year | `ly` | Prior-year comparison. | `prior_year`, `py` |
| Current year | `cy` | Current-year comparison. | `current_year` |
| Same time last year | `stly` | Same-time-last-year pace comparison. | `same_time_last_year`, `same_time_ly` |
| Same time two years ago | `st2y` | Same-time-two-years-ago comparison. | `same_time_2_years` |
| Year-over-year | `yoy` | Preferred shorthand for year-over-year comparison unless a table also records `pct_chg` and clarity requires a fuller pattern. | `year_over_year` |
| Percentage | `pct` | Percent values. | `percent`, `percentage` |
| Change | `chg` | Absolute change / variance. | `change`, `variance` |
| Percentage change | `pct_chg` | Percent change values. | `percent_change`, `percentage_change` |
| Competitor set / compset | `cs` | Prefix for competitor set metrics. | `compset`, `comp_set` |

### 3. Metric comes before usage/context

Metric names should start with the measure or entity being described.

**Preferred**

```text
rms_bgt
rev_bgt
rms_fct
rev_fct
rms_act
rev_act
rms_pace_stly
```

**Avoid**

```text
rooms_budget
rev_budget
budget_rooms
actualroomrevenue
actualtotalrevenue
```

### 4. Period or comparison follows the metric context

Period markers should be suffixes, not prefixes. This keeps all related metric columns grouped together when sorted alphabetically.

**Preferred**

```text
adr_ly
adr_cy
adr_stly
revpar_ly
rms_bgt_ly
rms_pace_stly
```

**Avoid**

```text
ly_adr
prior_year_adr
stly_rms_pace
```

### 5. Numeric windows and sequence values always go last

When a metric includes a rolling window, sequence number, or numeric analysis period, put the number at the end. The number should be three characters so columns sort cleanly and are easier to filter during manual analysis.

**Preferred**

```text
rev_chg_ly_030
rms_chg_ly_030
adr_chg_ly_030
revpar_pct_chg_ly_090
```

**Avoid**

```text
rev_chg_30_day_ly
rev_chg_ly_30_day
rev_30_day_chg_ly
```

### 6. Drop redundant `actual` when the period already provides the context

The audit notes call out that `ly_actual` should be dropped in favor of `ly` for clarity and concision.

**Preferred**

```text
rev_ly
rms_ly
cx_rms_ly
ns_rms_ly
```

**Avoid**

```text
rev_ly_actual
rooms_ly_actual
cancelled_rooms_ly_actual
noshow_rooms_ly_actual
```

Use `act` only as part of a status/progression family where the comparison is between budget, forecast, and actual.

```text
bgt > fct > act
```

Examples:

```text
rev_bgt
rev_fct
rev_act
rms_bgt
rms_fct
rms_act
```

For final versions of a data artifact, prefer versioning in the table or artifact name rather than the metric column name.

Examples:

```text
v001
v002
final
```

### 7. Use `cs_` as the compset prefix

Competitor-set metrics should always be prefixed with `cs_`.

**Preferred**

```text
cs_adr
cs_occ
cs_rev
cs_revpar
cs_rms
cs_adr_yoy
```

**Avoid**

```text
compset_adr
compset_occ
compset_rev
compset_rooms
```

### 8. Revenue assumes room revenue unless another revenue type is specified

Revenue always assumes room revenue unless otherwise prefixed. Therefore, `rev` means room revenue by default.

Use a prefix for non-room revenue categories.

| Revenue Type | Standard | Notes |
|---|---:|---|
| Room revenue | `rev` | Default meaning. |
| Food & beverage revenue | `fb_rev` | Use when the metric is specifically F&B revenue. |
| Other revenue | `other_rev` | Use when the metric is non-room and not F&B. |
| No-show revenue | `ns_rev` | Use no-show abbreviation. |
| Cancellation revenue | `cx_rev` | Use cancellation abbreviation. |
| Total revenue | `total_rev` | Use only when the metric includes room + non-room revenue. |

### 9. Use explicit date-role names

Date columns should describe the business meaning of the date, not just the data type.

The standard daily grain field is `date`.

| Concept | Core Standard | Use Case | Other Variants / Notes |
|---|---:|---|---|
| Daily grain / service date | `date` | Standard daily grain field. | Replace `day` in curated tables. |
| Booking date | `book_date` | Reservation creation / booking date. | Reservation Date, Made On |
| Arrival date | `arrival_date` | Stay arrival date. | Check-in date if source uses that wording. |
| Departure date | `departure_date` | Stay departure date. | Check-out date if source uses that wording. |
| Inserted date | `insert_date` | Row creation / load insertion date. | Inserted On, Created Date, Created On |
| Updated date | `updated_date` | Row update / changed date. | Updated On, Change Date, Modify Date |
| Snapshot date | `snap_date` | Snapshot effective date. | Snapshot Date |

### 10. Date values in file-derived or encoded fields should use `yyyyMMdd`

When a date is encoded into a string, suffix, file name, partition helper, or generated column, use `yyyyMMdd` with leading zeros.

```text
20260105
20261231
```

Avoid ambiguous formats such as:

```text
1/5/26
2026-1-5
01052026
```

### 11. Month numbers should use two digits

Month references should use `01`, `02`, `03`, etc. Always include the leading zero.

### 12. Sequence numbers should use three digits

Generated sequence suffixes should start at `_001` and use three digits.

**Preferred**

```text
rate_plan_001
rate_plan_002
source_code_001
```

**Avoid**

```text
rate_plan_1
rate_plan_01
source_code_1
```

### 13. Use `no` for number only when it represents a business number, not a count

Use `no` for identifiers or business numbers, not metric counts.

Examples:

```text
confirmation_no
folio_no
invoice_no
```

For counts, use the metric itself or a `_count` suffix if there is no approved metric abbreviation.

### 14. Use `source_id` as the universal reservation/source identifier

Reservation and confirmation identifiers vary widely across PMS, CRS, booking engine, OTA, and third-party data sources. To normalize these variants, use `source_id` as the universal identifier field unless a more specific entity ID is required by the model.

| Concept | Standard | Notes |
|---|---:|---|
| Universal source / reservation identifier | `source_id` | Use for reservation number, confirmation number, booking ID, source reservation ID, and equivalent source-level identifiers. |
| Property code | `property_code` | Must exist on all tables where property-level analysis is required. |
| STR / CoStar hotel identifier | `str_id` | Use even when source documentation refers to Census ID, CoStar Hotel ID, STR ID, or related terms that fall back to the same core number. |
| Rate code | `rate_code` | Source rate plan code. |
| Room type code | `roomtype_code` | Source room type code. Keep `roomtype` as one word. |
| Segment code | `segment_code` | Source segment code when code-level field is needed. |
| Source code | `source_code` | Source/channel system code. |

### 15. Name/code pairs should be explicit

Where a concept has both a display name and a source code, preserve that distinction.

| Concept | Name Field | Code Field |
|---|---:|---:|
| Rate | `rate` | `rate_code` |
| Source | `source` | `source_code` |
| Channel | `channel` | `channel_code` |
| Segment | `segment` | `segment_code` |
| Room type | `roomtype` | `roomtype_code` |
| Property | `property` or `property_name` | `property_code` |

### 16. Standardize all tables, but preserve source reference through mapping when needed

The standard preference is to convert data cleanly into standardized names and standardized values across all tables, not only curated views.

Raw, staging, fact, dimension, snapshot, and reporting tables should all favor the standard naming system.

When a source value must be retained for reference, reconciliation, or cases where the relationship is not consistently one-to-one, add a source-reference mapping column using this pattern:

```text
{source_metric}_map
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

Use `_map` columns to preserve the source value, mapping reference, or source-system category used to derive the standardized field.

## Core Metric Dictionary

| Core Standard | Definition | Use Case | Known Variants to Normalize |
|---|---|---|---|
| `rms` | Room count / room production metric. | Occupied rooms, sold rooms, room production, grouped room metrics. | `rooms`, `room_nights`, `rn` |
| `available_rms` | Available room inventory / physical capacity. | Property capacity, room type capacity, compset capacity. | `available_rooms`, `property_rooms`, `roomtype_available_rooms`, `physical_capacity` |
| `rev` | Room revenue. | Primary revenue metric for room revenue. | `revenue`, `room_revenue`, `property_rev` |
| `occ` | Occupancy. | Occupancy percentage or ratio. | `occupancy`, `hotel_occ` |
| `adr` | Average Daily Rate. | Rate metric. | Usually already standard; preserve lowercase. |
| `revpar` | Revenue per Available Room. | RevPAR metric. | Preserve lowercase. |
| `bgt` | Budget. | Budgeted value for a metric. | `budget`, `bud` |
| `fct` | Forecast. | Forecasted value for a metric. | `forecast` |
| `act` | Actual. | Actual value when distinguishing from budget or forecast. | `actual` |
| `ly` | Last year / prior year. | Prior-year comparison. | `prior_year`, `py` |
| `cy` | Current year. | Current-year comparison. | `current_year` |
| `stly` | Same time last year. | Pace comparison to same time last year. | `same_time_last_year` |
| `st2y` | Same time two years ago. | Pace comparison to same time two years ago. | `same_time_2_years` |
| `yoy` | Year-over-year. | Preferred shorthand for YoY metric variants. | `year_over_year` |
| `pct` | Percent. | Percentage value. | `percent`, `percentage` |
| `chg` | Change / variance. | Absolute change. | `change`, `variance` |
| `pct_chg` | Percent change. | Percentage change. | `percent_change`, `percentage_change` |
| `rank` | Rank. | Market ranking, compset ranking, metric rank. | preserve as suffix |
| `cs` | Competitor set. | Prefix for compset metrics. | `compset`, `comp_set` |
| `cx` | Cancellation. | Cancellation counts, rooms, revenue. | `cancelled`, `cancellation` |
| `ns` | No-show. | No-show counts, rooms, revenue. | `noshow`, `no_show` |
| `nts` | Nights / room nights. | Length-of-stay or nights count. | `nights`, `room_nights`, `number_of_days`, `days` |
| `rsvn` | Reservations. | Reservation counts or reservation-level values. | `reservations`, `reservation` |

## Pattern Library

### Budget, forecast, and actual progression

Use `bgt`, `fct`, and `act` as a status/progression sequence.

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
rms_bgt_ly
rev_fct_cy
```

### Pace metrics

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

### Ranking metrics

```text
{metric}_rank
{metric}_rank_{period}
cs_{metric}_rank
```

Examples:

```text
adr_rank
adr_rank_ly
revpar_rank
revpar_rank_ly
cs_adr_rank
```

### Change metrics

Use `_chg` for absolute change and `_pct_chg` for percentage change.

```text
{metric}_chg
{metric}_pct_chg
{metric}_chg_{period}
{metric}_pct_chg_{period}
{metric}_chg_{period}_{numeric_window}
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

### Year-over-year metrics

`yoy` is preferred for year-over-year metrics unless the table also records `pct_chg` or another change calculation where the fuller naming pattern improves clarity.

Preferred simple YoY pattern:

```text
{metric}_yoy
cs_{metric}_yoy
```

Examples:

```text
adr_yoy
revpar_yoy
cs_adr_yoy
```

Use fuller change naming when needed for clarity:

```text
{metric}_pct_chg_ly
{metric}_chg_ly
```

### Compset metrics

```text
cs_{metric}
cs_{metric}_{period}
cs_{metric}_{modifier}
```

Examples:

```text
cs_occ
cs_adr
cs_rev
cs_rms
cs_revpar
cs_adr_yoy
```

### Source and mapping columns

```text
{domain}
{domain}_code
{domain}_map
{domain}_code_map
```

Examples:

```text
source
source_code
source_map
source_code_map
segment
segment_code
segment_map
segment_code_map
rate
rate_code
rate_map
rate_code_map
```

## Required / Recommended Common Columns

### Required when applicable

| Column | Requirement | Notes |
|---|---|---|
| `property_code` | Required on all property-level tables. | Apply to all fact, snapshot, demand, pace, and property-level dimension tables. |
| `date` | Required on daily-grain tables. | Standard daily grain column. |
| `snap_date` | Required on snapshot tables. | Required when a table captures point-in-time state. |
| `source_id` | Required where a record must reference the original reservation, confirmation, or source identifier. | Universal source identifier across variant source systems. |
| `insert_date` | Recommended on loaded tables. | Use for ingestion / creation date. |
| `updated_date` | Recommended where updates occur. | Use for changed / modified date. |

### Grain columns

Use explicit columns to communicate table grain.

Examples:

```text
property_code
date
snap_date
arrival_date
book_date
roomtype_code
segment_code
channel_code
source_code
source_id
```

## Audit Findings Incorporated

The Phase 1 audit identified the following major issues that these standards address:

1. **Naming synonyms and abbreviation variance** — recurring business concepts used multiple spellings and abbreviations.
2. **Inconsistent prefix/suffix ordering** — examples included `rooms_budget`, `rev_budget`, `nihrm__actualroomrevenue__c`, and `rev_ly_actual`.
3. **Compset inconsistency** — columns used `compset_`, `cs_`, and other variants.
4. **Documentation gaps** — 100 tables had 0% column descriptions, and several high-value metrics like ADR and RevPAR were missing descriptions.
5. **High-value metrics without standard descriptions** — ADR, RevPAR, rank, compset metrics, and demand tables need consistent descriptions.
6. **Source-system naming variance** — source values and source identifiers need to be standardized in the database while retaining `_map` fields when traceability is required.

## Migration Guidance

### Phase 1: Standardize table output names

Standardize column names across all tables wherever feasible, including staging, fact, dimension, snapshot, and reporting tables.

Example:

```sql
SELECT
  available_rooms AS available_rms,
  compset_rev AS cs_rev,
  rev_ly_actual AS rev_ly,
  reservation_number AS source_id
FROM source_table;
```

### Phase 2: Preserve source references only where needed

If the source value is needed for traceability, reconciliation, or non-1:1 mapping, keep a mapping/reference column using `_map`.

Example:

```sql
SELECT
  normalized_segment AS segment,
  source_segment_value AS segment_map,
  normalized_segment_code AS segment_code,
  source_segment_code AS segment_code_map
FROM source_table;
```

### Phase 3: Retire deprecated variants

Once downstream dependencies are migrated, remove deprecated variants from outputs.

### Phase 4: Add column descriptions

Every standardized column should have a concise description using a consistent format.

Recommended format:

```text
{Plain-English definition}. {Important calculation, source, or grain note if applicable}.
```

Examples:

| Column | Description |
|---|---|
| `property_code` | Unique property code used to join property-level facts, dimensions, and reporting tables. |
| `date` | Calendar date for the daily reporting grain. |
| `source_id` | Universal source identifier used to reference the original reservation, confirmation, booking, or source-system record. |
| `str_id` | Standard STR / CoStar property identifier. |
| `available_rms` | Total available room inventory for the property or reporting grain. |
| `cs_occ` | Competitor set occupancy for the same reporting period and market context. |
| `rev_ly` | Room revenue for the comparable prior-year period. |
| `rev_chg_ly_030` | Absolute room revenue change versus last year over a 30-day window. |
| `adr_rank` | Market or competitor-set rank based on average daily rate. |

## Deprecated Variants

The following variants should be considered deprecated for standardized database columns:

| Deprecated Variant | Replace With |
|---|---:|
| `day` as daily grain | `date` |
| `rooms` as a metric abbreviation | `rms` |
| `room_nights` as room production | `rms` or `nts`, depending on meaning |
| `rn` | `rms` or `nts`, depending on meaning |
| `revenue` | `rev` |
| `occupancy` | `occ` |
| `budget` | `bgt` |
| `bud` | `bgt` |
| `forecast` | `fct` |
| `actual` | `act`, only where needed |
| `prior_year` | `ly` |
| `py` | `ly` |
| `compset_` | `cs_` |
| `available_rooms` | `available_rms` |
| `rev_ly_actual` | `rev_ly` |
| `rooms_ly_actual` | `rms_ly` |
| `cancelled_rooms_ly_actual` | `cx_rms_ly` |
| `noshow_rooms_ly_actual` | `ns_rms_ly` |
| `reservation_number`, `confirmation_number`, source booking IDs | `source_id` |
| `room_type`, where used as core warehouse term | `roomtype` |
| `census_id`, `costar_hotel_id` for STR/CoStar property identifier | `str_id` |
| `segment_code_Map` | `segment_code_map` |

## Implementation Checklist

Use this checklist when reviewing or creating tables.

- [ ] Column names are lowercase `snake_case`.
- [ ] Metric/entity comes first.
- [ ] Usage/context follows the metric/entity.
- [ ] Period/comparison appears after the usage/context.
- [ ] Numeric windows and sequences appear last and are zero-padded to three characters.
- [ ] Approved abbreviations are used consistently.
- [ ] Daily grain uses `date`, not `day`.
- [ ] Reservation/confirmation/source record identifiers use `source_id`.
- [ ] Room type fields use `roomtype`, not `room_type`.
- [ ] STR / CoStar / Census property identifier fields use `str_id`.
- [ ] Compset metrics use the `cs_` prefix.
- [ ] Revenue defaults to room revenue unless prefixed otherwise.
- [ ] `act` is used only when distinguishing budget, forecast, and actual.
- [ ] `yoy` is allowed and preferred unless fuller `pct_chg_ly` / `chg_ly` naming is required for clarity.
- [ ] Date fields describe their business role.
- [ ] Month numbers include leading zero.
- [ ] Sequence suffixes use three digits and start at `_001`.
- [ ] Property-level tables include `property_code`.
- [ ] Snapshot tables include `snap_date`.
- [ ] Source value traceability uses `_map` columns where needed.
- [ ] Every column has a description.

## Recommended Next Step

Use this document to generate:

1. a rename mapping table,
2. SQL alias / transformation views for migration,
3. a column description template library,
4. a validation script that flags deprecated variants in schemas,
5. a source-value mapping inventory for `_map` fields.



> Test Blockquote



<details> & <summary>: Create collapsible toggles.


<sub> For subscripts.

<sup>: For superscripts.

<kbd>: For keyboard shortcuts (renders as a little button).


<table>: For more advanced table formatting than standard Markdown pipes.





$\color{red}{\text{This text is red}}$