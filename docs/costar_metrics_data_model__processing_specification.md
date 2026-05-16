# CoStar Metrics Processing Specification

## REVREBEL Metrics Library & Analytics Warehouse

This document defines the dimensional structure, benchmark relationships, derived field logic, and processing safeguards used throughout the REVREBEL CoStar reporting framework.

The purpose of this specification is to preserve consistency across benchmarking, competitive-set analysis, reporting logic, and downstream analytics.

CoStar reporting is not transactional operational data.

It is a structured benchmarking layer designed to measure market-relative performance over time.

That distinction drives how the warehouse models, validates, and processes the dataset.



# Benchmarking Data Context

STAR reporting evaluates hotel performance relative to a competitive market rather than in isolation.

The dataset combines:
- property-level metrics,
- competitive-set benchmarks,
- historical comparison periods,
- ranking behavior,
- and index calculations.

Because of this, the warehouse prioritizes:
- benchmark continuity,
- snapshot consistency,
- competitive-set integrity,
- and historical comparability.

The structure exists to preserve how the market behaved at a specific point in time — not simply how the hotel performed operationally.


## Processing Flow

```text
1. Ingest raw CoStar export
2. Normalize OCC / ADR / RevPAR tabs
3. Flatten into row-based structure
4. Apply competitive set segmentation
5. Expand LY, index, and ranking metrics
6. Validate against reference tables
7. Load into warehouse
```


# Core Dimension & Derived Fields

## Property & Benchmark Metadata

| Field | Description | Notes |
|---|---|---|
| `property_code` | Standardized property identifier | Preferred primary identifier |
| `property_name` | Standardized property name | |
| `property_shortname` | Operational short name | |
| `str_id` | STR / CoStar identifier | |
| `cs_id` | Competitive set identifier | Defines benchmark composition |
| `cs_no` | Competitive set grouping | `Set01`, `Set02`, `Set03` |
| `cs_reference` | External benchmark reference | |
| `brand` | Brand classification | Independent / Soft Brand / Chain |



## Calendar & Reporting Fields

| Field | Description | Notes |
|---|---|---|
| `month` | Full month name | Current-year context |
| `month_name` | Full month name | Prior-year context |
| `cy` | Current year | `YYYY` |
| `ly` | Prior year | `YYYY` |
| `weekday` | Full weekday name | Current-year context |
| `weekday_ly` | Full weekday name | Prior-year context |
| `week_no` | Hospitality week number | See week logic |
| `week_no_ly` | Prior-year week number | |
| `dow` | Day-of-week abbreviation | `SUN–SAT` |
| `day` | Day with leading zero | `01–31` |
| `date` | Reporting date | `YYYY-MM-DD` |
| `date_ly` | Prior-year reporting date | |
| `no_days` | Represented days | |
| `no_days_ly` | Prior-year represented days | |



## Capacity & Inventory Fields

| Field | Description |
|---|---|
| `available_rms` | Property available room inventory |
| `cs_available_rms` | Competitive-set available room inventory |
| `physical_capacity` | Property physical capacity |
| `cs_physical_capacity` | Competitive-set physical capacity |

These fields support occupancy calculations, benchmark alignment, and derived revenue metrics.



# Competitive Set Structure

Competitive sets are treated as independent benchmark contexts.

Each comp set preserves:
- historical continuity,
- ranking relationships,
- market positioning,
- and benchmark integrity.

Suffix identifiers:

```text
_1
_2
_3
```


Map internally as:

```text
Set01
Set02
Set03
```

The warehouse intentionally separates comp-set contexts rather than flattening them into a single benchmark layer.

**Changing the benchmark changes the meaning of the data.**



# Derived Metric Logic

Derived metrics preserve standardized hospitality reporting calculations.

## Room Production

```text
rms = ROUND(occ * (available_rms / 100))
```

## Revenue Production

```text
rev = rms * adr
```

## Competitive Set Revenue

```text
cs_rev = cs_rms * cs_adr
```

These calculations maintain reproducibility across:
- occupancy,
- ADR,
- RevPAR,
- benchmark indexes,
- and historical comparisons.


# Week Logic

Week calculations follow hospitality reporting standards rather than ISO standards.

- Week starts on Sunday
- Week 1 contains January 1
- Each Sunday increments the week number

This aligns warehouse reporting behavior with standard STR operational reporting.



# Benchmark Integrity Standards

The warehouse structure preserves competitive-set continuity historically.

Competitive sets evolve over time:
- properties enter or exit,
- benchmark positioning changes,
- and reporting relationships shift.

Rather than overwriting historical relationships, the warehouse maintains benchmark separation across reporting periods.

This preserves:
- historical index accuracy,
- prior ranking logic,
- and market-relative reporting continuity.

**Benchmark history should remain historically accurate — not retroactively normalized.**



# Operational Risk Conditions

The processing framework monitors several known hospitality benchmarking edge cases.

## Known Risk Conditions

- Missing `property_code` in filenames
- Invalid STR / CoStar identifiers
- Competitive-set composition changes
- Partial tab-level report exports
- Division edge cases from `-100%` percent-change calculations
- Duplicate benchmark rows
- Week-number inconsistencies

These conditions are monitored because hospitality benchmarking data tends to fail quietly rather than obviously and quiet failures usually become expensive reporting conversations later.



# Processing Safeguards

The warehouse processing framework preserves benchmark integrity through:

- standardized property matching,
- comp-set validation,
- null-safe prior-year calculations,
- benchmark version continuity,
- ingestion logging,
- and reporting-layer validation.

**The objective is reporting stability across dashboards, forecasts, automation workflows, and downstream analytics.**



# Warehouse Design Philosophy

The REVREBEL warehouse treats benchmarking data as a strategic intelligence layer rather than a transactional export.

The structure is intentionally designed so:
- schemas remain predictable,
- benchmark relationships remain traceable,
- competitive positioning remains historically accurate,
- and downstream systems can interpret market behavior consistently.

The goal is not simply storing STAR reports.

**The goal is preserving the competitive story the data is trying to tell.**



