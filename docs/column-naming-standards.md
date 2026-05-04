# Database Column Naming Standards

This document defines the standard naming system for database columns across the REVREBEL Metrics Library and hotel analytics warehouse. It consolidates the Phase 1 metadata audit findings, the yellow-note working conventions from the audit document, and the current preferred naming decisions.

The goal is not just cleaner names. The goal is a durable semantic layer where analysts, dashboards, pipelines, and automated documentation can infer meaning from a column name without needing to inspect every upstream table.

## Status

**Version:** Draft v0.1  
**Source:** Phase 1 Metadata Audit: Hotel Analytics Data Warehouse  
**Scope:** BigQuery analytics, snapshots, views, dimensions, mapped source tables, reporting tables, and derived metrics  
**Primary objective:** Standardize column names before broader schema cleanup and documentation work begins.

## Core Standard

Use lowercase `snake_case` for all columns.

Column names should follow this ordering pattern:

```text
{metric_or_entity}_{usage_or_context}_{period_or_comparison}_{modifier}
```

In practical terms:

1. **Metric or entity first** — what the column measures or identifies.
2. **Usage or context second** — what kind of value it is, where it came from, or how it is used.
3. **Period or comparison last** — time comparison, version, or benchmark context.
4. **Modifier only when needed** — rank, percent change, absolute change, map, code, name, count, etc.

### Examples

| Current / Variant | Preferred Standard | Reason |
|---|---|---|
| `rooms_budget` | `rms_bgt` | Metric first, concise standard abbreviation. |
| `available_rooms_ly` | `available_rms_ly` | Use `rms` consistently for rooms. |
| `rev_ly_actual` | `rev_ly` | Drop `actual` when `ly` already defines the comparison context. |
| `rooms_ly_actual` | `rms_ly` | Metric first; concise period suffix. |
| `rev_ly_actual_change_30_day` | `rev_chg_ly_30_day` or `rev_chg_30_day_ly` | Needs final decision on where rolling window belongs. |
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
```

### 2. Prefer approved abbreviations for recurring metric terms

The audit found multiple names for the same business concept, including `rooms`, `rms`, `room_nights`, and `rn`; `revenue` and `rev`; `occupancy` and `occ`; `prior_year`, `py`, and `ly`.

The standard is to use the approved short form when the term is a recurring metric component.

| Concept | Core Standard | Use Case | Other Variants Found / Disallowed |
|---|---:|---|---|
| Rooms | `rms` | Room counts, room production, room metrics. | `rooms`, `room_nights`, `rn` |
| Available rooms | `available_rms` | Physical capacity / available inventory. | `available_rooms`, `available_rms` is preferred; `physical_capacity` may appear only as source-language metadata. |
| Revenue | `rev` | Room revenue unless another revenue type is explicitly prefixed. | `revenue`, `property_rev`, `compset_rev`, `room_revenue` |
| Occupancy | `occ` | Occupancy metric. | `occupancy`, `hotel_occ` |
| Budget | `bgt` | Budgeted value. | `budget`, `bud` |
| Forecast | `fct` | Forecast value. | `forecast` |
| Actual | `act` | Actual value only when needed to distinguish from forecast/budget in the same column family. | `actual` |
| Last year / prior year | `ly` | Prior-year comparison. | `prior_year`, `py` |
| Current year | `cy` | Current-year comparison. | `current_year` |
| Same time last year | `stly` | Same-time-last-year pace comparison. | `same_time_last_year`, `same_time_ly` |
| Same time two years ago | `st2y` | Same-time-two-years-ago comparison. | `same_time_2_years` |
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

### 4. Period or comparison goes at the end

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

### 5. Drop redundant `actual` when the period already provides the context

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

Use `act` only where a column must distinguish actual from budget or forecast in the same time context.

### 6. Use `cs_` as the compset prefix

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

### 7. Revenue assumes room revenue unless another revenue type is specified

The working note states: revenue always assumes rooms unless otherwise prefixed. Therefore, `rev` should mean room revenue by default.

Use a prefix for non-room revenue categories.

| Revenue Type | Standard | Notes |
|---|---:|---|
| Room revenue | `rev` | Default meaning. |
| Food & beverage revenue | `fb_rev` | Use when the metric is specifically F&B revenue. |
| Other revenue | `other_rev` | Use when the metric is non-room and not F&B. |
| No-show revenue | `ns_rev` | Use no-show abbreviation. |
| Cancellation revenue | `cx_rev` | Use cancellation abbreviation. |
| Total revenue | `total_rev` | Use only when the metric includes room + non-room revenue. |

### 8. Use explicit date-role names

Date columns should describe the business meaning of the date, not just the data type.

| Concept | Core Standard | Use Case | Other Variants / Notes |
|---|---:|---|---|
| Date key / service date | `date` or `day` | Use `date` when it is a true calendar date; use `day` only where existing daily fact tables already use it as the grain. | Open question: confirm whether `day` or `date` should be the universal standard. |
| Booking date | `book_date` | Reservation creation / booking date. | Reservation Date, Made On |
| Arrival date | `arrival_date` | Stay arrival date. | Check-in date if source uses that wording. |
| Departure date | `departure_date` | Stay departure date. | Check-out date if source uses that wording. |
| Inserted date | `insert_date` | Row creation / load insertion date. | Inserted On, Created Date, Created On |
| Updated date | `updated_date` | Row update / changed date. | Updated On, Change Date, Modify Date |
| Snapshot date | `snap_date` | Snapshot effective date. | Snapshot Date |

### 9. Date values in file-derived or encoded fields should use `yyyyMMdd`

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

### 10. Month numbers should use two digits

Month references should use `01`, `02`, `03`, etc. Always include the leading zero.

### 11. Sequence numbers should use three digits

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

### 12. Use `no` for number only when it represents a business number, not a count

The audit note says to abbreviate “number” to `no`. Use it for identifiers or business numbers, not metric counts.

Examples:

```text
confirmation_no
folio_no
invoice_no
```

For counts, use the metric itself or a `_count` suffix if there is no approved metric abbreviation.

### 13. Use `_id` for system identifiers and `_code` for business/source codes

Use `id` when the value is a system-generated identifier. Use `code` when the value is a business code, PMS/CRS code, source code, rate code, room type code, segment code, or channel code.

| Concept | Standard | Notes |
|---|---:|---|
| Property code | `property_code` | Must exist on all tables where property-level analysis is required. |
| STR / CoStar hotel identifier | `str_id` | Standard for CoStar / STR property identifier. Confirm if `census_id` should be separate. |
| Reservation number / confirmation number | `resn_id` or `confirmation_no` | Open question: choose one based on whether the value is a system ID or guest-facing confirmation number. |
| Rate code | `rate_code` | Source rate plan code. |
| Room type code | `roomtype_code` | Source room type code. |
| Segment code | `segment_code` | Source segment code when code-level field is needed. |
| Source code | `source_code` | Source/channel system code. |

### 14. Name/code pairs should be explicit

Where a concept has both a display name and a source code, preserve that distinction.

| Concept | Name Field | Code Field |
|---|---:|---:|
| Rate | `rate` | `rate_code` |
| Source | `source` | `source_code` |
| Channel | `channel` | `channel_code` |
| Segment | `segment` | `segment_code` |
| Room type | `roomtype` | `roomtype_code` |
| Property | `property` or `property_name` | `property_code` |

### 15. Mapped values should use `_map`

Mapped fields represent the normalized value assigned from source-language input. These fields should clearly indicate the target domain and whether the source mapping was based on a code.

| Concept | Standard | Notes |
|---|---:|---|
| Segment mapping | `segment_map` | Normalized segment assigned from source value. |
| Segment-code mapping | `segment_code_map` | Normalized segment assigned from source code. |
| Rate mapping | `rate_map` | Normalized rate assigned from source value. |
| Rate-code mapping | `rate_code_map` | Normalized rate assigned from source code. |
| Source mapping | `source_map` | Normalized source assigned from source value. |
| Source-code mapping | `source_code_map` | Normalized source assigned from source code. |

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
| `act` | Actual. | Actual value when needed to distinguish from budget or forecast. | `actual` |
| `ly` | Last year / prior year. | Prior-year comparison. | `prior_year`, `py` |
| `cy` | Current year. | Current-year comparison. | `current_year` |
| `stly` | Same time last year. | Pace comparison to same time last year. | `same_time_last_year` |
| `st2y` | Same time two years ago. | Pace comparison to same time two years ago. | `same_time_2_years` |
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

### Budget, forecast, and actual

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
```

Examples:

```text
occ_chg
adr_chg
revpar_chg
available_rms_pct_chg_ly
adr_index_pct_chg_ly
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
| `property_code` | Required on all property-level tables. | The audit note says this must exist on all tables. Apply to all fact, snapshot, demand, pace, and property-level dimension tables. |
| `snap_date` | Required on snapshot tables. | Required when a table captures point-in-time state. |
| `insert_date` | Recommended on loaded tables. | Use for ingestion / creation date. |
| `updated_date` | Recommended where updates occur. | Use for changed / modified date. |

### Grain columns

Use explicit columns to communicate table grain.

Examples:

```text
property_code
snap_date
day
arrival_date
book_date
roomtype_code
segment_code
channel_code
source_code
```

## Audit Findings Incorporated

The Phase 1 audit identified the following major issues that these standards address:

1. **Naming synonyms and abbreviation variance** — recurring business concepts used multiple spellings and abbreviations.
2. **Inconsistent prefix/suffix ordering** — examples included `rooms_budget`, `rev_budget`, `nihrm__actualroomrevenue__c`, and `rev_ly_actual`.
3. **Compset inconsistency** — columns used `compset_`, `cs_`, and other variants.
4. **Documentation gaps** — 100 tables had 0% column descriptions, and several high-value metrics like ADR and RevPAR were missing descriptions.
5. **High-value metrics without standard descriptions** — ADR, RevPAR, rank, compset metrics, and demand tables need consistent descriptions.

## Migration Guidance

### Phase 1: Alias before breaking changes

For existing production views or dashboards, add standardized aliases first before removing old names.

Example:

```sql
SELECT
  available_rooms AS available_rms,
  compset_rev AS cs_rev,
  rev_ly_actual AS rev_ly
FROM source_table;
```

### Phase 2: Standardize downstream views

Use standardized column names in curated views, semantic models, and dashboard-facing tables. Avoid exposing source-system names in analytics-facing views unless they are intentionally preserved as raw source fields.

### Phase 3: Retire deprecated variants

Once downstream dependencies are migrated, remove deprecated variants from curated outputs.

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
| `available_rms` | Total available room inventory for the property or reporting grain. |
| `cs_occ` | Competitor set occupancy for the same reporting period and market context. |
| `rev_ly` | Room revenue for the comparable prior-year period. |
| `adr_rank` | Market or competitor-set rank based on average daily rate. |

## Clarifying Questions

These should be resolved before the standards are treated as final.

1. **Should daily grain use `day` or `date` as the universal standard?** The notes currently list `day`, while date-role fields use names like `arrival_date`, `book_date`, and `snap_date`.
2. **Should reservation number standardize to `resn_id`, `rsvn_id`, `confirmation_no`, or separate fields for each meaning?** The audit note lists “Reservation Number” with `resn_id`, but also references confirmation number and reservation ID.
3. **Should `roomtype` remain one word, or should we standardize to `room_type`?** The notes use `roomtype` and `roomtype_code`; many data teams prefer `room_type` for readability.
4. **Should `str_id` be the universal CoStar / STR hotel identifier, and should `census_id` remain a separate identifier?** The note references both.
5. **For rolling-window comparisons like `rev_ly_actual_change_30_day`, should the window come before or after the comparison period?** Candidate patterns: `rev_chg_30_day_ly` vs. `rev_chg_ly_30_day`.
6. **Should `act` be used only when budget/forecast/actual appear together, or should actual values always carry `act`?** The current note suggests dropping `ly_actual` but still lists `act` as a standard term.
7. **Should `yoy` remain allowed, or should it be replaced with `ly` + `chg` / `pct_chg` patterns?** Example: `cs_adr_yoy` versus `cs_adr_pct_chg_ly`.
8. **Should source-system raw fields retain original names in raw/staging layers?** Recommended: yes for raw tables, no for curated analytics views.

## Deprecated Variants

The following variants should be considered deprecated for curated analytics columns:

| Deprecated Variant | Replace With |
|---|---:|
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

## Implementation Checklist

Use this checklist when reviewing or creating tables.

- [ ] Column names are lowercase `snake_case`.
- [ ] Metric/entity comes first.
- [ ] Usage/context follows the metric/entity.
- [ ] Period/comparison appears last unless a final modifier is more readable.
- [ ] Approved abbreviations are used consistently.
- [ ] Compset metrics use the `cs_` prefix.
- [ ] Revenue defaults to room revenue unless prefixed otherwise.
- [ ] Date fields describe their business role.
- [ ] Month numbers include leading zero.
- [ ] Sequence suffixes use three digits and start at `_001`.
- [ ] Property-level tables include `property_code`.
- [ ] Snapshot tables include `snap_date`.
- [ ] Curated tables do not expose raw source-system naming unless intentionally documented.
- [ ] Every column has a description.

## Recommended Next Step

Resolve the clarifying questions above, then convert this draft into the canonical project standard. After approval, use this document to generate:

1. a rename mapping table,
2. SQL alias views for backward compatibility,
3. a column description template library,
4. a validation script that flags deprecated variants in schemas.
