const {
    segmentPickupIntervals,
    roomPickupIntervals
} =
require("../includes/variables");


function buildPickupViews({
    type,
    intervals,
    baseTable
}) {
    intervals.forEach((interval) => {
        publish(`PaceData_${type}_${interval.toString().padStart(3, '0')}DayV`)
            .type("view")
            .query(ctx => `
        WITH CurrentSnapshot AS (
          SELECT * FROM ${ctx.ref(`PaceData_${type}V_LatestSnapshotV`)}
        ),
        PriorSnapshot AS (
          SELECT * FROM ${ctx.ref(`PaceData_${type}V_LatestSnapshotV`)}
          QUALIFY ROW_NUMBER() OVER (
            PARTITION BY property_code, snapshot_date, ${type === "Segment" ? "segment" : "roomtype"}, stay_date
            ORDER BY ingested_timestamp DESC
          ) = 1
        )

        SELECT
          curr.property_code,
          curr.${type === "Segment" ? "segment" : "roomtype"},
          curr.stay_date,
          curr.snapshot_date AS current_snapshot_date,
          curr.rms,
          curr.rev,
          prior.snapshot_date AS pickup_reference_date_${interval}d,
          curr.rms - prior.rms AS rms_pickup_${interval}d,
          curr.rev - prior.rev AS rev_pickup_${interval}d
        FROM CurrentSnapshot curr
        LEFT JOIN PriorSnapshot prior
          ON curr.property_code = prior.property_code
         AND curr.${type === "Segment" ? "segment" : "roomtype"} = prior.${type === "Segment" ? "segment" : "roomtype"}
         AND curr.stay_date = prior.stay_date
         AND prior.snapshot_date = DATE_SUB(curr.snapshot_date, INTERVAL ${interval} DAY)
      `);
    });
}

// Generate Segment pickups
buildPickupViews({
    type: "Segment",
    intervals: segmentPickupIntervals,
    baseTable: "PaceData_Segment"
});

// Generate RoomType pickups
buildPickupViews({
    type: "RoomType",
    intervals: roomPickupIntervals,
    baseTable: "PaceData_RoomType"
});
