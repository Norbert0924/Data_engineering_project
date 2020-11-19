# Operational layer


In order to create my relational dataset I created the following tables:

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

https://github.com/Norbert0924/DE_SQL_CLASS/blob/main/product.csv
https://github.com/Norbert0924/DE_SQL_CLASS/blob/main/orders.csv
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

# ANALYTICS

Which city had the most orders?

-- 407_New York City
select count(city) as Number_of_orders, city
from orders
group by city
order by count(city) desc
Limit 1;

-- 2. Which customer ordered the most freuqently?
select count(Customer_ID) as orders, customer.Customer_Name
from customer
inner join orders
using(Customer_ID)
group by Customer_ID
order by count(Customer_ID) desc
Limit 1;

-- 3. Which customer ordered the most product by sale(sum)?
select sum(Sales), customer.Customer_Name
from orders
left join customer
using(Customer_ID)
group by Customer_ID
order by sum(Sales) desc
Limit 1;

-- 4. Filter  out the delivery mode which created the highest number of product orders?
select count(distinct Order_ID) as orders, Ship_Mode
from orders
group by Ship_Mode
order by count(distinct Order_ID)
Limit 1;

5. Filter out all customer names with their sale revenues without duplcation(Join left)?

select Customer_Name, sum(Sales) as Total_sales
from customer
left join orders
using(Customer_ID)
group by Customer_Name
order by sum(Sales) desc;

6. Show the number of products by category in ascending order?
select count(Product_ID) as Products, Category
from product
group by Category
order by count(Product_ID) asc;

7. Show all category with their total sales in descending order?
Select Category, round(sum(Sales)) as Total_sales
from product
left join orders
using(Product_ID)
group by Category
order by round(sum(Sales)) desc;

8. Which state had the highest profit in US?
select State, round(sum(Profit))
from orders
where country like "United States"
group by State
order by round(sum(Profit)) desc
Limit 1;

9. How many Nokia orders happened in US?
select "United States" as Country, "Nokia" as Brand, count(distinct Order_ID) as Number_of_orders
from orders
Left join product
Using (Product_ID)
Where Product_Name like '%Nokia%' and Country like "United States"
group by "Nokia", "United States";