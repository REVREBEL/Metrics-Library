

<br>
<br>

## CORE DIMENSION & DERIVED FIELDS

| Field | Description | Notes |
|---|---|---|
| property_code | External lookup | Primary unique identifier (preferred over STR ID) |
| property_name | External lookup | |
| property_shortname | External lookup | |
| census_id | External lookup | |
| cs_id | External lookup | Competitive set identifier |
| cs_no | `Set01`, `Set02`, or `Set03` | Logical grouping label |
| cs_reference | External lookup | |
| brand | External lookup | Independent / Soft Brand / Chain |
| month | Full month name (January–December) | Current year |
| month_name | Full month name | Prior year |
| cy | Current year (YYYY) | Example: 2026 |
| py | Prior year (YYYY) | Example: 2025 |
| weekday | Full weekday name | Current year |
| weekday_py | Full weekday name | Prior year |
| week_no | Numeric week number | See week logic below |
| week_no_py | Numeric week number | Prior year |
| dow | Day of week (SUN–SAT) | |
| day | Day with leading zero (01–31) | |
| stay_date | Date (YYYY-MM-DD) | Current year |
| stay_date_py | Date (YYYY-MM-DD) | Prior year |
| no_days | Number of days represented | |
| no_days_py | Number of days represented | |
| physical_capacity | External lookup | Hotel rooms available |
| cs_physical_capacity | External lookup | Comp set rooms available |

---

<br>
<br>

## KNOWN RISKS & EDGE CASES

- Missing property_code in filename
- Incorrect STR ID formatting
- Competitive set changes mid-period
- Partial data across tabs
- Percent change = -100% (division issues)

### Suggested Safeguards

- Null handling for PY calculations
- Logging for unmatched properties
- Versioning comp sets

---


