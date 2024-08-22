-- Assignment day 4(1)

select * from orders;
select ordernumber ,status,ifnull(comments,"-")as comments from orders where status="shipped";

-- assignment day 4(2)

select * from employees;
select employeenumber ,firstname,jobtitle,
case
when jobtitle = "president" then "P"
when jobtitle like "sales manager%" then "SM"
when jobtitle like "sale manager%" then "SM"
when jobtitle = "sales rep" then "SP"
when jobtitle like "vp%" then "VP" 
end as jobtitle_abbri from employees;

-- Assignment day 5(1)
select *  from payments;
select year(paymentdate) as year , min(amount) as minamount from payments  group by  year(paymentdate) order by year(paymentdate);
-- Assignment day 5(2)

SELECT YEAR (orderdate) AS year,
    CASE
        WHEN EXTRACT(MONTH FROM orderdate) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN EXTRACT(MONTH FROM orderdate) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN EXTRACT(MONTH FROM orderdate) BETWEEN 7 AND 9 THEN 'Q3'
        ELSE 'Q4'
    END AS quarter,
    COUNT(DISTINCT customernumber) AS unique_customers,
    COUNT(*) AS total_orders FROM orders GROUP BY year, quarter ORDER BY year, quarter;
    
    -- Assignments day 5(3)
    select * from payments;
select
 left(monthname(paymentdate),3) as month,
concat(case
when round(sum(amount)/1000)>=1000 then concat(round(sum(amount)/100000),"m")
else concat(round(sum(amount)/1000),"k")
end )as formattedamount
 from payments
group by month
having sum(amount) between 500000 and 1000000
order by sum(amount) desc;

-- Assignment 6(1)
create table journey (bus_id int primary key  not null,bus_name varchar(30) not null,source_station varchar(30) not null,Destination varchar(30) not null
,Email varchar(30) unique);
select * from journey;

-- Assignment 6(2)
create table vendor (Vonder_id int unique not null,Name varchar (30) not null,Email varchar(30) unique,Country varchar(30) default 'N/A');
select * from vendor;


-- Assignment 6(3)
create table movie(Movie_id int unique not null, Name varchar(40) not null,
Release_value varchar(30) default '-', cast varchar(40) not null, 
Gender enum('male','female'),
No_of_shows int check (no_of_shows>0));
select* from movie;


-- assignment 6(4) ABC
create table suppliers(supplier_id int primary key auto_increment, supplier_name varchar(40), location varchar(40));
select * from suppliers;

create table product(product_id int primary key auto_increment, product_name varchar(40) not null unique,
discription Text ,supplier_id int, foreign key(supplier_id) references suppliers(supplire_id) );

create table stock(id int auto_increment primary key , product_id int ,foreign key (product_id) references product(product_id),
balance_stock int)    ;
    
    -- Assignment 7(1)
    select * from employees;
    select * from customers;
    select e. employeeNumber,
    concat(e.firstName ,' ',e.lastname )as SalesPerson ,
    count( Distinct c.CustomerNumber) as UniqueCustomers from
    employees e inner join 
    Customers c ON e.EmployeeNumber = c.SalesRepEmployeeNumber 
group by
e.employeeNumber,salesPerson
order by 
UniqueCustomers desc;

    -- Assignment 7(2)
  select * from customers;
  select * from orders;
  select * from orderdetails;
  select * from Products;
SELECT 
    c.CustomerNumber,
    c.CustomerName,
    p.ProductCode,
    p.ProductName,
    SUM(od.QuantityOrdered) AS Orderedqty,
    SUM(p.QuantityInStock) AS Total_Inventory,
    (SUM(p.QuantityInStock) - SUM(od.QuantityOrdered)) AS LeftQuantity
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerNumber = o.CustomerNumber
JOIN 
    OrderDetails od ON o.OrderNumber = od.OrderNumber
JOIN 
    Products p ON od.ProductCode = p.ProductCode
GROUP BY 
    c.CustomerNumber, p.ProductCode
ORDER BY 
    c.CustomerNumber;

   -- Assignment 7(3)
CREATE TABLE Laptop (
    Laptop_Name VARCHAR(100)
);
INSERT INTO Laptop (Laptop_Name) VALUES
('HP'),
('Dell');

CREATE TABLE Colours (
    Colour_Name VARCHAR(50)
);
INSERT INTO Colours (Colour_Name) VALUES
('White'),
('Silver'),
('Black');
SELECT 
    l.Laptop_Name,
    c.Colour_Name
