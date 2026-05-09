CREATE TABLE `devrebel-big-query-database.dev_hotel_g4a.p_ga4_Promotions_281286275`
(
  itemListPosition STRING OPTIONS(description="The position of an item in a list. For example, a product you sell in a list. This dimension is populated in tagging by the index parameter in the items array."),
  itemPromotionCreativeName STRING OPTIONS(description="The name of the item-promotion creative."),
  itemPromotionId STRING OPTIONS(description="The ID of the promotion."),
  itemPromotionName STRING OPTIONS(description="The name of the promotion for the item."),
  itemPromotionClickThroughRate FLOAT64 OPTIONS(description="The number of users who selected a promotion(s) divided by the number of users who viewed the same promotion(s). This metric is returned as a fraction; for example, 0.1382 means 13.82% of users who viewed a promotion also selected the promotion."),
  itemRevenue FLOAT64 OPTIONS(description="The total revenue from purchases minus refunded transaction revenue from items only. Item revenue is the product of its price and quantity. Item revenue excludes tax and shipping values; tax & shipping values are specified at the event and not item level."),
  itemsAddedToCart INT64 OPTIONS(description="The number of units added to cart for a single item. This metric counts the quantity of items in add_to_cart events."),
  itemsCheckedOut INT64 OPTIONS(description="The number of units checked out for a single item. This metric counts the quantity of items in begin_checkout events."),
  itemsClickedInPromotion INT64 OPTIONS(description="The number of units clicked in promotion for a single item. This metric counts the quantity of items in select_promotion events."),
  itemsPurchased INT64 OPTIONS(description="The number of units for a single item included in purchase events. This metric counts the quantity of items in purchase events."),
  itemsViewedInPromotion INT64 OPTIONS(description="The number of units viewed in promotion for a single item. This metric counts the quantity of items in view_promotion events.")
)
PARTITION BY DATE(_PARTITIONTIME);