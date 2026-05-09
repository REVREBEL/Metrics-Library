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

If a field changes how data is grouped, mapped, or interpreted, it should be available in the matching mapping table and/or fact grain.

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
| `roomfeature` | Yes | No | No | Add to `map_roomtype`; optional in facts, useful in marts. |
| `related_roomtypes` | Yes | No | No | Keep mainly in `dim_roomtype`; optional in `map_roomtype`. Not required in facts. |

### Status

Needs propagation.

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

## `map_roomtype`

Add:

```text
bedtype
bedtype_code
roomfeature
related_roomtypes
```

## `fact_pace_roomtype`

Add:

```text
bedtype
bedtype_code
roomfeature
```

## `fact_actual_roomtype`

Add:

```text
bedtype
bedtype_code
roomfeature
```

## `fact_pickup_roomtype`

Add:

```text
bedtype
bedtype_code
roomfeature
```

## Notes

The property fields `property_shortname`, `rating`, `crs_id`, `pms_id`, and `rateshop_id` are best kept in `dim_property` and joined into BI marts/views when needed. Repeating them in every fact table would make the facts wider without improving metric storage quality.
