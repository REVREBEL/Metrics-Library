# Source Application Lookup Model

## Standard naming

All mapping tables use one canonical foreign-key column:

```text
source_application_code
```

Do not use `source_system`, `system`, or `source_system_category` as alternate mapping-table field names.

## Lookup hierarchy

```text
mapping_table.source_application_code
  -> metrics_core.lkp_source_application.code
  -> metrics_core.lkp_source_system_type.code
```

- `lkp_source_application` identifies the exact application that produced the value, such as IDeaS, OPERA, or SynXis.
- `lkp_source_system_type` identifies the broader application type, such as RMS, PMS, or CRS.

## Lookup tables

### `metrics_core.lkp_source_system_type`

| Column | Purpose |
|---|---|
| `code` | Standard broad type code. |
| `name` | Display name. |
| `description` | Definition and usage notes. |
| `sort` | Display order. |
| `is_active` | Active flag. |
| `insert_date` | Insert date. |
| `updated_date` | Updated date. |

### `metrics_core.lkp_source_application`

| Column | Purpose |
|---|---|
| `code` | Standard granular source application code. |
| `name` | Application display name. |
| `short_name` | Short application name. |
| `description` | Definition and usage notes. |
| `sort` | Display order. |
| `source_system_type_code` | Joins to `lkp_source_system_type.code`. |
| `vendor` | Application vendor or provider. |
| `is_active` | Active flag. |
| `insert_date` | Insert date. |
| `updated_date` | Updated date. |

## Mapping-table relationships

| Mapping table | Source application field | Lookup target |
|---|---|---|
| `map_segment` | `source_application_code` | `lkp_source_application.code` |
| `map_channel` | `source_application_code` | `lkp_source_application.code` |
| `map_roomtype` | `source_application_code` | `lkp_source_application.code` |
| `map_source` | `source_application_code` | `lkp_source_application.code` |
| `map_market` | `source_application_code` | `lkp_source_application.code` |
| `map_rate` | `source_application_code` | `lkp_source_application.code` |
| `map_agency` | `source_application_code` | `lkp_source_application.code` |

## `map_hotel` exception

`map_hotel` does not use `source_application_code`. It resolves property identifiers to `dim_property` and does not require source-application classification.

## Agent-readable contract

```yaml
source_application_standard:
  canonical_mapping_field: source_application_code
  granular_lookup: metrics_core.lkp_source_application
  broad_lookup: metrics_core.lkp_source_system_type
  relationships:
    - from: mapping_table.source_application_code
      to: metrics_core.lkp_source_application.code
    - from: metrics_core.lkp_source_application.source_system_type_code
      to: metrics_core.lkp_source_system_type.code
  prohibited_mapping_field_names:
    - source_system
    - system
    - source_system_category
  exception:
    table: metrics_core.map_hotel
    source_application_required: false
```
