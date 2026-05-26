USE Assign1

select * from dbo.Customers
select * from dbo.[Order details]
select * from dbo.Orders
select * from dbo.Payments
select * from dbo.Product

--Basic Tasks
--1.	Display all customers from Mumbai.
select * from dbo.Customers where City = 'Mumbai'
--2.	Show all products in Electronics category.
select * from dbo.Product where Category = 'Electronics'
--3.	List customers who signed up after 2023-01-01.
select * from dbo.Customers where SignupDate > '2023-01-01'
--4.	Find products with price between 500 and 2000.
select * from Product where Price between 500 and 2000
--5.	Count total number of customers.
select count(*) as Total_customers from dbo.Customers
--6.	Find average price of products.
select Avg(Price) as Avg_Price from dbo.Product
--7.	Display distinct cities from Customers table.
select distinct(City) from dbo.Customers
--8.	Show orders placed in March 2024.
select * from dbo.Orders where OrderDate between '2024-03-01' and '2024-03-31'
--9.	List products whose name starts with 'S'.
select * from Product where ProductName like 'S%'
--10.	Sort products by price in descending order.
select * from Product 
Order by Price Desc

--Intermediate Tasks
--1.	Show customer name with their order dates. (Customers + Orders)
Select c.FirstName,c.LastName, o.OrderDate from dbo.Customers c join dbo.Orders o on c.CustomerID = o.CustomerID
--2.	Display order id with product name and quantity. (Orders + OrderDetails + Products)
select o.OrderID, p.ProductName, od.Quantity from dbo.Orders o join dbo.[Order details] od on o.OrderID = od.OrderID join dbo.Product p on p.ProductID = od.ProductID
--3.	Find total sales amount per order.
select  o.OrderID ,sum(p.Price) as Total_sales from dbo.Product p join dbo.[Order details] o on p.ProductID=o.ProductID
Group by o.OrderID
order by Total_sales desc
--4.	Find total sales per customer.
select  c.FirstName,c.Lastname ,o.OrderID, Sum(od.Quantity * p.Price) as Total_Sales from Customers c join Orders o on c.CustomerID = o.CustomerID join [Order details] od on od.OrderID = o.OrderID join Product p on  p.ProductID = od.ProductID
group by c.FirstName,c.LastName,o.OrderID
order by Total_Sales desc
--5.	Find total quantity sold for each product.
select p.ProductID, p.ProductName,Sum(od.Quantity) as Total_Sold from Product p join [Order details] od on p.ProductID = od.ProductID
group by p.ProductID, p.ProductName
order by Total_Sold desc
--6.	List top 5 most sold products. 
select top 5 (p.ProductName) as Highest_Selling_Product,Sum (od.Quantity) as Total_Sold from Product p join [Order details] od on p.ProductID = od.ProductID
group by p.ProductName
order by Total_Sold desc

