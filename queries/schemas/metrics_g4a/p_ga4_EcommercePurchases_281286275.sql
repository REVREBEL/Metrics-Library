CREATE TABLE `devrebel-big-query-database.dev_hotel_g4a.p_ga4_EcommercePurchases_281286275`
(
  itemBrand STRING OPTIONS(description="Brand name of the item."),
  itemCategory STRING OPTIONS(description="The hierarchical category in which the item is classified. For example, in Apparel/Mens/Summer/Shirts/T-shirts, Apparel is the item category."),
  itemCategory2 STRING OPTIONS(description="The hierarchical category in which the item is classified. For example, in Apparel/Mens/Summer/Shirts/T-shirts, Mens is the item category 2."),
  itemCategory3 STRING OPTIONS(description="The hierarchical category in which the item is classified. For example, in Apparel/Mens/Summer/Shirts/T-shirts, Summer is the item category 3."),
  itemCategory4 STRING OPTIONS(description="The hierarchical category in which the item is classified. For example, in Apparel/Mens/Summer/Shirts/T-shirts, Shirts is the item category 4."),
  itemCategory5 STRING OPTIONS(description="The hierarchical category in which the item is classified. For example, in Apparel/Mens/Summer/Shirts/T-shirts, T-shirts is the item category 5."),
  itemId STRING OPTIONS(description="The ID of the item."),
  itemListPosition STRING OPTIONS(description="The position of an item in a list. For example, a product you sell in a list. This dimension is populated in tagging by the index parameter in the items array."),
  itemName STRING OPTIONS(description="The name of the item."),
  itemVariant STRING OPTIONS(description="The specific variation of a product. For example, XS, S, M, or L for size; or Red, Blue, Green, or Black for color. Populated by the item_variant parameter."),
  itemRevenue FLOAT64 OPTIONS(description="The total revenue from purchases minus refunded transaction revenue from items only. Item revenue is the product of its price and quantity. Item revenue excludes tax and shipping values; tax & shipping values are specified at the event and not item level."),
  itemsAddedToCart INT64 OPTIONS(description="The number of units added to cart for a single item. This metric counts the quantity of items in add_to_cart events."),
  itemsPurchased INT64 OPTIONS(description="The number of units for a single item included in purchase events. This metric counts the quantity of items in purchase events."),
  itemsViewed INT64 OPTIONS(description="The number of units viewed for a single item. This metric counts the quantity of items in view_item events.")
)
PARTITION BY DATE(_PARTITIONTIME);