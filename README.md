# Operational layer

My chosen dataset was from: https://raw.githubusercontent.com/Norbert0924/DE_SQL_CLASS/main/Global%20Superstore_original_dataset.csv

In order to create my relational dataset I created the following tables such as orders, customer and product. My analysis is based on these three tables in order to get better insight into the business.

create schema assignment;
use assignment;

Create table orders
(Row_ID integer, 
Order_ID varchar(40) not null,
Order_Date date,
Ship_Date date,
Ship_Mode varchar(40),
Customer_ID varchar(40),
Postal_Code varchar(40),
City varchar(40),
State varchar(40),
Country varchar(40),
Region varchar(40),
Market varchar(40),
Product_ID varchar(40),
Sales float,
Quantity integer,
Discount float,
Profit float,
Shipping_Cost float,
Order_Priority varchar(20), 
Primary key(Order_ID));


create table customer
(Customer_ID varchar(40),
Customer_Name varchar(60),
Segment varchar(60),
Primary key(Customer_ID));


create table product
(Product_ID varchar(40),
Category varchar(20),
Sub_Category varchar(20),
Product_Name varchar(200),
Primary key(Product_ID));


After creating schemas, the tables are still empty. We need to fill in with data from CSVs into the tables:

The following CSV data tables were put into this command:


https://github.com/Norbert0924/DE_SQL_CLASS/blob/main/orders.csv

https://github.com/Norbert0924/DE_SQL_CLASS/blob/main/product.csv

https://github.com/Norbert0924/DE_SQL_CLASS/blob/main/customer.csv


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Row_ID, Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Postal_Code, City, State, Country, Region, Market, Product_ID, @v_Sales, Quantity, @v_Discount, @v_Profit, @v_Shipping_Cost, Order_Priority)
SET
Sales = CONVERT(REPLACE(@v_Sales, ',', '.'), FLOAT),
Discount = CONVERT(REPLACE(@v_Discount, ',', '.'), FLOAT),
Profit = CONVERT(REPLACE(@v_Profit, ',', '.'), FLOAT),
Shipping_Cost = CONVERT(REPLACE(@v_Shipping_Cost, ',', '.'), FLOAT)
;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product.csv'
INTO TABLE product
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Product_ID, Category, Sub_Category, Product_Name);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer.csv'
INTO TABLE customer
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Customer_ID, Customer_Name, Segment);

### Database diagram



# ANALYTICS

## Questions:

After creating the relational tables, I intended to answer some meaningful questions which could be used for management decision making.


1. Which city had the most orders?

select count(city) as Number_of_orders, city
from orders
group by city
order by count(city) desc
Limit 1;
-- Answer: 407_New York City 

2. Which customer ordered the most freuqently?

select count(Customer_ID) as orders, customer.Customer_Name
from customer
inner join orders
using(Customer_ID)
group by Customer_ID
order by count(Customer_ID) desc
Limit 1;
-- Answer: 23 Arthur Prichep

3. Which customer ordered the most product by sale(sum)?

select round(sum(Sales)), customer.Customer_Name
from orders
left join customer
using(Customer_ID)
group by Customer_ID
order by round(sum(Sales)) desc
Limit 1;
-- Answer:  12182	Adrian Barton

4. Select the delivery mode which created the highest number of product orders?

select count(distinct Order_ID) as orders, Ship_Mode
from orders
group by Ship_Mode
order by count(distinct Order_ID) desc
Limit 1;
-- Answer:  14221	Standard Class

5. Select the customer name with the highest sale revenues without duplcation(Join left)?

select Customer_Name, round(sum(Sales)) as Total_sales
from customer
left join orders
using(Customer_ID)
group by Customer_Name
order by round(sum(Sales)) desc
Limit 1;
-- Answer: Christopher Conant	34004

6. Show the number of products by category in ascending order?
select count(Product_ID) as Products, Category
from product
group by Category
order by count(Product_ID) asc;
-- Answer: 
-- 841	Furniture
-- 876	Technology
-- 2071	Office Supplies

7. Show all category with their total sales in descending order?
Select Category, round(sum(Sales)) as Total_sales
from product
left join orders
using(Product_ID)
group by Category
order by round(sum(Sales)) desc;
-- Answer: 
-- Technology	4065892
-- Furniture	3517316
-- Office Supplies	2712760

8. Which state had the highest profit in US?
select State, round(sum(Profit))
from orders
where country like "United States"
group by State
order by round(sum(Profit)) desc
Limit 1;
-- Answer: California	30132

9. How many Nokia orders happened in US?
select "United States" as Country, "Nokia" as Brand, count(distinct Order_ID) as Number_of_orders
from orders
Left join product
Using (Product_ID)
Where Product_Name like '%Nokia%' and Country like "United States"
group by "Nokia", "United States";
-- Answer: United States	Nokia	4


## DATA MART 
### Create Views

In order to represent view function two questions were asked. 

-- View1:
-- Does US have higher Sales than Albania?

select Country, round(sum(Sales))
from orders
where Country like "United States"  or Country like "Albania"
group by Country;

create view country_vs_sales
as select Country, round(sum(Sales))
from orders
where Country like "United States"  or Country like "Albania"
group by Country;

select *  from country_vs_sales;

-- View2
-- Which segment in which product category has the highest profit?

select Segment, Category, Profit
from orders
left join customer
using(Customer_ID)
left join product
using(Product_ID)
Group by Segment, Category
Order by Profit desc
Limit 1;

-- View 2:
create view segment_vs_category_profit
as select Segment, Category, Profit
from orders
left join customer
using(Customer_ID)
left join product
using(Product_ID)
Group by Segment, Category
Order by Profit desc
Limit 1;

select * from segment_vs_category_profit;


# Extra part

Which country has the highest and lowest Shipping_Cost? (find them with only one select command)

SELECT
	(SELECT Country FROM Orders WHERE Shipping_Cost is not null and Shipping_Cost <> 0 ORDER BY Shipping_Cost asc LIMIT 1) AS lowest_shipping_cost,
    (SELECT Country FROM Orders ORDER BY Shipping_Cost desc LIMIT 1) AS highest_shipping_cost;






