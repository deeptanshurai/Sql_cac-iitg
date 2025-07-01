create database Inventory

use Inventory

select * from inventory_forecasting


select * from Information_Schema.columns
where table_name = "inventory_forecasting"


-- Counting for non-null values
select
  count(`Store ID`) as total_store_id,
  count(`Product ID`) as total_product_id,
  count(`Category`) as total_category,
  count(`Region`) as total_region,
  count(`Inventory Level`) as total_inventory_level,
  count(`Units Sold`) as total_units_sold,
  count(`Units Ordered`) as total_units_ordered,
  count(`Demand Forecast`) as total_demand_forecast,
  count(`Price`) as total_price,
  count(`Discount`) as total_discount,
  count(`Weather Condition`) as total_weather_condition,
  count(`Holiday/Promotion`) as total_holiday_promotion,
  count(`Competitor Pricing`) as total_competitor_pricing,
  count(`Seasonality`) as total_seasonality
from inventory_forecasting



-- Checking for Duplicate Values
select `Date`, `Store ID`, `Product ID`, COUNT(*) as Duplicates
from inventory_forecasting
Group By `Date`, `Store ID`, `Product ID`
Having duplicates > 1;

-- creating a new table with the same data but with some changes in the datatypes so that disk occupies minimum space 
-- and for future operations so that during operations original table doesnt get altered
create table inventory_analysis(
    date date,
    store_id char(4),
    product_id char(5),
    category varchar(256),
    region varchar(256),
    inventory_level smallint,
    units_sold smallint,
    units_ordered smallint,
    demand_forecast decimal(10,2),
    price decimal(10,2),
    discount decimal(5,2),
    weather_condition varchar(256),
    holiday_or_promotion varchar(256),
    competitor_price decimal(5,2),
    seasonality varchar(256)
)

insert into inventory_analysis
select
    `date`,
    `store id`,
    `product id`,
    category,
    region,
    `inventory level`,
    `units sold`,
    `units ordered`,
    `demand forecast`,
    price,
    discount,
    `weather condition`,
    `holiday/promotion`,
    `competitor pricing`,
    seasonality
from inventory_forecasting


select * from inventory_analysis
