create database Inventory

use Inventory 
create table Inv_Liq_Item (--This table contains our Liquor inventory information.
Item_ID int Primary Key identity (1,1), --Giving each Item an ID so it can be uniquely identified.
Item_Name nvarchar (50) Not Null,  --Name of the Liquor item.
Item_ML smallint Not Null, --How many ML are in each bottle
Item_Cost smallmoney Not Null, --How much did the item cost the bar to purchase. 
Item_Amount smallint, --How  many of the items we have in stock.
Item_Retail_Cost as CAST(ROUND((Item_Cost/Item_ML)*44.36025*5,2) as smallmoney) Persisted);
--In order to calculate the retail cost, I need to figure out how much each item costs the bar in ML. 
--In order to get that amount, I need to divide the cost by the amount of ML in the bottle.
--44.36025ML is equivalent to 1.5oz, which is the average serving pour amount at the bar. That amount has to be multiplied by the cost per ML in order to get our cost per serving. 
--Once we get our cost per serving, then we can determine how much we can charge people that come to the bar. 
--In this instance, we are multiplying by 5 in order to give us a 20% pour cost markup and that will be the Item_Retail_Cost for the guests. 

use Inventory
create table Inv_Liq_Dist (--The Vendors we get each item from and their respective information.
Dist_ID int Primary Key identity (1,1), --Giving each vendor an ID so it can be uniquely identified. 
Dist_Name nvarchar(50) Not Null,--Name of the Vendor. 
Dist_AddressLine nvarchar(60) Not Null, --Address of the Vendor.
Dist_City nvarchar(30) Not Null,--City of the Vendor.
Dist_PostalCode nvarchar(15) Not Null,--Postal Code of the Vendor. 
Dist_Contact nvarchar(50) Not Null, --The direct contact of the Vendor.
Dist_Email nvarchar(50) Not Null, --Vendor email contact information. 
Dist_Number nvarchar(25) Not Null)--Vendor phone number. 

use Inventory
create table Inv_Liq_Trans (--This table keeps track of the items going out of inventory.
Trans_No Bigint Primary Key identity (1,1),--This represents the transaction number. 
Trans_Date datetime Not Null);--Date and Time of the transaction.

--Adding Constraints.
use Inventory
alter table Inv_Liq_Item
add Dist_ID int not null foreign key (Dist_ID) references Inv_Liq_Dist(Dist_ID),
constraint Item_ML check(Item_ML>205);

use Inventory
alter table Inv_Liq_Trans
add Item_ID int not null foreign key (Item_ID) references Inv_Liq_Item(Item_ID);

--Inserting values into the Inv_Liq_Dist table.
use Inventory
insert into Inv_Liq_Dist
values ('East Side Liq Supply', '101 EastSide Hwy', 'Miami', 33189, 'Julio Jones', 'JJ@ESLS.com', '555-123-4567'),
('West Side Liq Supply', '102 WestSide Hwy', 'Miami', 33157, 'Margarita Morales', 'MM@WSLS.com', '555-965-5746'),
('Midtown Liq Supply', '103 Midway Ln', 'Doral', 33122, 'Will Thompson', 'WT@MLS.com', '555-365-1987'),
('Uptown Liq Supply', '104 Washington Ave', 'Homestead', 33030, 'Lex Diamonds', 'LD@ULS.com', '555-478-5548'),
('Downtown Liq Supply', '105 Michigan St', 'Miami', 33122, 'Johnny Blaze', 'JB@DLS.com', '555-998-8895'),
('New Liq Supply', '106 Clearview Ave', 'Miami', 33177, 'Herman Munster', 'HM@NLS.com', '555-774-5236'), 
('Old Liq Supply', '107 Litigation St', 'Miami', 33166, 'Gabriela Montes', 'GM@OLS.com', '555-332-5812');

--Inserting values into the Inv_Liq_Item table. 
use Inventory
insert into Inv_Liq_Item(item_name, item_ML, item_cost, Item_amount, Dist_ID)
values ('Makers Mark Bourbon', 750, 25.00,2,3),
('Vida Mezcal', 750, 26.50, 1,1),
('Titos Vodka', 1000, 27.25, 12, 7),
('Bombay Sapphire Gin', 750, 32.50, 3, 4), 
('Bacardi Superior Rum', 1000, 15.00, 10, 5),
('Tapatio Reposado Tequila', 750, 40.00, 2, 2),
('Osbourne PX Sherry', 375, 11.00, 2, 6);

--Inserting values into the Inv_Liq_Trans table.
use Inventory
insert into Inv_Liq_Trans
values ('2021-10-01', 3),
('2021-10-02', 2),
('2021-10-03', 7), 
('2021-10-04', 6), 
('2021-10-05', 4), 
('2021-10-06', 3), 
('2021-10-07', 5);



