"""
IDeaS PaceData workbook sheet configuration for REVREBEL Metrics Library ingestion.

Use this alongside revrebel_column_standardizer.py in Colab/notebooks.

Modeling decision:
- IDeaS "Room Class" is standardized as `roomclass`.
- `roomclass` is defined as a grouping of like room types that can be interchanged and have similar features or characteristics.
- `roomtype` remains the specific sellable room product.
- `roompool` should only be used if a source system separately defines a broader pricing/inventory pool beyond room class.
"""

IDEAS_PACE_SHEET_CONFIGS = {
    "Property": {
        "source_report": "snap_property",
        "target_table": "fact_pace_property",
        "extra_map": {},
    },
    "Room Type": {
        "source_report": "snap_pace_roomtype",
        "target_table": "fact_pace_roomtype",
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
        "extra_map": {
            "room_class": "roomclass",
            "roomclass": "roomclass",
            "room_class_code": "roomclass_code",
            "roomclass_code": "roomclass_code",
        },
    },
    "Market Segment": {
        "source_report": "snap_pace_segment",
        "target_table": "fact_pace_segment",
        "extra_map": {
            "market_segment": "segment",
        },
    },
    "Business View": {
        "source_report": "snap_pace_segment",
        "target_table": "fact_pace_segment",
        "extra_map": {
            "business_view": "segment",
        },
    },
    "Forecast Group": {
        "source_report": "snap_pace_segment",
        "target_table": "fact_pace_segment",
        "extra_map": {
            "forecast_group": "segment",
        },
    },
}
