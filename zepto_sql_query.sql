drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name varchar(150) not null,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms integer,
outOfStock boolean,
quantity integer
);

--data exploration

--count of rows
select count(*) from zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
select 8 from zepto 
where name is null 
or
category is null 
or
mrp is null 
or
discountPercent is null 
or
availableQuantity is null 
or
discountedSellingPrice is null 
or
weightInGms is null 
or
outOfStock is null 
or
quantity is null;

--different product category
select distinct category
from zepto
order by category;

--product in stock vs out of stock
select outOfStock, count(sku_id)
from zepto
group by outOfstock;

--product names present multiple time
select name, count(sku_id) as "Number of SKUs"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;

--data cleaning

--product with price 0
select * from zepto
where mrp=0 or discountedSellingPrice =0;

delete from zepto where mrp=0;

--convert paise to rupees
update zepto
set mrp=mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0

select mrp, discountedSellingPrice from zepto;

--Q1. Find the top 10 best-value products based on the discount percentage.

select distinct name, mrp, discountPercent
from zepto
order by discountPercent desc
limit 10;

--Q2. What are the products with high mrp but out of stock.

select distinct name, mrp
from zepto
where outOfStock= True and mrp>300
order by mrp desc;

--Q3. Calculated estimated revenue for each category.

select distinct category,sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue ;

--Q4. Find all products where mrp is greater then Rp500 and discount is less then 10%.

select distinct name, mrp, discountPercent 
from zepto
where mrp>500 and discountPercent <10
order by mrp desc , discountPercent desc;

--Q5. Identity the top 5 categories offering the highest average discount percentage.

select distinct category, 
round(avg(discountPercent),2) as avg_discount 
from zepto
group by category
order by avg_discount desc
limit 5;

--Q6. Find the price per gram for products above 100g and sort by best values.

select distinct name, weightInGms, discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto
where weightInGms>=100
order by price_per_gram;

--Q7. Group the products into categories like low, medium, bulk.

select distinct name, weightInGms,
case when weightInGms<1000 THEN 'Low'
	when weightInGms <5000 then 'Medium'
	else 'Bulk'
	end as weight_category
	from zepto;

--Q8. What is the total inventory weight per category.

select category, sum(weightInGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight;