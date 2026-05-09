"""
REVREBEL Metrics Library column standardization helpers.

Use this module inside ingestion notebooks before loading dataframes to BigQuery.

Purpose:
- normalize raw source headers into safe snake_case
- rename known source columns to REVREBEL standard names
- add required ingestion metadata columns
- print before/after column mapping reports
- keep source-specific mapping logic out of one-off notebooks

Example:

    from revrebel_column_standardizer import standardize_dataframe, print_column_report

    df_standardized = standardize_dataframe(
        df,
        source_report="snap_pace_segment",
        metadata={
            "property_code": "DTWDFH",
            "source_system": "Duetto",
            "source_file": file_path.name,
        }
    )

    print_column_report(df, df_standardized, source_report="snap_pace_segment")
"""

from __future__ import annotations

import re
from datetime import datetime, timezone
from typing import Any, Dict, Mapping, Optional

import pandas as pd


def normalize_header(value: Any) -> str:
    """Convert a source column header into lowercase snake_case."""
    text = str(value or "").strip().lower()
    text = re.sub(r"[^a-z0-9]+", "_", text)
    text = re.sub(r"_+", "_", text).strip("_")
    return text


# Shared source-column to standard-column mappings.
# Keys should already be normalized through normalize_header().
COMMON_COLUMN_MAP: Dict[str, str] = {
    # Dates / metadata
    "snapshot_date": "snap_date",
    "stay_date": "date",
    "business_date": "date",
    "arrival_date": "arrival_date",
    "departure_date": "departure_date",
    "etl_date": "etl_date",

    # Property
    "hotel": "property_name",
    "hotel_name": "property_name",
    "property": "property_name",
    "property_id": "property_code",

    # Rooms / revenue / pace
    "rooms": "rms",
    "room_nights": "rms",
    "room_nights_sold": "rms",
    "rooms_sold": "rms",
    "rooms_otb": "rms_otb",
    "rooms_on_the_books": "rms_otb",
    "revenue_otb": "rev_otb",
    "rev_otb": "rev_otb",
    "rooms_stly": "rms_stly",
    "rev_stly": "rev_stly",
    "rooms_st2y": "rms_st2y",
    "rev_st2y": "rev_st2y",
    "rooms_st3y": "rms_st3y",
    "rev_st3y": "rev_st3y",
    "rooms_st4y": "rms_st4y",
    "rev_st4y": "rev_st4y",
    "rooms_ly_actual": "rms_ly",
    "rev_ly_actual": "rev_ly",
    "rooms_forecast": "rms_fct",
    "rev_forecast": "rev_fct",
    "rooms_budget": "rms_bgt",
    "rev_budget": "rev_bgt",
    "available_rooms": "available_rms",
    "available_rooms_ly": "available_rms_ly",

    # Cancellations / no-shows / OOO
    "cancelled_rooms": "cx_rms",
    "cancelled_rooms_ly_actual": "cx_rms_ly",
    "canceled_rooms": "cx_rms",
    "canceled_rooms_ly_actual": "cx_rms_ly",
    "noshow_rooms": "ns_rms",
    "no_show_rooms": "ns_rms",
    "noshow_rooms_ly_actual": "ns_rms_ly",
    "no_show_rooms_ly_actual": "ns_rms_ly",
    "ooo_rooms": "ooo_rms",
    "out_of_order_rooms": "ooo_rms",

    # Demand / compset
    "compset_rooms_sold": "cs_rms_sold",
    "compset_no": "cs_no",
    "compset_occ": "cs_occ",
    "compset_adr": "cs_adr",
    "compset_occ_yoy": "cs_occ_yoy",
    "compset_adr_yoy": "cs_adr_yoy",
    "property_adr": "adr",
    "property_occ_yoy": "occ_yoy",
    "property_adr_yoy": "adr_yoy",
    "occ_index_vs_prior_year_pct": "occ_index_pct_chg_ly",
    "occ_index_chg_vs_prior_week_pct": "occ_index_pct_chg_lw",
    "room_nights_current_my_hotel_totals": "rms",
    "room_nights_chg_from_last_wk_my_hotel_totals": "rms_chg_lw",
    "room_nights_var_pct_to_last_yr_my_hotel_totals": "rms_pct_chg_ly",
    "room_nights_var_pct_to_last_yr_market_excl_totals": "market_excl_rms_pct_chg_ly",
    "room_nights_chg_pct_from_last_wk_my_hotel_totals": "rms_pct_chg_lw",
    "room_nights_chg_pct_from_last_wk_market_excl_totals": "market_excl_rms_pct_chg_lw",

    # Segment / source / channel
    "market_code": "segment_code",
    "market_segment": "market_segment",
    "detail": "segment_detail",
    "booking_source": "source",
    "source_name": "source",

    # Room type
    "room_type": "roomtype",
    "room_type_code": "roomtype_code",
    "room_class": "roomclass",
    "room_class_code": "roomclass_code",
    "bed_type": "bedtype",
    "bed_type_code": "bedtype_code",
    "room_feature": "roomfeature",
    "room_pool": "roompool",
    "room_pool_code": "roompool_code",

    # Pricing
    "shop_date": "shop_date",
    "check_in": "date",
    "checkin": "date",
    "staydate": "date",
    "length_of_stay": "los",
    "los": "los",
    "guests": "guest_count",
    "adults": "adult_count",
    "children": "child_count",
    "channel": "shop_channel",
    "ota": "shop_channel",
    "price": "price_amt",
    "rate": "price_amt",
    "currency": "currency_code",
    "rate_plan": "rate_plan",
    "rate_plan_code": "rate_plan_code",
    "cancel_policy": "cancel_policy",
    "cancellation_policy": "cancel_policy",
    "refundable": "is_refundable",
    "sold_out": "is_soldout",
    "available": "is_available",
}


