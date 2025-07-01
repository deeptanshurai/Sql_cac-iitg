-- [stock level calculations across stores and warehouse]

-- it shows total, average, minimum, and maximum stock by region and category 
-- it also helps us to know how much stock is available right now for each product category in each region
select 
    region,
    category,
    sum(inventory_level) as total_stock,
    avg(inventory_level) as average_stock,
    min(inventory_level) as minimum_stock,
    max(inventory_level) as maximum_stock
from inventory_analysis
where date = (select max(date) from inventory_analysis)
group by region, category;



-- [reorder point estimation using historical trend]

-- here we first calculate average and variation in daily sales for each product
-- then by using this section below we have calculated the reorder point based on past sales and then based on it we have detected the low inventory
with sales_summary as (
    select 
        product_id,
        avg(units_sold) as average_daily_sales,
        stddev(units_sold) as sales_variation
    from inventory_analysis
    group by product_id
)


-- [low inventory detection based on reorder point]

select 
    i.date,
    i.store_id,
    i.region,
    i.product_id,
    i.inventory_level,
    round((s.average_daily_sales * 7) + (s.sales_variation * 1.5)) as reorder_point,
    case 
        when i.inventory_level <= round((s.average_daily_sales * 7) + (s.sales_variation * 1.5)) 
        then 'reorder is needed' 
        else 'stock is sufficient' 
    end as stock_status
from inventory_analysis i
join sales_summary s on i.product_id = s.product_id
where i.date = (select max(date) from inventory_analysis);



-- [inventory turnover analysis]

-- this helps us to know how fast each category sells its products in last 90 days 
-- here we have shown the total units sold, average inventory level and turnover ratio for each category of products
-- then we have assigned rank to each product category based on the turnover ratio
select 
    category,
    sum(units_sold) as total_units_sold,
    avg(inventory_level) as average_inventory,
    round(sum(units_sold) / nullif(avg(inventory_level), 0), 2) as turnover_ratio,
    rank() over (order by sum(units_sold) / nullif(avg(inventory_level), 0) desc) as turnover_rank
from inventory_analysis
where date between 
    (select max(date) - interval 90 day from inventory_analysis) 
    and (select max(date) from inventory_analysis)
group by category;



-- [summary reports with kpis like stockout rates, inventory age, and average stock levels]

-- (stockout rate by region)

-- it shows how often a region of a store rans out of stock but its demand still persists
-- here we calculated the average inventory level of all products
with avg_inventory as (
    select 
        product_id,
        avg(inventory_level) as avg_inv
    from inventory_analysis
    group by product_id
)

-- here we have total no of records by counting the no of times each store id and region occurs
-- then we have divided it by checking if current inventory is less than average inventory then we consider it as a stockout and add by 1 
select 
    f.region,
    f.store_id,
    count(*) as total_records,
    sum(case when f.inventory_level < a.avg_inv then 1 else 0 end) as stockout_count,
    round(
        sum(case when f.inventory_level < a.avg_inv then 1 else 0 end) * 100.0 / count(*),
        2
    ) as stockout_rate
from inventory_analysis f
join avg_inventory a on f.product_id = a.product_id
group by f.region, f.store_id;



-- (average stock level)

-- it shows the average no of items available in stock for each product
select 
    category,
    avg(inventory_level) as average_inventory
from inventory_analysis
group by category;



-- (inventory age)

-- it gives us an idea about how old a product is or for how long it is in the inventory
-- for better undertanding we have taken today's date and from today we have calculated for how long a product has been in the inventory 
select 
    store_id as store,
    product_id as product_code,
    category as product_name,     
    max(date) as last_stocked,
    datediff(current_date, max(date)) as days_outdated
from inventory_analysis
group by store_id, product_id, category;
