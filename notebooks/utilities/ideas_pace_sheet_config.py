"""
IDeaS PaceData workbook sheet configuration for REVREBEL Metrics Library ingestion.

Use this alongside revrebel_column_standardizer.py in Colab/notebooks.

Active BI ingestion tabs:
- Property
- Room Type
- Room Class
- Business View

Modeling decisions:
- IDeaS "Room Class" is standardized as `roomclass`.
- `roomclass` is defined as a grouping of like room types that can be interchanged and have similar features or characteristics.
- `roomtype` remains the specific sellable room product.
- `Business View` is the cleaned IDeaS market segment/business segmentation layer and should feed `fact_pace_segment`.
- `Market Segment` is excluded from standard BI ingestion because it represents raw system codes before IDeaS grouping/cleanup.
- `Forecast Group` is excluded from standard BI ingestion because it represents the RMS internal forecast grain.
- `roompool` should only be used if a source system separately defines a broader pricing/inventory pool beyond room class.
"""

IDEAS_PACE_SHEET_CONFIGS = {
    "Property": {
        "source_report": "snap_property",
        "target_table": "fact_pace_property",
        "source_system": "IDeaS",
        "extra_map": {},
    },
    "Room Type": {
        "source_report": "snap_pace_roomtype",
        "target_table": "fact_pace_roomtype",
        "source_system": "IDeaS",
        "extra_map": {
            "room_class": "roomclass",
            "roomclass": "roomclass",
            "room_class_code": "roomclass_code",
            "roomclass_code": "roomclass_code",
        },
    },
    "Room Class": {
        "source_report": "snap_pace_roomclass",
        "target_table": "fact_pace_roomclass",
        "source_system": "IDeaS",
        "extra_map": {
            "room_class": "roomclass",
            "roomclass": "roomclass",
            "room_class_code": "roomclass_code",
            "roomclass_code": "roomclass_code",
        },
    },
    "Business View": {
        "source_report": "snap_pace_segment",
        "target_table": "fact_pace_segment",
        "source_system": "IDeaS",
        "extra_map": {
            "business_view": "segment",
        },
    },
}

# Optional non-BI tabs that may be retained for audit, mapping, or RMS troubleshooting.
# These should not feed the standard BI facts unless a specific use case requires them.
IDEAS_PACE_EXCLUDED_SHEET_CONFIGS = {
    "Market Segment": {
        "reason": "Raw system codes before IDeaS grouping/cleanup. Use Business View for standardized BI segment reporting.",
        "source_report": "snap_pace_segment_raw_market_segment",
        "target_table": "fact_metric_observation",
        "source_system": "IDeaS",
        "extra_map": {
            "market_segment": "segment_map",
        },
    },
    "Forecast Group": {
        "reason": "RMS internal forecast grain. Use only for RMS troubleshooting, forecast audit, or model diagnostics.",
        "source_report": "snap_pace_forecast_group",
        "target_table": "fact_metric_observation",
        "source_system": "IDeaS",
        "extra_map": {
            "forecast_group": "segment_map",
        },
    },
}