REPORT_COLUMN_MAPS: Dict[str, Dict[str, str]] = {
    "snap_pace_segment": {
        **COMMON_COLUMN_MAP,
        "today_rooms_commit": "rms_otb",
        "today_room_revenue_commit": "rev_otb",
        "stly_date_rooms_commit": "rms_stly",
        "stly_date_room_revenue_commit": "rev_stly",
        "st2y_date_rooms_commit": "rms_st2y",
        "st2y_date_room_revenue_commit": "rev_st2y",
    },
    "snap_pace_roomtype": {
        **COMMON_COLUMN_MAP,
        "room_type": "roomtype",
        "room_type_code": "roomtype_code",
        "physical_capacity": "available_rms",
    },
    "snap_property": {
        **COMMON_COLUMN_MAP,
        "total_demand_total": "demand_total",
        "total_demand_total_ly_actual": "demand_total_ly",
        "group_demand_total": "demand_group",
        "group_demand_total_ly_actual": "demand_group_ly",
        "transient_demand_total": "demand_transient",
        "transient_demand_total_ly_actual": "demand_transient_ly",
        "wash_pct_ly_actual": "wash_pct_ly",
    },
    "snap_demand_property": COMMON_COLUMN_MAP,
    "snap_demand_segment": COMMON_COLUMN_MAP,
    "snap_demand_channel": {
        **COMMON_COLUMN_MAP,
        "booking_source": "source",
    },
    "bookingdotcom_bar": {
        **COMMON_COLUMN_MAP,
        "hotel_name": "property_name",
        "room_name": "roomtype_map",
        "price": "price_amt",
        "bar": "price_amt",
    },
    "bookingdotcom_lowest": {
        **COMMON_COLUMN_MAP,
        "hotel_name": "property_name",
        "room_name": "roomtype_map",
        "price": "price_amt",
        "lowest": "price_amt",
    },
}


def build_rename_map(
    columns: list[Any],
    source_report: Optional[str] = None,
    extra_map: Optional[Mapping[str, str]] = None,
) -> Dict[str, str]:
    """Build the actual rename map for a list of source columns."""
    normalized_columns = [normalize_header(col) for col in columns]

    rename_map: Dict[str, str] = dict(COMMON_COLUMN_MAP)
    if source_report and source_report in REPORT_COLUMN_MAPS:
        rename_map.update(REPORT_COLUMN_MAPS[source_report])
    if extra_map:
        rename_map.update({normalize_header(k): v for k, v in extra_map.items()})

    return {
        source_col: rename_map[source_col]
        for source_col in normalized_columns
        if source_col in rename_map
    }


def get_column_report(
    df: pd.DataFrame,
    source_report: Optional[str] = None,
    extra_map: Optional[Mapping[str, str]] = None,
) -> pd.DataFrame:
    """Return a before/after column-standardization report."""
    original_columns = list(df.columns)
    normalized_columns = [normalize_header(col) for col in original_columns]
    rename_map = build_rename_map(original_columns, source_report=source_report, extra_map=extra_map)

    rows = []
    for original_col, normalized_col in zip(original_columns, normalized_columns):
        standard_col = rename_map.get(normalized_col, normalized_col)
        rows.append(
            {
                "original_column": original_col,
                "normalized_column": normalized_col,
                "standard_column": standard_col,
                "changed": standard_col != normalized_col,
            }
        )

    return pd.DataFrame(rows)


def print_column_report(
    df: pd.DataFrame,
    source_report: Optional[str] = None,
    extra_map: Optional[Mapping[str, str]] = None,
) -> None:
    """Print the before/after column-standardization report."""
    report = get_column_report(df, source_report=source_report, extra_map=extra_map)
    print(report.to_string(index=False))


def standardize_columns(
    df: pd.DataFrame,
    source_report: Optional[str] = None,
    extra_map: Optional[Mapping[str, str]] = None,
) -> pd.DataFrame:
    """Normalize and rename dataframe columns using REVREBEL standards."""
    output = df.copy()
    output.columns = [normalize_header(col) for col in output.columns]

    rename_map = build_rename_map(list(df.columns), source_report=source_report, extra_map=extra_map)
    return output.rename(columns=rename_map)


def add_ingestion_metadata(
    df: pd.DataFrame,
    metadata: Optional[Mapping[str, Any]] = None,
) -> pd.DataFrame:
    """Add standard ingestion metadata columns without overwriting existing populated values."""
    output = df.copy()
    metadata = dict(metadata or {})

    defaults: Dict[str, Any] = {
        "load_ts": datetime.now(timezone.utc),
        "insert_date": pd.Timestamp.utcnow().date(),
    }
    defaults.update(metadata)

    for column, value in defaults.items():
        if column not in output.columns:
            output[column] = value
        else:
            output[column] = output[column].fillna(value)

    return output


def standardize_dataframe(
    df: pd.DataFrame,
    source_report: Optional[str] = None,
    metadata: Optional[Mapping[str, Any]] = None,
    extra_map: Optional[Mapping[str, str]] = None,
    print_report: bool = False,
) -> pd.DataFrame:
    """Apply column normalization, standard naming, and ingestion metadata."""
    if print_report:
        print_column_report(df, source_report=source_report, extra_map=extra_map)

    output = standardize_columns(df, source_report=source_report, extra_map=extra_map)
    output = add_ingestion_metadata(output, metadata=metadata)
    return output
