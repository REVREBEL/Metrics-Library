# CoStar STAR Report Processing Standards

## REVREBEL Metrics Library & Analytics Warehouse

This document defines the processing standards, schema structure, validation logic, and benchmarking methodology used for CoStar (STR) performance reporting inside the REVREBEL analytics warehouse.

The objective is not simply ingesting STAR reports. The objective is preserving competitive context, benchmark integrity, and historical market behavior across operational reporting, forecasting, and performance analysis.



# Understanding STAR Reports & Benchmarking Data

The STAR Report, provided by STR (a CoStar Group company), is the hospitality industry’s standard benchmarking framework for measuring hotel performance against a defined competitive set.

Rather than evaluating performance in isolation, STAR reporting measures how a hotel performs relative to its market across occupancy, rate, and revenue efficiency.

For hotel operators, ownership groups, asset managers, and revenue teams, it functions as both a market scorecard and a competitive positioning system.

<br>

The report centers around three primary performance metrics:

| Metric | Description |
|---|---|
| Occupancy (`occ`) | Percentage of available rooms sold |
| ADR (`adr`) | Average Daily Rate |
| RevPAR (`revpar`) | Revenue Per Available Room |

These metrics are benchmarked against a selected competitive set (“compset”) to generate industry-standard index metrics:

| Index | Definition |
|---|---|
| MPI | Occupancy Index vs Competitive Set |
| ARI | ADR Index vs Competitive Set |
| RGI | RevPAR Index vs Competitive Set |

An index score of:

- `100` represents fair market share
- `>100` indicates market outperformance
- `<100` indicates underperformance relative to the comp set


## How the Report is Generally Used
**Hotels use STAR reporting to:**
- evaluate market share,
- monitor pricing strategy,
- assess revenue efficiency,
- benchmark competitive positioning,
- and identify where performance is gaining or losing ground.

Unlike transactional PMS data, STAR reporting is observational and benchmark-driven by nature.

**It contains:**
- market-relative positioning,
- competitive rankings,
- snapshot-based comparisons,
- prior-period benchmarking,
- index calculations,
- and comp set relationships that do not always reconcile directly to operational room-night production.

Because of this, the REVREBEL warehouse models CoStar data as a benchmarking and market-intelligence layer rather than a transactional operational dataset.

**The objective is not simply storing performance metrics. The objective is preserving competitive context.**



# Data Model Philosophy

CoStar data behaves differently than PMS operational reporting.

**Operational systems primarily record transactions:**
- reservations,
- room nights,
- revenue production,
- guest activity,
- and inventory movement.

STAR reporting evaluates market-relative performance. That distinction matters.

**The warehouse structure intentionally separates benchmarking logic from operational production data to preserve:**

- historical benchmark continuity,
- comp set integrity,
- market-relative calculations,
- ranking behavior,
- snapshot comparisons,
- and forecasting consistency.

Competitive sets evolve over time. Market positioning changes. Benchmarks shift. The warehouse structure is designed to preserve those changes historically rather than flatten or overwrite them.

**Changing the benchmark changes the meaning of the data.**



# Core Data Fields
This section defines the required schema, processing logic, and data handling standards for ingesting and transforming CoStar (STR) performance reports into the `metrics_fact_costar` dataset.

## Property & Metadata Fields

| Field | Description |
|---|---|
| `property_code` | Standardized property identifier used across REVREBEL systems |
| `property_name` | Standardized property name |
| `property_shortname` | Short-form operational property name |
| `str_id` | STR / CoStar property identifier |
| `cs_id` | Competitive set identifier |
| `cs_no` | Competitive set grouping (`Set01`, `Set02`, `Set03`) |
| `cs_reference` | External competitive set reference |
| `brand` | Brand classification |



## Calendar & Date Fields

| Field | Format / Logic |
|---|---|
| `month` | Full month name |
| `month_name` | Prior-year month name |
| `cy` | Current year (`YYYY`) |
| `ly` | Prior year (`YYYY`) |
| `weekday` | Full weekday name |
| `weekday_ly` | Prior-year weekday |
| `week_no` | Numeric week number |
| `week_no_ly` | Prior-year week number |
| `dow` | Day-of-week abbreviation (`SUN–SAT`) |
| `day` | Day with leading zero (`01–31`) |
| `date` | Daily reporting grain (`YYYY-MM-DD`) |
| `date_ly` | Prior-year reporting date |
| `no_days` | Number of represented days |
| `no_days_ly` | Prior-year represented days |



# Core Metric Structure

## Primary Metrics

```text
occ
adr
revpar
```

These metrics serve as the foundational benchmarking layer across property, competitive set, and industry performance reporting.



# Metric Expansion Logic

## Base Metric Structure

```text
{metric}
{metric}_ly
cs_{metric}
cs_{metric}_ly
industry_{metric}
industry_{metric}_ly
```

## Percent Change Structure

