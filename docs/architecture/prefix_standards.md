---
title: Table Prefix Standards
has_toc: false
nav_order: 2
---

# Table Prefix Standards

## Metrics Platform

This document defines the standardized table prefixes used throughout the Metrics Platform warehouse architecture.

**Prefixes are used to communicate:**

* the purpose of a table,
* how the data behaves operationally,
* where the table exists in the pipeline,
* and how the dataset should be consumed downstream.

The objective is immediate interpretability.

A table name should communicate enough context that analysts, pipelines, dashboards, and automation workflows can infer how the dataset behaves without opening the schema first.

**Because in a healthy warehouse, structure should explain intent.**



# Prefix Philosophy

The Metrics Platform separates datasets by operational responsibility rather than forcing every table into a generic reporting structure.

**Different tables serve different purposes:**

* some preserve raw operational behavior,
* some normalize source inconsistencies,
* some store finalized production metrics,
* and others exist purely for reporting convenience.

Prefixes make those distinctions visible immediately.



# Standard Prefix Framework

| Prefix  | Use For | Examples |
|---|---|---|
| `stg_`  | Cleaned and typed staging tables before business modeling and semantic transformation| `stg_ideas_pace_property` |
| `snap_` | Snapshot-based datasets that change over time, including pace, OTB, forecast, and other fluid reporting states | `snap_pace_property` |
| `vw_`   | BI-facing reporting views layered over fact and snapshot tables | `vw_pace_property` |
| `dim_`  | Shared descriptive dimensions and standardized reference entities| `dim_property`, `dim_roomtype` |
| `map_`  | Source-to-standard mapping relationships used for normalization | `map_segment`, `map_roomtype` |
| `lkp_`  | Controlled lookup lists and allowed-value reference tables| `lkp_plan_type`, `lkp_event_category` |
| `fact_` | Finalized operational fact tables containing measurable business activity| `fact_actual_property`, `fact_booking`, `fact_finance_gl` |



# Staging Tables (_stg)

Staging tables normalize raw source data before semantic modeling occurs.

**These tables typically handle:**

* type casting,
* date normalization,
* field cleanup,
* source-system inconsistencies,
* and initial structural transformations.

Staging tables preserve enough source-system behavior for traceability while making the data usable for warehouse processing.

## Examples

```text id="v88jwl"
stg_ideas_pace_property
stg_duetto_rms_segment
stg_costar_market_summary
```



# Snapshot Tables (snap_)

Snapshot tables store reporting states captured at a specific point in time.

**These datasets are commonly used for:**

* pace reporting,
* OTB analysis,
* pickup tracking,
* forecast snapshots,
* and evolving operational states.

Snapshot data is intentionally fluid.The same stay date may appear multiple times across different snapshot dates because the business position changes over time.

## Examples

```text id="36z33t"
snap_pace_property
snap_pace_segment
snap_forecast_daily
```



# Reporting Views (vw_)

Views provide BI-facing reporting layers designed for dashboards, semantic models, and downstream analytics.

**Views typically:**

* simplify joins,
* standardize KPI calculations,
* flatten reporting relationships,
* and expose reporting-friendly structures.

These layers improve reporting consistency while reducing duplicated dashboard logic.

## Examples

```text id="yzn5bw"
vw_pace_property
vw_actual_segment
vw_forecast_summary
```



# Dimension Tables (dim_)

Dimension tables store descriptive reference entities shared throughout the warehouse.

**These tables provide:**

* standardized labels,
* controlled business definitions,
* dimensional hierarchies,
* and reporting relationships.

Dimensions create consistency across operational systems that may structure the same concepts differently.

## Examples

```text id="lm6x1n"
dim_property
dim_roomtype
dim_source
dim_segment
```



# Mapping Tables (map_)

Mapping tables normalize source-system values into standardized warehouse structures.

**Hospitality systems rarely agree on:**

* segment names,
* source/channel naming,
* roomtype structures,
* or operational classifications.

Mapping tables resolve those inconsistencies while preserving source traceability.

## Examples

```text id="l1jwd7"
map_segment
map_roomtype
map_source
map_rate_code
```



# Lookup Tables (lkp_)

Lookup tables define controlled value sets used throughout the warehouse.

**These tables standardize:**

* enums,
* workflow states,
* classifications,
* allowed values,
* and operational categories.

**Lookup tables improve:**

* validation consistency,
* reporting integrity,
* and semantic predictability.

## Examples

```text id="9okbvu"
lkp_plan_type
lkp_event_category
lkp_forecast_status
```



# Fact Tables (act_)

Fact tables store measurable operational business activity.

**These datasets represent:**

* transactions,
* production metrics,
* financial activity,
* booking behavior,
* operational performance,
* and finalized reporting outcomes.

**Fact tables typically contain:**

* additive metrics,
* dimensional foreign keys,
* dates,
* and operational KPIs.

## Examples

```text id="r8w5lb"
fact_actual_property
fact_booking
fact_finance_gl
fact_price_shop
```



# Prefix Standards in Practice

Prefixes are intentionally concise and operationally descriptive.

**The objective is immediate readability during:**

* warehouse development,
* dashboard modeling,
* SQL analysis,
* automation workflows,
* and debugging.

**A well-structured warehouse should allow someone to infer:**

* what the table contains,
* how stable the data is,
* and how the dataset behaves operationally

directly from the table name itself.

**Because good warehouse architecture scales. Mystery tables do not.**