FROM 
    Laptop l
CROSS JOIN 
    Colours c
WHERE
    (l.Laptop_Name = 'HP' AND c.Colour_Name IN ('White', 'Silver', 'Black')) OR
    (l.Laptop_Name = 'Dell' AND c.Colour_Name IN ('White', 'Silver', 'Black'))
ORDER BY 
    l.Laptop_Name, c.Colour_Name desc;

-- assignment 7(4)
   SELECT 
    m.FullName AS ManagerName ,
        e.FullName AS EmployeeName
FROM 
    Project e
LEFT JOIN 
    Project m ON e.ManagerID = m.EmployeeID
    where m.fullname is not null
ORDER BY 
    RIGHT(m.FullName, 1), m.FullName;
    
    
    -- Assignment day(8)
create table facility (facility_id int ,name varchar(50),state varchar(50),country varchar(40));
   select * from facility;
   alter table facility modify column facility_id int auto_increment primary key;
   ALTER TABLE facility
    ADD COLUMN City VARCHAR(255) NOT NULL AFTER Name;
desc facility;

-- Assignment  day (9)

CREATE TABLE University (
    ID INT,
    Name VARCHAR(255));

INSERT INTO University (ID, Name) VALUES
(1, "       Pune          University     "),
(2, "  Mumbai          University     "),
(3, "     Delhi   University     "),
(4, "Madras University"),
(5, "Nagpur University");
set sql_safe_updates=0;
update university set name = trim(both " " from REGEXP_REPLACE(Name, ' {1,}', ' ')) 
where id is not null; 
-- Display the updated data
SELECT * FROM University;

   -- assignment day 10
   create view products_status AS
select Year(O.orderDate) as year,
concat(round(count(od.quantityOrdered * od.priceEach)),
'(',
round((sum(od.quantityOrdered * od.priceEach) / sum(sum(od.quantityOrdered * od.priceEach)) over()) *100), '%)') as "total values"
from orders O join orderdetails od
on O.ordernumber = od.ordernumber
group by YEAR(O.orderDate);
select * from products_status;
   -- Assignment day 11
   
   -- Que- 1
 select * from Customers;
 select * from orders;

select customerNUmber, customerName from customers where customerNumber NOT IN
(select DISTINCT (customerNumber) FROM orders where status="shipped" ORDER BY customerNumber);

-- Que- 2
select * from Customers;
select * from orders;

select c.customerNumber, c.customerName, COUNT(o.orderNumber) AS "Total Orders"
FROM Customers c
LEFT JOIN ORDERS o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName

UNION 
select c.customerNumber, c.customerName, 0 AS "Total Orders"
FROM Customers c
where c.customerNumber NOT IN (SELECT DISTINCT customerNumber FROM Orders)

UNION
select o.customerNumber, NULL AS customerName, COUNT(o.orderNumber) AS "Total Orders"
FROM Orders o
Where o.customerNumber NOT IN (SELECT DISTINCT customerNumber FROM Customers)
GROUP BY o.customerNumber;

-- Que- 3
select * from Orderdetails;
select orderNumber, MAX(quantityOrdered) AS QuantityOrders
From Orderdetails O
where quantityOrdered < (
select MAX(quantityOrdered)
from Orderdetails od
where od.orderNumber = O.orderNumber)
GROUP BY OrderNumber;

-- Que- 4
select * from orderdetails;
select orderNumber,
count(orderNumber) as TotalProduct
from Orderdetails
GROUP BY orderNumber
HAVING COUNT(orderNumber) > 0;
select
MAX(TotalProduct) AS 'MAX(Total)',
MIN(TotalProduct) AS 'MIN(Total)'
from ( 
select orderNumber,
Count(orderNumber) AS TotalProduct
from Orderdetails
GROUP BY orderNumber
HAVING COUNT(orderNumber) > 0) AS ProductCounts;

-- Que- 5
select * from products;
select productLine, COUNT(*) AS Total
from products
where BuyPrice > (
select avg(BuyPrice) 
from products)
GROUP BY productLine;

   
   
   
   
   
   
   -- assignment Day 14
   Create table Emp_EH(
EMPID int primary key,
EmpName varchar(100),
EmailAddress varchar(100));         
-- In stored procedures(Notepad)   
              
              
              
-- assignment day 15
create table emp_bit(
Name varchar(255),
Occupation varchar(255),
Working_date date,
Working_hours int);

insert into emp_bit 
Values ('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
select * from emp_bit;

-- Before insert trigger (Notepad)