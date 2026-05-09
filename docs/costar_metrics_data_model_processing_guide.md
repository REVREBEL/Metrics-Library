This document defines the required schema, processing logic, and data handling standards for ingesting and transforming CoStar (STR) performance reports into the `metrics_fact_costar` dataset.

---

<br>
<br>


## CORE DATA FIELDS

### Property & Metadata Fields

| Field | Description |
|------|-------------|
| property_code | External lookup (preferred primary identifier) |
| property_name | External lookup |
| property_shortname | External lookup |
| census_id | External lookup |
| cs_id | External lookup (competitive set identifier) |
| cs_no | Set01 \| Set02 \| Set03 |
| cs_reference | External lookup |
| brand | External lookup |

---

### Calendar & Date Fields

| Field | Format / Logic |
|------|----------------|
| month | Full month name (e.g., January) |
| month_name | Prior year month name |
| cy | Current year (YYYY) |
| py | Prior year (YYYY) |
| weekday | Full weekday name (e.g., Monday) |
| weekday_py | Prior year weekday |
| week_no | Numeric week number |
| week_no_py | Prior year week number |
| dow | Day of week abbreviation (SUN–SAT) |
| day | Day with leading zero (01–31) |
| stay_date | YYYY-MM-DD (current year) |
| stay_date_py | YYYY-MM-DD (prior year) |
| no_days | Number of days represented |
| no_days_py | Prior year equivalent |

---

### Capacity & Derived Metrics

| Field | Formula |
|------|--------|
| available_rooms | External lookup |
| cs_available_rooms | External lookup |
| rms | ROUND(occ * (rooms_available / 100)) |
| rms_py | ROUND(occ_py * (rooms_available_py / 100)) |
| cs_rms | ROUND(cs_occ * (cs_rooms_available / 100)) |
| cs_rms_py | ROUND(cs_occ_py * (cs_rooms_available_py / 100)) |
| rev | rms * adr |
| rev_py | rms_py * adr_py |
| cs_rev | cs_rms * cs_adr |
| cs_rev_py | cs_rms_py * cs_adr_py |

---

<br>
<br>

## REQUIRED METRIC STRUCTURE

### Primary Metrics

```
metrics = occ | adr | revpar
```

### Source Data Mapping

| Metric | Source Tab |
|--------|------------|
| occ | Occ |
| adr | ADR |
| revpar | RevPAR |

---

<br>
<br>

## COMPETITIVE SET HANDLING

- Reports may contain multiple competitive sets
- Identified via suffix:

```
_1 | _2 | _3
```

Each competitive set must be:
- Processed independently
- Exported as a separate dataset
- Mapped to `cs_no` (Set01, Set02, Set03)

---

<br>
<br>

## METRIC EXPANSION LOGIC

### Base Pattern

```
{{metric}}
{{metric}}_py
cs_{{metric}}
cs_{{metric}}_py
industry_{{metric}}
industry_{{metric}}_py
```

### Prior Year Calculation
```
PY = TY / (1 + pct_chg)
```

### Percent Change Fields
```
{{metric}}_pct_chg
cs_{{metric}}_pct_chg
industry_{{metric}}_pct_chg
```

### Index Calculations
```
{{metric}}_index
{{metric}}_index_py
cs_{{metric}}_index
cs_{{metric}}_index_py
industry_{{metric}}_index
industry_{{metric}}_index_py
```

> Note: Index values typically represent relative performance vs comp set or industry.

### Ranking Fields
```
{{metric}}_rank
{{metric}}_pct_chg_rank
```

---

<br>
<br>


##  PROPERTY IDENTIFICATION LOGIC

To facilitate easier identification compared to the standard 3-6 digit STR ID, hotels can request a unique 6-character "property_code" be appended to the CoStar report filename.

<br>

### File Processing Logic

When processing the file, the system can identify the property and/r property_code using one of three fallback methods:

### 1. Primary (Preferred)

- Extract 6-character `property_code` from filename
- Example: `MSPHEH`

If the filename contains a 6-character property code (e.g., "MSPHEH"), it must be parsed and recorded as a global variable for that notebook session.

### 2. Secondary

- Extract STR ID

Secondary Method: If no property code is present, the STR ID should be parsed as an alternative lookup reference.
Tertiary Method: If neither code is available, the process should locate and use the hotel name. This ensures that the data team can successfully complete their initial tasks.

### 3. Tertiary

- Match using `property_name`

Once the property has been identified via one of these methods, the process can proceed to query the metrics_fact_costar table using the column references detailed below. This value is stored as a session-level variable and used throughout processing.

---

<br>
<br>

# DATA MANAGEMENT AND VALIDATION
This identifier, along with other critical metadata, is maintained in the metrics_fact_costar table. During the processing of CoStar data, this key must be verified against every response tab to ensure it aligns with the fact table. This alignment is essential for calculations that rely on the total room count within the current competitive set.

