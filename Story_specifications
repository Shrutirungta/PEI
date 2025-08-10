Story Title:
------------
Build Fact_Order table from raw order data

Story:
------
I want a cleaned and validated Fact_Order table so that  Business Reporting Requirements can be fulfilled using this fact further.

Source:
------
Order.csv → contains Order_ID, Item, Amount, Customer_ID
Dim_Customer → for validating Customer_ID
Dim_Shipping → for obtaining Shipping detail
Target:

Column	        Type	Rules
Order_ID(PK)	INT	    Unique, not null
Customer_ID(FK)	INT  	Exists in Dim_Customer
Item	        VARCHAR	Trimmed, cleaned
Amount	        DECIMAL	> 0

Data Transformations & Cleansing Steps
Remove duplicates: Keep only distinct Order_ID rows since it is the primary key.

Clean Item:
----------
Remove the leading/trailing spaces.
Normalize spaces (replace multiple spaces with a single space).
Remove rows with null or empty Item values.
Exclude items containing invalid characters (allow only letters, digits, spaces, dots, and hyphens).
Validate Customer_ID: Exclude orders where Customer_ID does not exist in Dim_Customer.
Filter Amount: Exclude rows where Amount is null, zero, or negative.

Example-(SQL):
------------
CREATE TABLE Fact_Order (
    Order_ID INT PRIMARY KEY,
    Item VARCHAR(255),
    Amount DECIMAL(10, 2),
    Customer_ID INT,
    Shipping_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES Dim_Customer(Customer_ID),
    FOREIGN KEY (Shipping_ID) REFERENCES Dim_Shipping(Shipping_ID)
);
INSERT INTO Fact_Order (Order_ID, Item, Amount, Customer_ID, Shipping_ID)
SELECT DISTINCT
    o.Order_ID,
    TRIM(REGEXP_REPLACE(o.Item, ' +', ' ')) AS Item,
    o.Amount,
    o.Customer_ID,
    s.Shipping_ID
FROM orders o
JOIN Dim_Shipping s ON o.Order_ID = s.Order_ID
WHERE o.Amount > 0
  AND o.Item IS NOT NULL
  AND TRIM(o.Item) <> ''
  AND o.Item REGEXP '^[A-Za-z0-9 .-]+$';


QA Checkpoints:
----------------
Primary Key Uniqueness:(difference of the record count totla - distinct =0)
-----------------------
SELECT COUNT(*) - COUNT(DISTINCT Order_ID) AS duplicate_orders
FROM Fact_Order;
-- Expected: 0

Foreign Key Check:(no customer_id that is not present in dim customer)
---------------------
SELECT COUNT(*) AS missing_customers
FROM Fact_Order fo
LEFT JOIN Dim_Customer dc ON fo.Customer_ID = dc.Customer_ID
WHERE dc.Customer_ID IS NULL;
-- Expected: 0

Amount Check(amount value greater than 0):
-----------------
SELECT COUNT(*) AS invalid_amounts
FROM Fact_Order
WHERE Amount <= 0;
-- Expected: 0


Item Formatting-(should not start or end with spaces or have any places chars):
---------------
SELECT COUNT(*) AS bad_item_names
FROM Fact_Order
WHERE Item LIKE ' %' OR Item LIKE '% ' OR Item REGEXP '[^A-Za-z0-9 .-]';
-- Expected: 0


We will also have to create views as the report requires few transformations needed to derive as Business requirements:

1. Total amount spent and the country for the "Pending" status for countrywise
Transformation needed:
---------------------
CREATE VIEW vw_country_pending_delivery_spend AS
SELECT  
    dcust.Country AS Country,
    SUM(forder.Amount) AS Amount_Spent_Pending
FROM Fact_Order forder
JOIN Dim_Shipping dship ON forder.Shipping_ID = dship.Shipping_ID
JOIN Dim_Customer dcust ON forder.Customer_ID = dcust.Customer_ID
WHERE dship.Status = 'Pending'
GROUP BY dcust.Country;


