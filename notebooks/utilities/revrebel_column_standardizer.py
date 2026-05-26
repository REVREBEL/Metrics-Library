"""
REVREBEL Metrics Library column standardization helpers.

Use this module inside ingestion/processing notebooks before exporting
standardized CSVs or loading dataframes to BigQuery.

Current date standards:
- stay_date: property stay / occupancy / service date the metrics apply to
- snap_date: point-in-time report or snapshot date
- arrival_date: reservation arrival/check-in date
- departure_date: reservation departure/check-out date
- book_date: reservation booking / creation date
- insert_date: row creation / ingestion date
- updated_date: row update date

Purpose:
- normalize raw source headers into safe snake_case
- rename known source columns to REVREBEL standard names
- add required ingestion metadata columns
- align IDeaS pace exports to the revised Dataform staging schemas
- print before/after column mapping reports
- keep source-specific mapping logic out of one-off notebooks

Important:
- Business View exports are treated as the segment grain.
- This module does not load data to BigQuery.
- This module does not perform lookup enrichment for segment, roomclass, or roomtype.
  It only creates the required staging columns and leaves unmapped/enrichment fields
  as null placeholders unless the source already provides them.
"""

from __future__ import annotations

import re
from datetime import datetime, timezone
from typing import Any, Dict, Iterable, Mapping, Optional

import pandas as pd


def normalize_header(value: Any) -> str:
    """Convert a source column header into lowercase snake_case."""
    text = str(value or "").strip().lower()
    text = re.sub(r"[^a-z0-9]+", "_", text)
    text = re.sub(r"_+", "_", text).strip("_")
    return text


