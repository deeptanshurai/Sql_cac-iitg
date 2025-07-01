
# Detect Stockouts (Inventory L = 0 or low threshold)
SELECT *
FROM inventory_forecasting
WHERE `Inventory Level` <= 10
ORDER BY `Inventory Level` ASC;
# Fast vs Slow Moving Products

SELECT `Product ID`, AVG(`Units Sold`) AS avg_units_sold
FROM inventory_forecasting
GROUP BY `Product ID`
ORDER BY avg_units_sold DESC;

# Reorder Point Estimation
SELECT `Product ID`, `Store ID`,
       AVG(`Units Sold`) AS avg_daily_demand,
       AVG(`Units Sold`) * 7 AS reorder_point_estimate
FROM inventory_forecasting
GROUP BY `Product ID`, `Store ID`;

# inventory turnover 
SELECT 
    `Product ID`,
    SUM(`Units Sold`) / AVG(`Inventory Level`) AS inventory_turnover
FROM inventory_forecasting
GROUP BY `Product ID`;

# Effects of discount on sales 
SELECT `Discount`, AVG(`Units Sold`) AS avg_units_sold
FROM inventory_forecasting
GROUP BY `Discount`
ORDER BY `Discount`;

# Competitor Price Impact

SELECT 
  ROUND(`Competitor Pricing`, -1) AS competitor_price_bucket,
  AVG(`Units Sold`) AS avg_units_sold
FROM inventory_forecasting
GROUP BY competitor_price_bucket
ORDER BY competitor_price_bucket;

# Weather Vs Demand
SELECT `Weather Condition`, AVG(`Units Sold`) AS avg_sold
FROM inventory_forecasting
GROUP BY `Weather Condition`;

# Promo/Holiday Impact 
SELECT `Holiday/Promotion`, AVG(`Units Sold`) AS avg_sold
FROM inventory_forecasting
GROUP BY `Holiday/Promotion`;

# Category Wise Performance

SELECT `Category`, 
       SUM(`Units Sold`) AS total_sold,
       AVG(`Inventory Level`) AS avg_stock
FROM inventory_forecasting
GROUP BY `Category`
ORDER BY total_sold DESC;

# Store Region based inventory  heatmap
SELECT `Store ID`, `Region`, 
       AVG(`Inventory Level`) AS avg_inventory
FROM inventory_forecasting
GROUP BY `Store ID`, `Region`
ORDER BY avg_inventory ASC;