2. Total number of transactions, total quantity sold, total amount spent for each customer along with product details
Transformation needed:
---------------------
CREATE VIEW vw_customer_product_summary AS
SELECT 
    fo.Customer_ID,
    dc.Customer_Name,
    fo.Item AS Product,
    COUNT(DISTINCT fo.Order_ID) AS Total_Transactions,
    COUNT(*) AS Total_Quantity_Sold,   
    SUM(fo.Amount) AS Total_Amount_Spent
FROM Fact_Order fo
JOIN Dim_Customer dc ON fo.Customer_ID = dc.Customer_ID
GROUP BY fo.Customer_ID, dc.Customer_Name, fo.Item;

3. Maximum product purchased for each country
Transformation needed:
---------------------
CREATE VIEW vw_max_product_by_country AS
WITH Product_Sales AS (
    SELECT 
        dc.Country,
        fo.Item AS Product,
        COUNT(*) AS Quantity_Sold
    FROM Fact_Order fo
    JOIN Dim_Customer dc ON fo.Customer_ID = dc.Customer_ID
    GROUP BY dc.Country, fo.Item
),
Max_Product AS (
    SELECT
        Country,
        MAX(Quantity_Sold) AS Max_Quantity
    FROM Product_Sales
    GROUP BY Country
)
SELECT 
    ps.Country,
    ps.Product,
    ps.Quantity_Sold
FROM Product_Sales ps
JOIN Max_Product mp
  ON ps.Country = mp.Country
 AND ps.Quantity_Sold = mp.Max_Quantity
ORDER BY ps.Country;

4. Most purchased product based on age category (<30 and >=30)
Transformation:
--------------
CREATE VIEW vw_top_product_by_age_category AS
WITH Age_Category_Sales AS (
    SELECT
        CASE WHEN dc.Age < 30 THEN '<30' ELSE '>=30' END AS Age_Category,
        fo.Item AS Product,
        COUNT(*) AS Quantity_Sold
    FROM Fact_Order fo
    JOIN Dim_Customer dc ON fo.Customer_ID = dc.Customer_ID
    GROUP BY Age_Category, fo.Item
),
Max_Product AS (
    SELECT
        Age_Category,
        MAX(Quantity_Sold) AS Max_Quantity
    FROM Age_Category_Sales
    GROUP BY Age_Category
)
SELECT 
    acs.Age_Category,
    acs.Product,
    acs.Quantity_Sold
FROM Age_Category_Sales acs
JOIN Max_Product mp
  ON acs.Age_Category = mp.Age_Category
 AND acs.Quantity_Sold = mp.Max_Quantity
ORDER BY acs.Age_Category;
5. Country with minimum transactions and sales amount
Transformation:
--------------
CREATE VIEW vw_country_with_min_trans_and_sales AS
WITH Country_Transactions AS (
    SELECT 
        dc.Country,
        COUNT(DISTINCT fo.Order_ID) AS Total_Transactions
    FROM Fact_Order fo
    JOIN Dim_Customer dc ON fo.Customer_ID = dc.Customer_ID
    GROUP BY dc.Country
),
Min_Transactions AS (
    SELECT MIN(Total_Transactions) AS Min_Trans FROM Country_Transactions
)
SELECT ct.Country, ct.Total_Transactions
FROM Country_Transactions ct
JOIN Min_Transactions mt ON ct.Total_Transactions = mt.Min_Trans;

-- Minimum sales amount country
WITH Country_Sales AS (
    SELECT 
        dc.Country,
        SUM(fo.Amount) AS Total_Sales
    FROM Fact_Order fo
    JOIN Dim_Customer dc ON fo.Customer_ID = dc.Customer_ID
    GROUP BY dc.Country
),
Min_Sales AS (
    SELECT MIN(Total_Sales) AS Min_Sales FROM Country_Sales
)
SELECT cs.Country, cs.Total_Sales
FROM Country_Sales cs
JOIN Min_Sales ms ON cs.Total_Sales = ms.Min_Sales;


Acceptance Criteria:
-------------------
All rules applied, QA checks passed, table ready for reporting.

Dependencies:
------------
Dim_Customer has to be built and validated before Fact_Order load.
Source file Order.csv should be available and preloaded in the staging area.


