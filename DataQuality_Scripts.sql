1)Total Record in each table:
SELECT 'customers' AS TableName, COUNT(*) AS TotalRows 
FROM customers
UNION ALL
SELECT 'orders' AS TableName, COUNT(*) AS TotalRows 
FROM orders
UNION ALL
SELECT 'shipping' AS TableName, COUNT(*) AS TotalRows 
FROM shipping;

2) Missing values in Customer and Order:
SELECT
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS No_customer_id,
  SUM(CASE WHEN First IS NULL OR TRIM(First) = '' THEN 1 ELSE 0 END) AS No_first_name,
  SUM(CASE WHEN Last IS NULL OR TRIM(Last) = '' THEN 1 ELSE 0 END) AS No_last_name,
  SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS No_age,
  SUM(CASE WHEN Country IS NULL OR TRIM(Country) = '' THEN 1 ELSE 0 END) AS No_country
FROM customer;

SELECT
  COUNT(*) AS total_orders,
  SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS No_order_id,
  SUM(CASE WHEN Item IS NULL OR TRIM(Item) = '' THEN 1 ELSE 0 END) AS No_item,
  SUM(CASE WHEN Amount IS NULL THEN 1 ELSE 0 END) AS No_amount,
  SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS No_order_customer_ref
FROM order;

3)Check for duplicate Order_IDs 
SELECT Order_ID AS Order, COUNT(*) AS cnt
FROM Order
GROUP BY Order_ID
HAVING COUNT(*) > 1;

4)Order with Customers not found in Customer table and only in order table(orders with no customers -orphaned records)
SELECT o.*
FROM Order o
LEFT JOIN Customer c ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

5)Checking records if there is any other status:
SELECT *
FROM Shippings
WHERE Status NOT IN ('Pending', 'Delivered');


6)To clean the data and remove those first names that have :@,! etc:(same thing for last name)
To see what are the records that have bad first name(we can later do a count on this query to find the number of such records):

SELECT customer_id, first
FROM customer
WHERE first <> '%[^A-Za-z .-]%';---good records

SELECT customer_id, last
FROM customer
WHERE last NOT LIKE '%[^A-Za-z .-]%'; 

DELETE FROM customers
WHERE first LIKE '%[^A-Za-z .-]%';
7)Strange records:
SELECT *
FROM customer
WHERE age < 0 or age>110;


8)Shipping records without customers:
SELECT s.*
FROM shipping s
LEFT JOIN customer c ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

9)Multiple entry:
SELECT customer_id, COUNT(*) AS dup_count
FROM customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

10)Duplicate record:
SELECT order_id, COUNT(*) AS dup_count
FROM order
GROUP BY order_id
HAVING COUNT(*) > 1;

11)Country wise Customers:
SELECT DISTINCT country, COUNT(*) AS cnt
FROM customer
GROUP BY country
ORDER BY cnt DESC;

12)Fishy data when Shipping info of the customer order in Shipping but not in order table:
SELECT s.customer_id
FROM shipping s
LEFT JOIN order o ON s.customer_id = o.customer_id
WHERE o.customer_id IS NULL;
