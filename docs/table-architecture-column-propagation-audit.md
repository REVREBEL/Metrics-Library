---
title: Table Architecture Column Propagation Audit
nav_order: 4
has_toc: true
permalink: /table-architecture-column-propagation-audit/
---

# Table Architecture Column Propagation Audit

This audit checks whether newly added columns in the REVREBEL BI Table Architecture are represented in the required related tables.

## Summary

Several newly added fields are correctly present in their core dimensions, but some were not yet propagated into the corresponding mapping tables and fact table grains.

The affected areas are:

1. Property identity fields
2. Segment grouping / finance mapping fields
3. Source grouping fields
4. Roomtype detail fields
5. Room pool / related-roomtype grouping fields

## Propagation Rules

### Dimension-only fields

Some fields should live only in dimensions and should not be repeated in every fact table unless they are needed for downstream BI convenience.

Examples:

| Field | Recommended Home | Notes |
|---|---|---|
| `property_shortname` | `dim_property` | Can be joined in marts. Not required in raw fact tables. |
| `rating` | `dim_property` | Descriptive property attribute. Dimension only. |
| `crs_id` | `dim_property` | System identifier. Dimension only unless needed in source reconciliation. |
| `pms_id` | `dim_property` | System identifier. Dimension only unless needed in source reconciliation. |
| `rateshop_id` | `dim_property` | System identifier. Dimension only unless needed in source reconciliation. |

### Fields that should propagate

If a field changes how data is grouped, mapped, modeled, priced, or interpreted, it should be available in the matching mapping table and/or fact grain.

Room pool fields fall into this category because they support price sensitivity, room demand, upgrade/downgrade behavior, sell-through analysis, and demand calculations across related room types.

## Findings

## 1. `dim_property`

### Newly added fields found

| Field | Present in `dim_property` | Should propagate? | Recommendation |
|---|---:|---:|---|
| `property_shortname` | Yes | Optional | Keep in `dim_property`; add to marts only if useful for dashboards. |
| `rating` | Yes | No | Keep in `dim_property`. |
| `crs_id` | Yes | No | Keep in `dim_property`. |
| `pms_id` | Yes | No | Keep in `dim_property`. |
| `rateshop_id` | Yes | No | Keep in `dim_property`. |

### Status

No required fact-table propagation needed.

## 2. `dim_segment`

### Newly added fields found

| Field | Present in `dim_segment` | Present in `map_segment` | Present in segment facts | Recommendation |
|---|---:|---:|---:|---|
| `segment_group` | Yes | No | No | Add to `map_segment`, `fact_pace_segment`, `fact_actual_segment`, and `fact_pickup_segment`. |
| `segment_group_code` | Yes | No | No | Add to `map_segment`, `fact_pace_segment`, `fact_actual_segment`, and `fact_pickup_segment`. |
| `finance_segment` | Yes | No | No | Add to `map_segment`; optional in facts, recommended in marts. |
| `finance_segment_code` | Yes | No | No | Add to `map_segment`; optional in facts, recommended in marts. |
| `gl_code` | Yes | No | No | Add to `map_segment`; not required in pace facts unless used for finance reconciliation. |
| `rate_basis` | Yes | No | No | Add to `map_segment`, `fact_pace_segment`, and `fact_actual_segment` because it affects interpretation of revenue. |

### Status

Needs propagation.

## 3. `dim_source`

### Newly added / related fields found

The field pair `source_group` and `source_group_code` appears in `fact_pace_source`, but not yet in `dim_source`, `map_source`, `fact_actual_source`, or `fact_pickup_source`.

| Field | Present in `dim_source` | Present in `map_source` | Present in source facts | Recommendation |
|---|---:|---:|---:|---|
| `source_group` | No | No | Pace only | Add to `dim_source`, `map_source`, `fact_actual_source`, and `fact_pickup_source`. |
| `source_group_code` | No | No | Pace only | Add to `dim_source`, `map_source`, `fact_actual_source`, and `fact_pickup_source`. |

### Status

Needs propagation.

## 4. `dim_roomtype`

### Newly added fields found