To simplify identification, each cs_id is mapped to a cs_no (e.g., Set01, Set02), allowing for easy reference within the dataset. It should also correspond with the the suffix identifier on each tab after the tab name.

## Potential Change Scenarios

There are two primary scenarios regarding competitive set adjustments:

** Scenario 1: Set Reclassification.  **

A hotel might move a tertiary set (Set03) to its primary position. This changes the benchmark comparisons for the initial CoStar report tabs (labeled "_1"). The system identifies this through cs_id validation.


** Scenario 2:  **

Component Modification. If a hotel alters the actual components of its competitive set, a new entry must be created in the metrics_fact_costar table to properly record and align the updated set.

When a match is found, the process will be able to match the row and pull the meta data for the required columns below.

---

<br>
<br>


## DATA VALIDATION REQUIREMENTS

- Every processed row must validate against `metrics_fact_costar`
- Ensure:
  - `cs_id` matches expected competitive set
  - Property metadata aligns with fact table
  - Room counts match for comp set calculations

> This is critical for accurate index and ranking calculations.

---

<br>
<br>

## COMPETITIVE SET CHANGE SCENARIOS

### Scenario 1: Set Reclassification

- Example: Set03 becomes Set01
- Impact: Benchmark shifts
- Detection: Change in `cs_id`

### Scenario 2: Component Modification

- Competitive set composition changes
- Action required:
  - Insert new record in `metrics_fact_costar`
  - Maintain historical continuity

---

<br>
<br>

## METADATA ENRICHMENT FIELDS

Once property + comp set match is confirmed, enrich with:

- property_code
- property_name
- property_shortname
- brand
- cs_id
- cs_no
- cs_reference
- physical_capacity
- cs_physical_capacity
- rms / rms_py
- cs_rms / cs_rms_py
- rev

---

<br>
<br>

## COMPETITIVE SET ID DEFINITION

```
cs_id = STR IDs concatenated with hyphens
```

![alt](https://raw.githubusercontent.com/REVREBEL/Metrics-Library/main/assets/creating-the-unique-cs-id.png)


Example:
```
65206-54429-55653-44555-56751-39388
```

> This uniquely defines the comp set composition.

---

<br>
<br>


## WEEK NUMBER LOGIC

- Week Starts: Sunday
- Week 1: Contains January 1
- Increment: Each Sunday increases week number

> Note: This differs from ISO week standards (Monday-based).

---

<br>
<br>

## TABLE SCHEMA

metrics_fact_costar

| Field | Type | Description |
|------|------|-------------|
| index | INTEGER | Sequential identifier |
| property_code | STRING | Property identifier |
| census_id | INTEGER | Census identifier |
| cs_no | STRING | Comp set label |
| cs_reference | STRING | Comp set reference |
| chain_id | STRING | Hotel chain identifier |
| property_name | STRING | Property name |
| brand | STRING | Brand classification |
| city | STRING | City |
| state | STRING | State |
| country | STRING | Country |
| available_rms | INTEGER | Available rooms |
| open_date | INTEGER | Opening date |
| cs_type | STRING | Comp set type |
| cs_owner | STRING | Comp set owner |
| compliance_status | STRING | Compliance status |
| delete_on_date | INTEGER | Deletion marker |
| cs_status | STRING | Comp set status |
| cs_census_id | INTEGER | Comp set census ID |
| cs_property_name | STRING | Comp set property |
| cs_brand | STRING | Comp set brand |
| cs_city | STRING | Comp set city |
| cs_state | STRING | Comp set state |
| cs_country | STRING | Comp set country |
| cs_rms | INTEGER | Comp set rooms |
| cs_open_date | INTEGER | Comp set open date |
| creation_date | INTEGER | Record creation date |
| legacy_position | INTEGER | Historical position |
| cs_available_rms | INTEGER | Comp set available rooms |

---

<br>
<br>

##  ADDITIONAL IMPLEMENTATION NOTES

### A. Recommended Naming Conventions

- Fact table: `metrics_fact_costar`
- Derived views: `vw_metrics_*`
- Snapshot tables: `snap_metrics_*`
- Dimensions: `dim_property`, `dim_comp_set`

---

### B. Minimum Required Base Metrics (Best Practice)

To ensure reproducibility of all calculations, always store:

- rooms_available
- rooms_sold (derived from RMS if needed)
- room_revenue

This allows recompilation of:
- Occupancy
- ADR
- RevPAR
- Index values
- YoY comparisons

---

### C. Data Pipeline Guidance

Recommended flow:

1. Ingest raw Excel
2. Normalize tabs (Occ / ADR / RevPAR)
3. Flatten into row-based structure
4. Apply comp set segmentation
5. Calculate PY + index metrics
6. Validate against fact table
7. Load into BigQuery

---

### D. Common Failure Points

- Missing property_code in filename
- Misaligned comp set (`cs_id` mismatch)
- Incorrect PY calculation when pct_chg is null
- Week number inconsistencies
- Duplicate rows across comp sets

---
