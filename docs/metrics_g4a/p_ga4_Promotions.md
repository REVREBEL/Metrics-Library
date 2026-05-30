---
title: "p_ga4_Promotions"
sidebarTitle: "Promotions"
description: "Internal advertising and promotion performance metrics."
---

# File 8: Promotions Table

**File Path:** `/docs/metrics_g4a/p_ga4_Promotions_281286275.md`

## Schema Purpose

The `p_ga4_Promotions_281286275` table measures direct engagement and conversion performance for internal promotions, banners, and marketing campaigns featured on the website or mobile application. This table tracks how effectively creative placements drive item interaction, cart starts, checkout activity, and product revenue.

## Table Schema

| Column Name                     | Data Type | Column Definition & Calculated Metric Representation |
| ------------------------------- | --------- | ---------------------------------------------------- |
| `itemPromotionCreativeName`     | STRING    | The name of the item-promotion creative. |
| `itemPromotionId`               | STRING    | The ID of the promotion. |
| `itemPromotionName`             | STRING    | The name of the promotion for the item. |
| `itemListPosition`              | INTEGER   | The position of an item in a list, populated in tagging by the `index` parameter in the items array. |
| `itemAddedToCart`               | INTEGER   | The number of units added to cart for a single item following engagement. |
| `itemCheckedOut`                | INTEGER   | The number of units checked out for a single item, counting `begin_checkout` events. |
| `itemPromotionClickThroughRate` | FLOAT     | The promotion click-through rate, calculated as promotion clicks divided by promotion views. |
| `itemRevenue`                   | FLOAT     | The total product-specific revenue generated as a direct consequence of the internal promotion. |
| `itemsClickedInPromotion`       | INTEGER   | The number of units clicked in promotion for a single item, counting `select_promotion` events. |
| `itemsPurchased`                | INTEGER   | The volume of individual items purchased that were attributed to the internal promotion. |
| `itemsViewedInPromotion`        | INTEGER   | The total volume of promotional impressions recorded, counting `view_promotion` events. |

## Analytical Considerations

Analyzing internal promotion metrics helps design teams optimize page layouts and creative assets. High banner impressions, represented by `itemsViewedInPromotion`, with a low click-through rate, represented by `itemPromotionClickThroughRate`, typically suggest a need to update the creative design or improve the call-to-action.

Evaluating `itemCheckedOut` alongside `itemsPurchased` highlights potential checkout friction for users who engaged with specific promotional campaigns.
