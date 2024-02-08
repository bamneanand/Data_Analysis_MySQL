create database Walmart_Sales;
use Walmart_Sales;

CREATE TABLE IF NOT EXISTS sales (
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY, 
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL, 
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL, 
unit_price DECIMAL(10, 2) NOT NULL, 
quantity INT NOT NULL,
VAT FLOAT (6, 4) NOT NULL,
total DECIMAL (12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10, 2) NOT NULL, 
gross_margin_pct FLOAT(11, 9),
gross_income DECIMAL(12, 4) NOT NULL, 
rating FLOAT (2, 1));

select * from sales;

-- ===================== Feature Engineering ========================

-- time_of_day 
select time, case
when time between "00:00:00" and "12:00:00" then "Morning"
when time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end as "time_of_day"
from sales;

alter table sales
add column time_of_day varchar(20);

update sales
set time_of_day = (case
when time between "00:00:00" and "12:00:00" then "Morning"
when time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end);

select * from sales;

-- day_name 
select date, dayname(date) as day_name
from sales;

alter table sales
add column day_name varchar(20);

update sales
set day_name = dayname(date);

select * from sales;

-- month_name
select date, monthname(date) as month_name
from sales;

alter table sales
add column month_name varchar(20);

update sales 
set month_name = monthname(date);

select * from sales;

-- ===================== Generic ========================

-- how many unique cities present? 
select distinct(city) as unique_cites from sales;

-- in which city is each branch
select distinct(city), branch from sales;

-- ===================== Products ========================

-- unique product lines
select distinct product_line from sales;

-- common payment method
select payment_method, count(payment_method) as total
from sales
group by payment_method
order by total desc;

-- most selling product line
select product_line, count(product_line) as total
from sales
group by product_line
order by total desc;

-- total revenue by month
select distinct month_name from sales;

select month_name, sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- month with largest cogs
select month_name, sum(cogs) as total_cogs
from sales
group by month_name
order by total_cogs desc;

-- product line with largest revenue
select product_line, sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- city with largest revenue
select city, sum(total) as total_revenue
from sales
group by city
order by total_revenue desc;

-- product line with largest vta
select product_line, sum(VAT) as total_vat
from sales
group by product_vat
order by total_revenue desc;

-- branch sold more products thn the avg
select branch, sum(quantity) as qty
from sales
group by branch
having qty > (select avg(quantity) from sales);

-- common product line by gender
select gender, 
product_line,
count(product_line) as most_used
from sales
group by gender, product_line
order by most_used desc;

-- avg rating of a product line
select product_line,
round(avg(rating),2)  as avg_rate
from sales
group by product_line
order by avg_rate desc;

-- ===================== Sales ========================

-- total sales as per the time of a day in weedays
select day_name, time_of_day,
count(*) as total_sales
from sales
where day_name not in('sunday', 'saturday')
group by day_name, time_of_day
order by total_sales desc;

-- customer with high revenue
select customer_type, 
round(sum(total),2) as total_rev
from sales
group by customer_type
order by total_rev desc;

-- city with largest VAT
select city, 
round(avg(VAT),2) as total_VAT
from sales
group by city
order by total_VAT desc;

-- customer with most in VAT
select customer_type, 
round(avg(VAT),2) as total_vat
from sales
group by customer_type
order by total_vat desc;

-- ===================== Customers ========================

-- unique coustomer
select distinct customer_type
from sales;

-- unique payment method
select distinct payment_method
from sales;

-- common customer type
select customer_type, count(customer_type) as most_com
from sales
group by customer_type
order by most_com desc;

-- gender of the most of the coustomer
select gender, count(gender) as most_com
from sales
group by gender
order by most_com desc;

-- gender as per every branch
select branch, gender, count(gender) as gpbrn
from sales
group by branch, gender
order by branch, gpbrn desc;
 
-- time of day with most ratings
select time_of_day, avg(rating) as most_rt
from sales
group by time_of_day
order by most_rt desc;

-- time of day with most ratings per branch
select branch, time_of_day, avg(rating) as most_rt
from sales
group by branch,time_of_day
order by most_rt desc;

-- day of a week with best ratings
select day_name, avg(rating) as most_rt
from sales
group by day_name
order by most_rt desc;

-- day of a week with best ratings per branch
select branch, day_name, avg(rating) as most_rt
from sales
group by branch,day_name
order by most_rt desc;