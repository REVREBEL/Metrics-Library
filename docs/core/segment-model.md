---
title: Segment Model
nav_order: 10
has_toc: true
permalink: /segment-model/
---

# Segment Model

Segment data is one of the first places hotel reporting starts to drift. PMS, CRS, RMS, finance, and BI tools all use segment logic, but they rarely agree on names, grouping, codes, or ledger treatment. Delightful.

The Metrics segment model separates source-system segment values from the standardized commercial and finance structure. Source values are mapped once, then published into a production segment dimension that can be used consistently by pace, actuals, forecast, budget, pickup, and finance reporting.

## How We View Segment Data

Segment is both a commercial lens and a financial reporting bridge.

Commercial teams need segment logic to understand demand behavior, booking mix, pricing strategy, and pace. Finance needs segment logic to align production to ledger treatment, budget structure, and reporting rollups. Those needs overlap, but they are not always identical.

The model keeps segment group, segment, and finance segment as separate controlled structures. That gives Metrics enough flexibility to support revenue strategy without breaking finance alignment or forcing every source system into one flat label.

## Table Family

| Table | Purpose |
|---|---|
| `lkp_segment_group` | Controlled list of high-level commercial segment groups. |
| `lkp_segment` | Controlled list of standard commercial segments. Each segment belongs to a segment group. |
| `lkp_finance_segment` | Controlled list of finance reporting segments. |
| `map_segment` | Source-to-standard mapping table used to classify source-system segment values. |
| `dim_segment` | Production segment reference used by ingestion, facts, snapshots, and reporting. |
| `vw_segment` | Enriched view that joins the dimension to segment, group, and finance labels. |

---

## Lookup Tables

Lookup tables define controlled values. They should stay small, readable, and stable. The table name provides the context, so the columns can remain simple: `code`, `name`, `description`, and `sort`.

## `lkp_segment_group`

Segment group defines the highest commercial rollup for standard segment reporting.

### Columns

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard segment group code. |
| `name` | STRING | Segment group display name. |
| `description` | STRING | Definition or usage notes for the segment group. |
| `sort` | INT64 | Display order for reporting. |
| `is_active` | BOOL | Indicates whether the segment group is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### Example Values

| code | name | description | sort |
|---|---|---|---:|
| `TRANSIENT` | Transient | Individual transient demand not contracted as group or long-term business. | 10 |
| `GROUP` | Group | Group blocks, meetings, events, and contracted group production. | 20 |
| `CONTRACT` | Contract | Contracted or negotiated long-term production. | 30 |
| `OTHER` | Other | Production that does not fit the primary commercial groups. | 90 |

---

## `lkp_segment`

Segment defines the standard commercial segment used by Metrics.

Each segment belongs to a segment group through `segment_group_code`.

### Columns

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard segment code. |
| `name` | STRING | Segment display name. |
| `description` | STRING | Definition or usage notes for the segment. |
| `sort` | INT64 | Display order for reporting. |
| `segment_group_code` | STRING | Standard segment group code. Joins to `lkp_segment_group.code`. |
| `is_active` | BOOL | Indicates whether the segment is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### Example Values

| code | name | description | sort | segment_group_code |
|---|---|---|---:|---|
| `BAR` | BAR / Retail | Best available or retail transient production. | 10 | `TRANSIENT` |
| `DISCOUNT` | Discount | Discounted transient production. | 20 | `TRANSIENT` |
| `NEGOTIATED` | Negotiated | Negotiated transient or corporate production. | 30 | `TRANSIENT` |
| `GROUP` | Group | Standard group production. | 10 | `GROUP` |
| `WHOLESALE` | Wholesale | Wholesale, tour, or net-rated production where applicable. | 40 | `CONTRACT` |

---

## `lkp_finance_segment`

Finance segment defines the segment structure used for finance, accounting, ledger reporting, or budget alignment.

This is intentionally separate from `lkp_segment`. Commercial segment and finance segment often align, but when they do not, pretending they are the same usually creates reporting debt. And reporting debt always collects interest.

### Columns

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard finance segment code. |
| `name` | STRING | Finance segment display name. |
| `description` | STRING | Definition or usage notes for the finance segment. |
| `sort` | INT64 | Display order for finance reporting. |
| `is_active` | BOOL | Indicates whether the finance segment is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### Example Values

| code | name | description | sort |
|---|---|---|---:|
| `TRANSIENT` | Transient | Finance transient segment rollup. | 10 |
| `GROUP` | Group | Finance group segment rollup. | 20 |
| `CONTRACT` | Contract | Finance contract segment rollup. | 30 |
| `OTHER` | Other | Other finance segment rollup. | 90 |

---

## `map_segment`

`map_segment` is the source-to-standard translation layer. It stores the segment value as it appears in a source system and maps it into the standard commercial and finance segment structures.

The source fields use plain names because the table provides the context. Inside `map_segment`, `system`, `code`, `name`, and `description` refer to the source-system segment values.

### Grain

```text
property_code + system + code
```

If a source system does not provide a reliable segment code, the effective grain may use:

```text
property_code + system + name
```

### Columns

| Column | Type | Definition |
|---|---|---|
| `property_code` | STRING | Property code. |
| `system` | STRING | Source system providing the segment value. |
| `code` | STRING | Source-system segment code. |
| `name` | STRING | Source-system segment name or label. |
| `description` | STRING | Source-system segment description, if supplied. |
| `segment_code` | STRING | Standard commercial segment code. Joins to `lkp_segment.code`. |
| `finance_segment_code` | STRING | Standard finance segment code. Joins to `lkp_finance_segment.code`. |
| `gl_code` | STRING | General ledger or guest ledger code associated with the mapped segment, when available. |
| `is_active` | BOOL | Indicates whether the mapping is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### Working Field Alignment

| Working Field | Standard Field | Notes |
|---|---|---|
| `property_code` | `property_code` | Property code. |
| `system` | `system` | Source system. |
| `code` | `code` | Source-system segment code. |
| `name` | `name` | Source-system segment name. |
| `description` | `description` | Source-system segment description. |
| `segment_code` | `segment_code` | Standard commercial segment code. |
| `finance_segment_code` | `finance_segment_code` | Standard finance segment code. |
| `gl_code` | `gl_code` | General ledger or guest ledger code. |
| `is_active` | `is_active` | Active mapping flag. |
| `insert_date` | `insert_date` | Insert date. |
| `updated_date` | `updated_date` | Updated date. |

---

## `dim_segment`

`dim_segment` is the production segment reference table. It is generated from `map_segment` and the segment lookup tables.

The dimension carries the single mapped source lookup value needed during processing:

```text
map_segment_code
```

That value connects incoming cleaned data back to the source segment code that was mapped, while keeping the dimension focused on standardized commercial and finance structure.

### Processing Logic

Incoming source files can resolve segments directly through `dim_segment.map_segment_code`:

```sql
LEFT JOIN metrics_core.dim_segment s
  ON incoming.property_code = s.property_code
 AND incoming.segment_code = s.map_segment_code
```

Once resolved, the pipeline writes the standard commercial segment code to the target table:

```text
incoming source segment code → dim_segment.map_segment_code → dim_segment.segment_code → target.segment_code
```

The full source context remains in `map_segment`:

```text
map_segment.system
map_segment.code
map_segment.name
map_segment.description
```

### Columns

| Column | Type | Definition |
|---|---|---|
| `property_code` | STRING | Property code. |
| `map_segment_code` | STRING | Source segment code from `map_segment.code`. Used to resolve incoming source data. |
| `segment_code` | STRING | Standard commercial segment code. Joins to `lkp_segment.code`. |
| `segment_group_code` | STRING | Standard segment group code. Joins to `lkp_segment_group.code`. Usually inherited from `lkp_segment.segment_group_code`. |
| `finance_segment_code` | STRING | Standard finance segment code. Joins to `lkp_finance_segment.code`. |
| `gl_code` | STRING | General ledger or guest ledger code associated with the segment, when available. |
| `is_active` | BOOL | Indicates whether the segment reference is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### Build Logic