| Field | Present in `dim_roomtype` | Present in `map_roomtype` | Present in roomtype facts | Recommendation |
|---|---:|---:|---:|---|
| `bedtype` | Yes | No | No | Add to `map_roomtype`, `fact_pace_roomtype`, `fact_actual_roomtype`, and `fact_pickup_roomtype`. |
| `bedtype_code` | Yes | No | No | Add to `map_roomtype`, `fact_pace_roomtype`, `fact_actual_roomtype`, and `fact_pickup_roomtype`. |
| `roomfeature` | Yes | No | No | Add to `map_roomtype`, `fact_pace_roomtype`, `fact_actual_roomtype`, and `fact_pickup_roomtype`. |
| `related_roomtypes` | Yes | No | No | Replace as a core analysis field with `roompool` / `roompool_code`; keep `related_roomtypes` as descriptive/reference metadata if needed. |

### Status

Needs propagation.

## 5. Room pool / related-roomtype modeling

`related_roomtypes` is analytically important for room pools, price sensitivity, demand calculations, and inventory/product grouping. However, a free-form `related_roomtypes` field is not ideal as the primary fact-table grouping key.

The recommended standard is to model room pools explicitly using:

```text
roompool
roompool_code
```

Use `related_roomtypes` as supporting metadata that describes which room types are grouped together, but use `roompool` and `roompool_code` as the actual analytical grain fields.

### Recommended room pool fields

| Field | Purpose |
|---|---|
| `roompool` | Standard room pool name used for analysis. |
| `roompool_code` | Standard room pool code used for joins, filtering, and BI grouping. |
| `roompool_map` | Source-system room pool or related-roomtype value, if provided. |
| `roompool_code_map` | Source-system room pool code, if provided. |
| `related_roomtypes` | Descriptive list of roomtypes included in the pool. Useful for documentation, not ideal as the primary join key. |

### Why this should propagate

Room pools are used to answer questions like:

1. Which related room products are showing pricing sensitivity?
2. Is demand shifting between bed types, views, premium tiers, or accessible variants?
3. Are room types within the same sellable pool behaving differently by ADR or pickup?
4. Should pricing or restrictions be adjusted at roomtype level or pool level?
5. Are upgrades, substitutions, or inventory constraints distorting roomtype-level demand?

Because of this, `roompool` and `roompool_code` should be available in roomtype mapping and roomtype fact tables.

## Recommended Updates

## `map_segment`

Add:

```text
segment_group
segment_group_code
finance_segment
finance_segment_code
gl_code
rate_basis
```

## `fact_pace_segment`

Add:

```text
segment_group
segment_group_code
finance_segment
finance_segment_code
rate_basis
```

## `fact_actual_segment`

Add:

```text
segment_group
segment_group_code
finance_segment
finance_segment_code
rate_basis
```

## `fact_pickup_segment`

Add:

```text
segment_group
segment_group_code
```

## `dim_source`

Add:

```text
source_group
source_group_code
```

## `map_source`

Add:

```text
source_group
source_group_code
```

## `fact_actual_source`

Add:

```text
source_group
source_group_code
```

## `fact_pickup_source`

Add:

```text
source_group
source_group_code
```

## `dim_roomtype`

Add:

```text
roompool
roompool_code
```

Keep:

```text
related_roomtypes
```

## `map_roomtype`

Add:

```text
bedtype
bedtype_code
roomfeature
roompool
roompool_code
roompool_map
roompool_code_map
related_roomtypes
```

## `fact_pace_roomtype`

Add:

```text
bedtype
bedtype_code
roomfeature
roompool
roompool_code
```

## `fact_actual_roomtype`

Add:

```text
bedtype
bedtype_code
roomfeature
roompool
roompool_code
```

## `fact_pickup_roomtype`

Add:

```text
bedtype
bedtype_code
roomfeature
roompool
roompool_code
```

## BI mart recommendation

Roomtype marts should include both roomtype-level and roompool-level fields.

Add to `mart_roomtype_daily`:

```text
roompool
roompool_code
roompool_available_rms
roompool_rms_otb
roompool_rev_otb
roompool_adr_otb
roompool_occ_otb
roompool_rms_pickup
roompool_rev_pickup
```

The `roompool_*` metrics may be calculated in the mart by aggregating roomtype facts across `roompool_code`.

## Notes

The property fields `property_shortname`, `rating`, `crs_id`, `pms_id`, and `rateshop_id` are best kept in `dim_property` and joined into BI marts/views when needed. Repeating them in every fact table would make the facts wider without improving metric storage quality.