```text
{metric}_pct_chg
cs_{metric}_pct_chg
industry_{metric}_pct_chg
```

## Index Structure

```text
{metric}_index
{metric}_index_ly
cs_{metric}_index
industry_{metric}_index
```

## Ranking Structure

```text
{metric}_rank
{metric}_pct_chg_rank
```

The warehouse structure keeps related metric families grouped together logically while preserving semantic consistency across reporting layers.



# Derived Metrics

## Capacity & Revenue Calculations

| Field | Formula |
|---|---|
| `rms` | `ROUND(occ * (available_rms / 100))` |
| `rms_ly` | `ROUND(occ_ly * (available_rms_ly / 100))` |
| `cs_rms` | `ROUND(cs_occ * (cs_available_rms / 100))` |
| `cs_rms_ly` | `ROUND(cs_occ_ly * (cs_available_rms_ly / 100))` |
| `rev` | `rms * adr` |
| `rev_ly` | `rms_ly * adr_ly` |
| `cs_rev` | `cs_rms * cs_adr` |
| `cs_rev_ly` | `cs_rms_ly * cs_adr_ly` |



# Competitive Set Handling

STAR reports may contain multiple competitive sets.

Competitive sets are identified using suffix-based segmentation:

```text
_1
_2
_3
```

Mapped internally as:

```text
Set01
Set02
Set03
```

Each competitive set:
- processes independently,
- maintains separate benchmark continuity,
- preserves historical positioning,
- and supports independent ranking and index calculations.

The warehouse intentionally treats comp sets as independent benchmarking contexts rather than interchangeable reporting dimensions.



# Property Identification Logic

Property identification follows a structured fallback hierarchy designed to maintain ingestion reliability and benchmark continuity.

## Primary Identification Method

Extract `property_code` from the filename.

Example:

```text
MSPHEH
```



## Secondary Identification Method

Extract STR / CoStar identifier (`str_id`).

```
cs_id = STR IDs concatenated with hyphens
```

![alt](https://raw.githubusercontent.com/REVREBEL/Metrics-Library/main/assets/images/costar_compset_id_extraction_example.png)


Example:
```
65206-54429-55653-44555-56751-39388
```

> This uniquely defines the comp set composition.




## Tertiary Identification Method

Match against standardized `property_name`.

Once identified, the property reference becomes the session-level lookup key throughout processing and validation.



# Validation Standards

Every processed row validates against the standardized CoStar reference layer.

Validation includes:
- property alignment,
- competitive set alignment,
- capacity consistency,
- metadata integrity,
- ranking continuity,
- and index calculation stability.

This validation layer exists to prevent silent reporting drift across dashboards and downstream analytics.

Because benchmarking data has a remarkable ability to fail quietly right before someone screenshots it for ownership.



# Competitive Set Change Scenarios

## Scenario 1 — Set Reclassification

A hotel reorders an existing competitive set hierarchy.

Example:

```text
Set03 → Set01
```

This changes benchmark relationships and index interpretation.

Detection occurs through `cs_id` validation.



## Scenario 2 — Competitive Set Composition Change

The actual members of the competitive set change.

When this occurs:
- a new competitive set record is created,
- historical continuity is preserved,
- prior benchmark relationships remain intact,
- and reporting logic maintains separation between benchmark versions.

Benchmark history remains historically accurate rather than retroactively rewritten.



# Week Logic

Week structure follows hospitality reporting standards rather than ISO week standards.

- Week starts on Sunday
- Week 1 contains January 1
- Each Sunday increments the week number

This aligns reporting behavior with standard STR operational reporting.



# Warehouse Naming Standards

The CoStar reporting pipeline follows the REVREBEL warehouse naming framework.

| Object Type | Standard |
|---|---|
| Fact tables | `metrics_fact_*` |
| Views | `vw_metrics_*` |
| Snapshot tables | `snap_metrics_*` |
| Dimensions | `dim_*` |

Examples:

```text
metrics_fact_costar
vw_metrics_costar_daily
snap_metrics_costar
dim_property
dim_comp_set
```



# Data Pipeline Flow

```text
1. Ingest raw CoStar export
2. Normalize OCC / ADR / RevPAR tabs
3. Flatten into row-based structure
4. Apply competitive set segmentation
5. Expand LY, index, and ranking metrics
6. Validate against reference tables
7. Load into warehouse
```

The pipeline prioritizes:
- reproducibility,
- benchmark integrity,
- traceability,
- semantic consistency,
- and reporting stability.



# Common Failure Points

| Issue | Impact |
|---|---|
| Missing `property_code` | Property matching failure |
| Invalid `cs_id` | Benchmark corruption |
| Partial report tabs | Incomplete metric expansion |
| Null percentage changes | Invalid LY calculations |
| Week logic inconsistency | Reporting drift |
| Duplicate comp set rows | Ranking distortion |

These conditions are monitored because hospitality benchmarking data rarely fails loudly. It usually fails quietly and expensively.