The production dimension should inherit `segment_group_code` from `lkp_segment` wherever possible.

```sql
SELECT
  m.property_code,
  m.code AS map_segment_code,
  m.segment_code,
  sg.code AS segment_group_code,
  m.finance_segment_code,
  m.gl_code,
  m.is_active,
  CURRENT_DATE() AS insert_date,
  CURRENT_DATE() AS updated_date
FROM metrics_core.map_segment m
LEFT JOIN metrics_core.lkp_segment s
  ON m.segment_code = s.code
LEFT JOIN metrics_core.lkp_segment_group sg
  ON s.segment_group_code = sg.code
```

This keeps group assignment controlled by the segment lookup instead of manually repeating the group in every mapped source row. One source row should not get to freelance the segment hierarchy.

---

## `vw_segment`

`vw_segment` joins the production dimension to lookup labels and descriptions. This is the version reporting, QA, and exports should use when users need readable segment names.

### Columns

| Column | Source | Definition |
|---|---|---|
| `property_code` | `dim_segment` | Property code. |
| `map_segment_code` | `dim_segment` | Source segment code used for ingestion lookup. |
| `segment_code` | `dim_segment` | Standard commercial segment code. |
| `segment` | `lkp_segment.name` | Standard commercial segment name. |
| `segment_description` | `lkp_segment.description` | Standard commercial segment description. |
| `segment_group_code` | `dim_segment` | Standard segment group code. |
| `segment_group` | `lkp_segment_group.name` | Standard segment group name. |
| `segment_group_description` | `lkp_segment_group.description` | Standard segment group description. |
| `finance_segment_code` | `dim_segment` | Standard finance segment code. |
| `finance_segment` | `lkp_finance_segment.name` | Finance segment name. |
| `finance_segment_description` | `lkp_finance_segment.description` | Finance segment description. |
| `gl_code` | `dim_segment` | General ledger or guest ledger code. |
| `sort` | INT64 | Display order for reporting. |
| `is_active` | `dim_segment` | Active flag. |

---

## Relationship to Pace, Actuals, Forecast, Budget, and Finance

Segment-level source files should resolve against `dim_segment` during processing. The target metric table should store the standard segment code and any finance/GL values required by the table’s purpose.

For example:

```text
source file segment code
  → dim_segment.map_segment_code
  → dim_segment.segment_code
  → snap_pace_segment.segment_code
```

Target tables then use:

```text
snap_pace_segment.segment_code
fact_actual_segment.segment_code
fact_pickup_segment.segment_code
fact_manual_plan.segment_code
fact_finance_gl.segment_code
```

The reporting layer can join to `vw_segment` to bring in segment name, group name, finance segment, and GL context.

## Operating Notes

1. `lkp_segment_group`, `lkp_segment`, and `lkp_finance_segment` define controlled values.
2. `lkp_segment.segment_group_code` controls the commercial segment hierarchy.
3. `map_segment` translates and governs source-system segment values before they are published into the production dimension.
4. `map_segment` uses `system`, `code`, `name`, and `description`; it does not use the `source_` prefix because the table context already makes those fields source-oriented.
5. `dim_segment` carries `map_segment_code` as the single lookup back to the mapped source segment code.
6. `dim_segment.segment_group_code` should be inherited from `lkp_segment` unless there is a specific, documented exception.
7. Finance segment is separate from commercial segment on purpose. Sometimes finance and revenue strategy agree. Sometimes they have met, briefly, in a hallway.
8. Target metric tables should store `segment_code`; readable names belong in `vw_segment`.
