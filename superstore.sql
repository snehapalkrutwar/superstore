-- 1.check the first 5 rows to make sure it imported well
select * from superstore limit 5;

-- 1 .what are the total sales and tota profits of each year

SELECT
   year(`Order Date`) as year,
   round(sum(sales),2) as total_sale,
   round(sum(profit),2) as total_profit
 from superstore
 group by year(`Order Date`)
 order by year asc
 limit 0,1000;
   
  
  -- 2.what are the total profits and total sales per quarter quarter?
  
  select 
      year(`order date` ) as year,
      case 
          when month(`order date`) In (1,2,3) then 'Q1'
		  when month(`order date`) In (4,5,6) then 'Q2'
		  when month(`order date`) In (7,8,9) then 'Q3'
		  else 'Q4'
	End as quarter,
     round(sum(sales),2) as total_sale,
     round(sum(profit),2) as total_profit
      from superstore
 group by  year,quarter
 order by year,quarter
 limit 0,1000;

-- 3. what region generates the highest sales and profits

select region,
sum(sales)as total_sale,
sum(profit) as total_profits
from superstore
group by  region
order by  total_profits desc
limit 1;

-- 4 each region profit margins for further analysis
-- ROUND((SUM(profit)/sum(sales)) * 100,2) as profit margin 

select region ,ROUND((SUM(profit)/sum(sales)) * 100,2) as profit_margin 
from superstore
group by region
order by profit_margin desc;
         
         -- 4.what state and city brings in the highest sales and profits?
          
  select state,sum(sales) as Total_sale,
  sum(profit) as total_profits,
  ROUND((SUM(profit)/sum(sales)) * 100,2) as profit_margin 
from superstore
group by state
order by total_profits desc limit 10;
  
  
  
  -- observe our bottom 10 States
  select * from superstore;
  
  select state,round(sum(sales),2) as high_sale,round(sum(profit),2) as high_profit
  from superstore
  group by state
  order by high_profit asc
  limit 10;
  
  
  
  -- The top state are 
  select state,
         round(sum(sales)) as total_sale,
         round(sum(profit),2) as high_profit,
	     round(sum((profit)/(sales)*100),2) as profit_margin
  from superstore
  group by state
  order by profit_margin desc
  limit 10;
  
--   The bottom 10 cities are

select city,
     round(sum(sales),2) as total_sale,
     round(sum(profit),2) as total_profits
  from superstore
  group by city
  order by  total_profits asc
  limit 10 ;
  
  
  
  -- 5. The relationship between discount and sales and the total discount per category
  
  select category,
         round(sum(discount),2) as total_discount
  from superstore
  group by category
  order by total_discount desc
  limit 1;
		 
   
   -- 6.	What category generates the highest sales and profits in each region and state ?
   with total as(
   select 
          region,
          category,
          round(sum(sales),2) as total_sales,
          round(sum(profit)) as total_profits
 from superstore
 group by region, category),
 ranked as( select * ,
    rank() over(partition by region order by total_sales) as sale_rank,
    rank() over(partition by region order by total_profits) as profit_rank
 from total
 )
 select Region,
    Category,
    total_sales,
    total_profits from ranked 
 where sale_rank =1 
            and
      profit_rank=1
 order by region;
 
 
 -- 7.	What subcategory generates the highest sales and profits in each region and state ?
-- Highest total sales and total profits per subcategory in each region

-- Least performing ones
-- Highest total sales and total profits per subcategory in each state
-- Lowest sales and profits. 
 with total_sale as (
 select 
	    region,
        state,
        `sub-category`,
        round(sum(sales),2) as total_sales,
        round(sum(profit),2) as total_profit
from superstore
group by region,state,`sub-category`
),
ranked as(
select *,
   rank() over(partition by region  order by total_profit ) as profit_rank,
   rank() over(partition by region  order by total_sales ) as sales_rank
from total_sale
)
select * from ranked 
where  profit_rank =1 
or
sales_rank=1
order by region,	`sub-category`;
 
 
 
  
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          