WITH ProductSales AS (
    SELECT p.ProductID, p.ProductName, SUM(od.Quantity) AS Total_Sold
    FROM Product p
    JOIN [Order Details] od ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT ProductName, Total_Sold
FROM (
    SELECT ProductName, Total_Sold,
           RANK() OVER (ORDER BY Total_Sold DESC) AS RankOrder
    FROM ProductSales
) Ranked
WHERE RankOrder <= 5;

--7.	Show number of orders per city.
select c.City,Count(o.OrderID) as Total_Orders from Orders o join Customers c on o.CustomerID = c.CustomerID
group by c.City
order by Total_Orders desc
--8.	Find total revenue generated per category.
select p.Category , sum(p.Price * od.Quantity) AS Total_Revenue from Product p join [Order details] od on p.ProductID = od.ProductID
group by p.Category
Order by Total_Revenue desc
--9.	Find customers who have placed more than 3 orders.
SELECT c.CustomerID, c.FirstName, c.LastName,
       COUNT(o.OrderID) AS Total_Orders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(o.OrderID) >= 3
ORDER BY Total_Orders DESC;
--10.	Show most preferred payment mode.
select PaymentMode, count(OrderID) as Total_Order from Payments
group by PaymentMode
Order by Total_Order desc 
offset 0 rows
fetch next 3 rows only

--11.	Find monthly sales for year 2024.
select Year (o.OrderDate) as Year,
Month ( o.OrderDate) as Month,
Sum(p.Price * od.Quantity) as Total_Sales from Orders o join [Order details] od  on o.OrderID = od.OrderID join Product p on 
od.ProductID = p.ProductID
where YEAR(o.OrderDate) = 2024
Group by Year ( o.OrderDate) ,
 Month (o.OrderDate) 
order by Total_Sales desc

--12.	Find customers who never placed an order. (LEFT JOIN)
select c.FirstName, o.OrderID from Customers c left join Orders o on c.CustomerID = o.CustomerID
where OrderID is Null

--Advanced Tasks
--1.	Find the second highest selling product.

WITH ProductSales AS (
    SELECT ProductID, SUM(Quantity) AS TotalSold
    FROM [Order Details]
    GROUP BY ProductID
)
SELECT ProductID, TotalSold
FROM ProductSales
WHERE TotalSold = (
    SELECT MAX(TotalSold)
    FROM ProductSales
    WHERE TotalSold < (
        SELECT MAX(TotalSold) FROM ProductSales
    )
);

--2.	Rank customers based on total spending. (RANK())
with Totalspending AS (select c.CustomerID, c.FirstName, Sum (od.Quantity * P.Price) as Total_Spending
from Customers c join Orders o on 
c.CustomerID = o.CustomerID join [Order details] od
on o.OrderID = od.OrderID join Product p
on od.ProductID = p.ProductID
Group by c.CustomerID,c.FirstName
)
Select CustomerID,FirstName, Total_Spending,
Dense_Rank() over (order by Total_Spending desc) As RankOrder from Totalspending
order by RankOrder Asc
  



--3.	Find running total of sales by date.
with RunningSales As (Select o.OrderDate ,sum(p.Price * od.Quantity) as Total_Sales from Orders o
join [Order details] od on o.OrderID = od.OrderID join Product p on p.ProductID = od.ProductID
group by o.OrderDate
)
select OrderDate,Total_Sales ,
Sum(Total_Sales) over (order by OrderDate rows between unbounded Preceding and current row)
As Running_Total
from RunningSales
order by OrderDate desc

--4.	Find top customer in each city.
with CustomerOrders as (Select c.CustomerID,c.FirstName, c.City, count(o.OrderID) as Total_Orders from
customers c join orders o on c.CustomerID = o.CustomerID
group by c.CustomerID,c.FirstName,c.City
)
select CustomerID,FirstName, City ,Total_Orders
from
(select CustomerID,FirstName, City ,Total_Orders,
DENSE_RANK() over (Partition by City Order by Total_Orders Desc) as RankOrder
from CustomerOrders) t 
where RankOrder = 1
order by City




--5.	Categorize customers as:
	-- Gold (> 50,000 spend)
      --   Silver (20,000–50,000)
        -- Bronze (< 20,000)
select c.CustomerID, c.FirstName, Sum (od.Quantity * P.Price) as Total_Spending,
case 
when Sum (od.Quantity * P.Price) > 50000 then 'Gold'
when Sum (od.Quantity * P.Price) between 20000 and 50000 then 'Silver'
when Sum (od.Quantity * P.Price) < 20000 then 'Bronze'
end as Spending_Category

from Customers c join Orders o on 
c.CustomerID = o.CustomerID join [Order details] od
on o.OrderID = od.OrderID join Product p
on od.ProductID = p.ProductID
Group by c.CustomerID,c.FirstName

       
--6.	Find products that were never ordered.
With TotalOrders As (Select p.ProductID , p.ProductName , Count(od.OrderID) as Total_Orders from Product p left join [Order details] od on
p.ProductID = od.ProductID
group by p.ProductID,p.ProductName)

select ProductID,ProductName,Total_Orders from TotalOrders where Total_Orders = 0




--7.	Find customers whose last order was more than 6 months ago
WITH LastOrders AS (
    SELECT c.CustomerID, c.FirstName, c.LastName,
           MAX(o.OrderDate) AS LastOrderDate
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
)
SELECT CustomerID, FirstName, LastName, LastOrderDate
FROM LastOrders
WHERE LastOrderDate < DATEADD(MONTH, -6, GETDATE())
ORDER BY LastOrderDate;
--8.	Find average order value per customer.
with OrderValue as (select c.CustomerID , o.OrderID,sum (p.price * od.Quantity) as Order_Value from Customers c join
orders o on c.CustomerID = o.CustomerID join [Order details] od on o.OrderID = od.OrderID
join Product p on od.ProductID = p.ProductID
group by c.CustomerID,O.OrderID)

select CustomerID, Avg(Order_Value) as Avg_Order_Value from OrderValue
group by CustomerID
order by Avg_Order_Value Desc

--9.	Identify the month with highest sales.
WITH TotalSales AS (
    SELECT Month(o.OrderDate) AS Month,
    Sum(od.Quantity * p.Price) as Total_Sales

    FROM Orders o
    JOIN [Order details] od ON o.OrderID = od.OrderID
    join Product p on p.ProductID = od.ProductID
    GROUP BY MONTH(o.OrderDate)
)

SELECT TOP 1 Month, Total_Sales
FROM TotalSales
ORDER BY Total_Sales DESC;

--10.	Use CTE to find repeat customers (customers with orders in more than 3 different months).
With TotalOrders as (select c.CustomerID,Month (o.OrderDate) as Month, count(o.OrderID) as Total_orders
from Customers c join orders  o on c.CustomerID = o.CustomerID
group by c.CustomerID, MONTH(o.OrderDate))
--10.	Use CTE to find repeat customers (customers with orders in more than 3 different months).
With TotalOrders as (select c.CustomerID,Month (o.OrderDate) as Month, count(o.OrderID) as Total_orders
from Customers c join orders  o on c.CustomerID = o.CustomerID
group by c.CustomerID, MONTH(o.OrderDate))

--10.	Use CTE to find repeat customers (customers with orders in more than 3 different months).
WITH CustomerMonths AS (
    SELECT c.CustomerID,
           MONTH(o.OrderDate) AS OrderMonth
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, MONTH(o.OrderDate)
),
RepeatCustomers AS (
    SELECT CustomerID,
           COUNT(DISTINCT OrderMonth) AS DistinctMonths
    FROM CustomerMonths
    GROUP BY CustomerID
)
SELECT CustomerID, DistinctMonths
FROM RepeatCustomers
WHERE DistinctMonths > 3
ORDER BY DistinctMonths DESC;


--11.	Find percentage contribution of each category to total sales.
With CategoryContribution as( select p.Category , sum(p.price * od.Quantity) as Total_Sales from Product p
join [Order details] od on p.ProductID =od.ProductID
group by P.Category),

overallTotal as (select Sum(Total_Sales) as Grand_Total from CategoryContribution)

select c.Category,
c.Total_Sales,
Round((Total_Sales * 100 / o.Grand_Total ),2)As Percentage_Contribution
from CategoryContribution c cross join overallTotal o 
order by  Percentage_Contribution desc 





--12.	Detect orders where total amount > average order amount.
With TotalAmount as (select o.OrderID, sum(p.Price * od.quantity) as Total_Amount 
from Orders o join [Order details] od on o.OrderID = od.OrderID
join Product p on od.ProductID = p.ProductID
group by o.OrderID),

AvgAmount as (
select  Avg(Total_Amount) as Avg_Order_Amount from 
TotalAmount )

select t.OrderID,t.Total_Amount,A.Avg_Order_Amount from TotalAmount t cross join 
AvgAmount a where t.Total_Amount > A.Avg_Order_Amount
order by t.Total_Amount desc