COMMON_COLUMN_MAP: Dict[str, str] = {
    # Date roles
    "date": "stay_date",
    "day": "stay_date",
    "stay_date": "stay_date",
    "staydate": "stay_date",
    "occupancy_date": "stay_date",
    "business_date": "stay_date",
    "service_date": "stay_date",
    "snapshot_date": "snap_date",
    "snap_date": "snap_date",
    "comparison_date_last_year": "comparison_date_ly",
    "comparison_date_ly": "comparison_date_ly",
    "arrival_date": "arrival_date",
    "check_in": "arrival_date",
    "check_in_date": "arrival_date",
    "checkin": "arrival_date",
    "checkin_date": "arrival_date",
    "departure_date": "departure_date",
    "check_out_date": "departure_date",
    "checkout_date": "departure_date",
    "booking_date": "book_date",
    "book_date": "book_date",
    "created_date": "insert_date",
    "inserted_date": "insert_date",
    "insert_date": "insert_date",
    "updated_date": "updated_date",
    "etl_date": "etl_date",
    "day_of_week": "day_of_week",

    # Property
    "hotel": "property_name",
    "hotel_name": "property_name",
    "property": "property_name",
    "property_name": "property_name",
    "property_id": "property_code",
    "property_code": "property_code",

    # Base rooms / inventory
    "rooms": "rms",
    "room_nights": "rms",
    "room_nights_sold": "rms",
    "rooms_sold": "rms",
    "available_rooms": "available_rms",
    "available_rooms_ly": "available_rms_ly",
    "physical_capacity": "available_rms",
    "physical_capacity_this_year": "available_rms",
    "physical_capacity_last_year_actual": "available_rms_ly",
    "capacity_this_year": "available_rms",
    "capacity_last_year_actual": "available_rms_ly",
    "remaining_capacity_this_year": "remaining_rms",
    "remaining_capacity_last_year_actual": "remaining_rms_ly",

    # OTB / pace rooms
    "rooms_otb": "rms_otb",
    "rooms_on_the_books": "rms_otb",
    "occupancy_on_books_this_year": "rms_otb",
    "occupancy_on_books_last_year_actual": "rms_ly",
    "occupancy_on_books_stly": "rms_stly",
    "occupancy_on_books_st2y": "rms_st2y",
    "rooms_ly_actual": "rms_ly",
    "rooms_stly": "rms_stly",
    "rooms_st2y": "rms_st2y",
    "rooms_st3y": "rms_st3y",
    "rooms_st4y": "rms_st4y",

    # Property-level group/transient rooms
    "rooms_sold_group_this_year": "group_rms_otb",
    "rooms_sold_group_last_year_actual": "group_rms_ly",
    "rooms_sold_group_stly": "group_rms_stly",
    "rooms_sold_group_st2y": "group_rms_st2y",
    "rooms_sold_transient_this_year": "transient_rms_otb",
    "rooms_sold_transient_last_year_actual": "transient_rms_ly",
    "rooms_sold_transient_stly": "transient_rms_stly",
    "rooms_sold_transient_st2y": "transient_rms_st2y",

    # Revenue
    "revenue": "rev",
    "room_revenue": "rev",
    "revenue_otb": "rev_otb",
    "rev_otb": "rev_otb",
    "booked_room_revenue_this_year": "rev_otb",
    "booked_room_revenue_last_year_actual": "rev_ly",
    "booked_room_revenue_stly": "rev_stly",
    "booked_room_revenue_st2y": "rev_st2y",
    "rev_ly_actual": "rev_ly",
    "rev_stly": "rev_stly",
    "rev_st2y": "rev_st2y",
    "rev_st3y": "rev_st3y",
    "rev_st4y": "rev_st4y",
    "forecasted_room_revenue_this_year": "rev_fct",
    "forecasted_room_revenue_last_year_actual": "rev_fct_ly",
    "property_forecast_revenue_this_year": "property_rev_fct",
    "property_forecast_revenue_last_year_actual": "property_rev_fct_ly",
    "budget_room_revenue_this_year": "rev_bgt",
    "budget_room_revenue_last_year_actual": "rev_bgt_ly",
    "budget_revenue_this_year": "rev_bgt",
    "budget_revenue_last_year_actual": "rev_bgt_ly",
    "rev_forecast": "rev_fct",
    "rev_budget": "rev_bgt",

    # Forecast / budget rooms
    "rooms_forecast": "rms_fct",
    "rooms_budget": "rms_bgt",
    "occupancy_forecast_total_this_year": "rms_fct",
    "occupancy_forecast_total_last_year_actual": "rms_fct_ly",
    "occupancy_forecast_this_year": "rms_fct",
    "occupancy_forecast_last_year_actual": "rms_fct_ly",
    "property_forecast_occupancy_total_this_year": "property_rms_fct",
    "property_forecast_occupancy_total_last_year_actual": "property_rms_fct_ly",
    "budget_occupancy_total_this_year": "rms_bgt",
    "budget_occupancy_total_last_year_actual": "rms_bgt_ly",
    "occupancy_forecast_group_this_year": "group_rms_fct",
    "occupancy_forecast_group_last_year_actual": "group_rms_fct_ly",
    "occupancy_forecast_transient_this_year": "transient_rms_fct",
    "occupancy_forecast_transient_last_year_actual": "transient_rms_fct_ly",

    # User projected forecast values from IDeaS forecast-group / roomclass style exports
    "user_projected_occupancy_this_year": "user_rms_fct",
    "user_projected_occupancy_last_year_actual": "user_rms_fct_ly",
    "user_projected_revenue_this_year": "user_rev_fct",
    "user_projected_revenue_last_year_actual": "user_rev_fct_ly",
    "user_projected_adr_this_year": "user_adr_fct",
    "user_projected_adr_last_year_actual": "user_adr_fct_ly",

    # Demand
    "system_total_demand_total_this_year": "system_demand_total",
    "system_total_demand_total_last_year_actual": "system_demand_total_ly",
    "system_total_demand_group_this_year": "system_demand_group",
    "system_total_demand_group_last_year_actual": "system_demand_group_ly",
    "system_total_demand_transient_this_year": "system_demand_transient",
    "system_total_demand_transient_last_year_actual": "system_demand_transient_ly",
    "system_unconstrained_demand_this_year": "system_unconstrained_demand",
    "system_unconstrained_demand_last_year_actual": "system_unconstrained_demand_ly",
    "user_total_demand_total_this_year": "user_demand_total",
    "user_total_demand_total_last_year_actual": "user_demand_total_ly",
    "user_demand_this_year": "user_demand",
    "user_demand_last_year_actual": "user_demand_ly",
    "user_constrained_total_demand_group_this_year": "user_constrained_demand_group",
    "user_constrained_total_demand_group_last_year_actual": "user_constrained_demand_group_ly",
    "user_unconstrained_total_demand_transient_this_year": "user_unconstrained_demand_transient",
    "user_unconstrained_total_demand_transient_last_year_actual": "user_unconstrained_demand_transient_ly",
    "total_demand_total": "demand_total",
    "total_demand_total_ly_actual": "demand_total_ly",
    "group_demand_total": "demand_group",
    "group_demand_total_ly_actual": "demand_group_ly",
    "transient_demand_total": "demand_transient",
    "transient_demand_total_ly_actual": "demand_transient_ly",

    # Wash / LRV / BAR
    "last_room_value_this_year": "lrv",
    "last_room_value_last_year_actual": "lrv_ly",
    "wash_this_year": "wash_pct",
    "wash_last_year_actual": "wash_pct_ly",
    "wash_pct_ly_actual": "wash_pct_ly",
    "system_wash_this_year": "system_wash_pct",
    "system_wash_last_year_actual": "system_wash_pct_ly",
    "user_wash_this_year": "user_wash_pct",
    "user_wash_last_year_actual": "user_wash_pct_ly",
    "bar": "bar_price",
    "bar_this_year": "bar_price",
    "bar_last_year_actual": "bar_price_ly",

    # Arrivals / departures / cancellations / no-shows / OOO
    "arrivals_this_year": "arrival_rms",
    "arrivals_last_year_actual": "arrival_rms_ly",
    "departures_this_year": "departure_rms",
    "departures_last_year_actual": "departure_rms_ly",
    "cancelled_this_year": "cx_rms",
    "cancelled_last_year_actual": "cx_rms_ly",
    "cancelled_rooms": "cx_rms",
    "cancelled_rooms_ly_actual": "cx_rms_ly",
    "canceled_rooms": "cx_rms",
    "canceled_rooms_ly_actual": "cx_rms_ly",
    "no_show_this_year": "ns_rms",
    "no_show_last_year_actual": "ns_rms_ly",
    "noshow_rooms": "ns_rms",
    "no_show_rooms": "ns_rms",
    "noshow_rooms_ly_actual": "ns_rms_ly",
    "no_show_rooms_ly_actual": "ns_rms_ly",
    "rooms_n_a_out_of_order_this_year": "ooo_rms",
    "rooms_n_a_out_of_order_last_year_actual": "ooo_rms_ly",
    "rooms_n_a_other_this_year": "na_other_rms",
    "rooms_n_a_other_last_year_actual": "na_other_rms_ly",
    "ooo_rooms": "ooo_rms",
    "out_of_order_rooms": "ooo_rms",
    "overbooking_this_year": "overbook_rms",
    "overbooking_last_year_actual": "overbook_rms_ly",

    # Calculated/source rate metrics
    "adr_on_books_this_year": "adr_otb",
    "adr_on_books_last_year_actual": "adr_ly",
    "adr_forecast_this_year": "adr_fct",
    "adr_forecast_last_year_actual": "adr_fct_ly",
    "revpar_on_books_this_year": "revpar_otb",
    "revpar_on_books_last_year_actual": "revpar_ly",
    "revpar_forecast_this_year": "revpar_fct",
    "revpar_forecast_last_year_actual": "revpar_fct_ly",

    # Events - source-of-truth should ultimately live in dim_event / bridge_property_event_date.
    "special_event_this_year": "primary_event",
    "special_event_last_year_actual": "primary_event_ly",

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
    "business_view": "segment",
    "forecast_group": "segment",
    "market_code": "segment_code",
    "market_segment": "market_segment",
    "detail": "segment_detail",
    "booking_source": "source",
    "source_name": "source",

    # Room type / room class
    "room_type": "roomtype",
    "roomtype": "roomtype",
    "room_type_code": "roomtype_code",
    "room_class": "roomclass",
    "roomclass": "roomclass",
    "room_class_code": "roomclass_code",
    "bed_type": "bedtype",
    "bed_type_code": "bedtype_code",
    "room_feature": "roomfeature",
    "room_pool": "roompool",
    "room_pool_code": "roompool_code",

    # Pricing
    "shop_date": "shop_date",
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
    # Revised pace staging/snapshot report names.
    "stg_pace_property": {**COMMON_COLUMN_MAP},
    "snap_pace_property": {**COMMON_COLUMN_MAP},
    "fact_pace_property": {**COMMON_COLUMN_MAP},  # legacy notebook alias
    "snap_property": {**COMMON_COLUMN_MAP},  # legacy notebook alias
    "property": {**COMMON_COLUMN_MAP},

    "stg_pace_segment": {
        **COMMON_COLUMN_MAP,
        "today_rooms_commit": "rms_otb",
        "today_room_revenue_commit": "rev_otb",
        "stly_date_rooms_commit": "rms_stly",
        "stly_date_room_revenue_commit": "rev_stly",
        "st2y_date_rooms_commit": "rms_st2y",
        "st2y_date_room_revenue_commit": "rev_st2y",
        "business_view": "segment",
        "forecast_group": "segment",
        "market_segment": "segment",
    },
    "snap_pace_segment": {
        **COMMON_COLUMN_MAP,
        "today_rooms_commit": "rms_otb",
        "today_room_revenue_commit": "rev_otb",
        "stly_date_rooms_commit": "rms_stly",
        "stly_date_room_revenue_commit": "rev_stly",
        "st2y_date_rooms_commit": "rms_st2y",
        "st2y_date_room_revenue_commit": "rev_st2y",
        "business_view": "segment",
        "forecast_group": "segment",
        "market_segment": "segment",
    },
    "fact_pace_segment": {
        **COMMON_COLUMN_MAP,
        "today_rooms_commit": "rms_otb",
        "today_room_revenue_commit": "rev_otb",
        "stly_date_rooms_commit": "rms_stly",
        "stly_date_room_revenue_commit": "rev_stly",
        "st2y_date_rooms_commit": "rms_st2y",
        "st2y_date_room_revenue_commit": "rev_st2y",
        "business_view": "segment",
        "forecast_group": "segment",
        "market_segment": "segment",
    },  # legacy notebook alias
    "business_view": {
        **COMMON_COLUMN_MAP,
        "business_view": "segment",
        "forecast_group": "segment",
        "market_segment": "segment",
    },

    "stg_pace_roomclass": {
        **COMMON_COLUMN_MAP,
        "room_class": "roomclass",
        "roomclass": "roomclass",
        "room_class_code": "roomclass_code",
    },
    "snap_pace_roomclass": {
        **COMMON_COLUMN_MAP,
        "room_class": "roomclass",
        "roomclass": "roomclass",
        "room_class_code": "roomclass_code",
    },
    "fact_pace_roomclass": {
        **COMMON_COLUMN_MAP,
        "room_class": "roomclass",
        "roomclass": "roomclass",
        "room_class_code": "roomclass_code",
    },  # legacy notebook alias
    "roomclass": {
        **COMMON_COLUMN_MAP,
        "room_class": "roomclass",
        "roomclass": "roomclass",
        "room_class_code": "roomclass_code",
    },

    "stg_pace_roomtype": {
        **COMMON_COLUMN_MAP,
        "physical_capacity": "available_rms",
        "capacity_this_year": "available_rms",
        "capacity_last_year_actual": "available_rms_ly",
    },
    "snap_pace_roomtype": {
        **COMMON_COLUMN_MAP,
        "physical_capacity": "available_rms",
        "capacity_this_year": "available_rms",
        "capacity_last_year_actual": "available_rms_ly",
    },
    "fact_pace_roomtype": {
        **COMMON_COLUMN_MAP,
        "physical_capacity": "available_rms",
        "capacity_this_year": "available_rms",
        "capacity_last_year_actual": "available_rms_ly",
    },  # legacy notebook alias
    "roomtype": {
        **COMMON_COLUMN_MAP,
        "physical_capacity": "available_rms",
        "capacity_this_year": "available_rms",
        "capacity_last_year_actual": "available_rms_ly",
    },

    # Existing non-pace report aliases retained.
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


PACE_STAGING_COLUMNS: Dict[str, list[str]] = {
    "property": [
        "property_code", "property_name", "snap_date", "stay_date", "comparison_date_ly",
        "available_rms", "available_rms_ly", "remaining_rms", "remaining_rms_ly",
        "rms_otb", "rev_otb", "rms_ly", "rev_ly", "rms_stly", "rev_stly",
        "rms_st2y", "rev_st2y", "rms_bgt", "rev_bgt", "rms_fct", "rev_fct",
        "adr_fct",
        "property_rms_fct", "property_rms_fct_ly", "property_rev_fct",
        "property_rev_fct_ly",
        "group_rms_otb", "group_rms_ly", "group_rms_stly", "group_rms_st2y",
        "transient_rms_otb", "transient_rms_ly", "transient_rms_stly",
        "transient_rms_st2y",
        "demand_total", "demand_total_ly", "demand_group", "demand_group_ly",
        "demand_transient", "demand_transient_ly",
        "system_demand_total", "system_demand_total_ly",
        "system_demand_group", "system_demand_group_ly",
        "system_demand_transient", "system_demand_transient_ly",
        "user_demand_total", "user_demand_total_ly",
        "user_constrained_demand_group", "user_constrained_demand_group_ly",
        "user_unconstrained_demand_transient", "user_unconstrained_demand_transient_ly",
        "arrival_rms", "arrival_rms_ly", "departure_rms", "departure_rms_ly",
        "cx_rms", "cx_rms_ly", "ns_rms", "ns_rms_ly", "ooo_rms", "ooo_rms_ly",
        "na_other_rms", "na_other_rms_ly", "overbook_rms", "overbook_rms_ly",
        "adr_otb", "adr_ly", "adr_fct_ly", "revpar_otb", "revpar_ly",
        "revpar_fct", "revpar_fct_ly",
        "lrv", "lrv_ly", "wash_pct", "wash_pct_ly", "bar_price", "bar_price_ly",
        "primary_event", "primary_event_ly",
        "source_system", "source_report", "source_file",
        "load_ts", "insert_date", "updated_date",
    ],
    "segment": [
        "property_code", "property_name", "snap_date", "stay_date", "comparison_date_ly",
        "segment", "segment_code", "segment_group", "segment_group_code",
        "finance_segment", "finance_segment_code", "segment_category", "rate_basis",
        "segment_map", "segment_code_map",
        "available_rms", "rms_otb", "rev_otb", "rms_ly", "rev_ly", "rms_stly",
        "rev_stly", "rms_st2y", "rev_st2y", "rms_bgt", "rev_bgt", "rms_fct",
        "rev_fct", "adr_fct",
        "cx_rms", "cx_rms_ly", "ns_rms", "ns_rms_ly",
        "source_system", "source_report", "source_file",
        "load_ts", "insert_date", "updated_date",
    ],
    "roomclass": [
        "property_code", "property_name", "snap_date", "stay_date", "comparison_date_ly",
        "roomclass", "roomclass_code", "roomclass_map", "roomclass_code_map",
        "available_rms", "rms_otb", "rev_otb", "rms_ly", "rev_ly", "rms_stly",
        "rev_stly", "rms_st2y", "rev_st2y", "rms_bgt", "rev_bgt", "rms_fct",
        "rev_fct", "adr_fct",
        "system_unconstrained_demand", "system_unconstrained_demand_ly",
        "user_demand", "user_demand_ly",
        "system_wash_pct", "system_wash_pct_ly", "user_wash_pct", "user_wash_pct_ly",
        "cx_rms", "cx_rms_ly", "ns_rms", "ns_rms_ly",
        "source_system", "source_report", "source_file",
        "load_ts", "insert_date", "updated_date",
    ],
    "roomtype": [
        "property_code", "property_name", "snap_date", "stay_date", "comparison_date_ly",
        "roomtype", "roomtype_code", "roomtype_map", "roomtype_code_map",
        "roomclass", "roomclass_code", "bedtype", "bedtype_code", "roomfeature",
        "roompool", "roompool_code",
        "available_rms", "rms_otb", "rev_otb", "rms_ly", "rev_ly", "rms_stly",
        "rev_stly", "rms_st2y", "rev_st2y", "rms_bgt", "rev_bgt", "rms_fct",
        "rev_fct", "adr_fct",
        "cx_rms", "cx_rms_ly", "ns_rms", "ns_rms_ly",
        "source_system", "source_report", "source_file",
        "load_ts", "insert_date", "updated_date",
    ],
}


PACE_REPORT_TO_GRAIN: Dict[str, str] = {
    "property": "property",
    "snap_property": "property",
    "stg_pace_property": "property",
    "snap_pace_property": "property",
    "fact_pace_property": "property",

    "business_view": "segment",
    "segment": "segment",
    "stg_pace_segment": "segment",
    "snap_pace_segment": "segment",
    "fact_pace_segment": "segment",

    "roomclass": "roomclass",
    "room_class": "roomclass",
    "stg_pace_roomclass": "roomclass",
    "snap_pace_roomclass": "roomclass",
    "fact_pace_roomclass": "roomclass",

    "roomtype": "roomtype",
    "room_type": "roomtype",
    "stg_pace_roomtype": "roomtype",
    "snap_pace_roomtype": "roomtype",
    "fact_pace_roomtype": "roomtype",
}


def build_rename_map(
    columns: list[Any],
    source_report: Optional[str] = None,
    extra_map: Optional[Mapping[str, str]] = None,
) -> Dict[str, str]:
    """Build the actual rename map for a list of source columns."""
    normalized_columns = [normalize_header(col) for col in columns]

    report_key = normalize_header(source_report) if source_report else None
    rename_map: Dict[str, str] = dict(COMMON_COLUMN_MAP)

    if report_key and report_key in REPORT_COLUMN_MAPS:
        rename_map.update(REPORT_COLUMN_MAPS[report_key])

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
    rename_map = build_rename_map(
        original_columns,
        source_report=source_report,
        extra_map=extra_map,
    )

    rows = []
    for original_col, normalized_col in zip(original_columns, normalized_columns):
        standard_col = rename_map.get(normalized_col, normalized_col)
        rows.append(
            {
                "original_column": original_col,
                "normalized_column": normalized_col,
                "standard_column": standard_col,
                "changed": standard_col != normalized_col,
                "mapped": normalized_col in rename_map,
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

    rename_map = build_rename_map(
        list(df.columns),
        source_report=source_report,
        extra_map=extra_map,
    )

    return output.rename(columns=rename_map)


def add_ingestion_metadata(
    df: pd.DataFrame,
    metadata: Optional[Mapping[str, Any]] = None,
) -> pd.DataFrame:
    """Add standard ingestion metadata columns without overwriting existing populated values."""
    output = df.copy()
    metadata = dict(metadata or {})

    today = pd.Timestamp.utcnow().date()
    defaults: Dict[str, Any] = {
        "load_ts": datetime.now(timezone.utc),
        "insert_date": today,
        "updated_date": today,
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

    output = standardize_columns(
        df,
        source_report=source_report,
        extra_map=extra_map,
    )
    output = add_ingestion_metadata(output, metadata=metadata)
    return output


def infer_pace_grain(
    source_report: Optional[str] = None,
    grain: Optional[str] = None,
) -> str:
    """Infer the pace grain from an explicit grain or source report name."""
    key = normalize_header(grain or source_report)

    if key in PACE_REPORT_TO_GRAIN:
        return PACE_REPORT_TO_GRAIN[key]

    raise ValueError(
        "Unable to infer pace grain. Pass one of: "
        f"{', '.join(sorted(PACE_STAGING_COLUMNS.keys()))}."
    )


def derive_property_demand_fields(df: pd.DataFrame) -> pd.DataFrame:
    """Populate generic property demand fields from system demand fields when needed."""
    output = df.copy()

    demand_defaults = {
        "demand_total": "system_demand_total",
        "demand_total_ly": "system_demand_total_ly",
        "demand_group": "system_demand_group",
        "demand_group_ly": "system_demand_group_ly",
        "demand_transient": "system_demand_transient",
        "demand_transient_ly": "system_demand_transient_ly",
    }

    for target, source in demand_defaults.items():
        if target not in output.columns and source in output.columns:
            output[target] = output[source]
        elif target in output.columns and source in output.columns:
            output[target] = output[target].fillna(output[source])

    return output


def align_columns(
    df: pd.DataFrame,
    columns: Iterable[str],
    drop_extra: bool = True,
    fill_value: Any = pd.NA,
) -> pd.DataFrame:
    """Add missing columns and optionally return only the supplied columns in order."""
    output = df.copy()
    columns = list(columns)

    for column in columns:
        if column not in output.columns:
            output[column] = fill_value

    if drop_extra:
        return output[columns]

    ordered = output[columns]
    extra_columns = [column for column in output.columns if column not in columns]
    return pd.concat([ordered, output[extra_columns]], axis=1)


def align_pace_dataframe(
    df: pd.DataFrame,
    grain: Optional[str] = None,
    source_report: Optional[str] = None,
    drop_extra: bool = True,
    drop_day_of_week: bool = True,
) -> pd.DataFrame:
    """
    Align a standardized pace dataframe to the revised Dataform staging schema.

    Intended for processing/export notebooks that produce BigQuery-ready CSVs.
    This function does not load data to BigQuery and does not perform lookup
    enrichment. Missing lookup/enrichment columns are added as null placeholders.
    """
    resolved_grain = infer_pace_grain(source_report=source_report, grain=grain)
    output = df.copy()

    if drop_day_of_week:
        output = output.drop(columns=["day_of_week"], errors="ignore")

    output = add_ingestion_metadata(output)

    if resolved_grain == "property":
        output = derive_property_demand_fields(output)

    return align_columns(
        output,
        PACE_STAGING_COLUMNS[resolved_grain],
        drop_extra=drop_extra,
    )


def standardize_pace_dataframe(
    df: pd.DataFrame,
    source_report: str,
    grain: Optional[str] = None,
    metadata: Optional[Mapping[str, Any]] = None,
    extra_map: Optional[Mapping[str, str]] = None,
    print_report: bool = False,
    drop_extra: bool = True,
) -> pd.DataFrame:
    """
    Standardize and align a pace dataframe to the revised Dataform staging schema.

    Business View exports should use source_report="snap_pace_segment" or
    grain="segment".
    """
    output = standardize_dataframe(
        df,
        source_report=source_report,
        metadata=metadata,
        extra_map=extra_map,
        print_report=print_report,
    )

    return align_pace_dataframe(
        output,
        grain=grain,
        source_report=source_report,
        drop_extra=drop_extra,
    )
