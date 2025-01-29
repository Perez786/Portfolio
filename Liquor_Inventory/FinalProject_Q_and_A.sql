--1. Added a Constraint
USE Inventory
ALTER TABLE Inv_Liq_Item
ADD Dist_ID int not null foreign key (Dist_ID) references Inv_Liq_Dist(Dist_ID),
CONSTRAINT Item_ML check(Item_ML>205);
--I added a constraint to Item_ML. Entering a the wrong amount in this column can drastically effect our pour cost.
--I used 205ML as the threshold because I have never received an item that was below 7oz, roughly around 208ML.

--1.1 Example of tested constraint 
USE Inventory
INSERT INTO Inv_Liq_Item (item_name, item_ML, item_cost, Item_amount, Dist_ID)
VALUES ('Test', 200, 25.00,2,3);

--2.1 This query involves 3 different tables. 
SELECT li.Item_Name, d.Dist_Name, Count (t.Trans_No) as TransactionCount
FROM Inv_Liq_Item li
join Inv_Liq_Dist d on d.Dist_ID=li.Dist_ID
join Inv_Liq_Trans t on t.Item_ID=li.Item_ID
GROUP BY li.Item_Name, d.Dist_Name
ORDER BY TransactionCount desc;
--I wanted to see what items were selling the most, the name of the item, and the vendor who carries the item. 
--In order to get this information, I had to join all three tables in my database. 
--Since I am using an aggregate function, I have to use the GROUP BY clause. 
--I used the ORDER BY clause in descending order to get my results according to the highest amount of items sold first. 
--This can be useful information when considering minimums for orders or making deals with distributors. 

--2.2 Using a Join Operator
SELECT li.Item_Name, d.Dist_Name, d.Dist_Contact, d.Dist_Email, d.Dist_Number
FROM Inv_Liq_Item li
join Inv_Liq_Dist d on d.Dist_ID=li.Dist_ID
WHERE Item_Name like'Titos%';
--To elaborate on the above query, I wanted to get the contact information for the item we sell the most, in this case, Titos Vodka.
--I want this information so I can arrange a meeting where we can discuss discounts on volume. 
--In order to get this information, I had to join the LiquorItem and Vendor tables. 
--I used the WHERE clause and specified 'Titos' since it is my highest selling item.

--2.3 Using the HAVING clause. 
SELECT li.Item_Name, li.Item_Cost, d.Dist_Name, d.Dist_Contact, d.Dist_Email, d.Dist_Number
FROM Inv_Liq_Item li
join Inv_Liq_Dist d on d.Dist_ID=li.Dist_ID
GROUP BY li.Item_Name, li.Item_Cost, d.Dist_Name, d.Dist_Contact, d.Dist_Email, d.Dist_Number
HAVING MIN (li.Item_Cost)>20.00
--I am looking to do Happy Hour and wanted to also arrange meetings with other vendors as well to discuss possible discounts.
--I wanted to query the items that had a minimum threshold of $20 for Happy Hour. This way, things that are a little more expensive will be cheaper and attract new customers.
--In order to get this information, I had to join the LiquorItem and Vendor tables. 
--I am using the HAVING clause in conjuction with the MIN aggregate function to help accomplish this. 
--Since I am using an aggregate function, I have to use the GROUP BY clause.
--This query returned 5 rows. 

--3. Update using the WHERE clause. 
UPDATE Inv_Liq_Item
SET Item_Cost =11.50
WHERE Item_Name like '%PX%';
SELECT * FROM Inv_Liq_Item;
--The cost of Osbourne PX Sherry went up $.50 due to a shortage of Pedro Ximenez grapes. Price needs to be updated from $11 to $11.50.
--I used the UPDATE and SET combination in order to update the changes in the table. 
--I used the WHERE clause in order to specify the item I wanted to change. In this instance, it was the PX Sherry that went from $11 to $11.50.

--4 Using Minimum and Maximum values through variables. 
DECLARE @maxcost float, 
@mincost float;
SELECT @maxcost=MAX(Item_Retail_Cost), @mincost=MIN(Item_Retail_Cost)
FROM Inv_Liq_Item;
SELECT @maxcost AS Max_Cust_Cost, @mincost AS Min_Cust_Cost;
--I wanted to get an idea of what the bar is charging guests, from the cheapest item to the most expensive item, so I can compare these numbers with competitors in the area. 
--To accomplish this, I declared variables that equated to the Minimum and Maximum Item_Retail_Cost columns using a float data type. 
--I am retrieving this data from the LiquorItem table. 
--I am using the aliases Max_Cust_Cost and Min_Cust_Cost for my results. 
--The minimum amount we are charging guests is $3.33 and the maximum amount we are charging guests is $11.82.

--5 Creating a Procedure that returns full details of a table based on the WHERE clause. 
CREATE PROCEDURE EverythingLiquor 
@item_name nvarchar(50) as 
SELECT * FROM Inv_Liq_Item
WHERE Item_Name=@item_name;
EXEC EverythingLiquor 'vida mezcal'
--I wanted to create a shortcut to access all of the item information if I needed a quick look at numbers. 
--To accomplish this, I created a Stored Procedure and declared the @item_name variable as a parameter for my query. 
--I used the WHERE clause to give the variable a value in which the parameter can query once prompted. 
--I used the LiquorItem table to accomplish this. 
