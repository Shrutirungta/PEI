README.txt file - Data Analyst Project
Author: Shruti Rungta
Date: 08/10/2025
Version:1.0
=============================
Project Overview
----------------
This project is about analyzing and preparing datasets from different sources to meet the reporting needs of a business.

There are three datasets involved: `Customer`, `Order`, and `Shipping`.
The work is divided into three main steps:

1) Data Verification & Validation – Check if the data from the source is accurate, complete, and reliable.
2) Requirements & Domain Model Definition – Decide what data elements and their connections are needed for the business reporting.
3) Technical Specification for Implementation – Create a detailed plan that helps a Data Engineer build the tables and also helps a QA engineer test it.

Data Sources
------------
1.
**Customer**
- Customer_ID (INT) – This is a unique number for each customer.
- First (VARCHAR) – This is the customer’s first name.
- Last (VARCHAR) – This is the customer’s last name.
- Age (INT) – This is the customer’s age.
- Country (VARCHAR) – This is the country where the customer lives.

2.
**Order**
- Order_ID (INT) (Primary Key) – This is a unique number for each order.
- Item (VARCHAR) – This is the name or description of the product or service bought.
- Amount (DECIMAL) – This shows the total money spent on the order.
- Customer_ID (INT) (Foreign Key) – This links the order to the customer.

3.
**Shipping**
- Shipping_ID (INT) (Primary Key) – This is a unique number for each shipping record.
- Status (VARCHAR) – This shows the current status of the shipping (like Pending, Delivered, or Cancelled).
- Customer_ID (INT) (Foreign Key) – This links the shipping record to the customer.

Relationships:
A customer can place multiple orders (this is a 1-to-many relationship).
A customer can also have multiple shipping records (again, a 1-to-many relationship).
Orders and Shipping are connected through the Customer_ID.


Data Location
-------------
Download the datasets from the following Google Drive link:
https://drive.google.com/drive/folders/1cfVJx6IicqLNKwWUIJG-O-htpTK3R-tE?usp=sharing

**Part 1 – Data Verification**
----------------------------
Goal: Make sure the data is correct and can be used for reporting and analysis.


Checks Performed:
1) Accuracy: Checked if the values in columns like First Name, Last Name, Amount, etc., are valid and match the correct data types.
2) Completeness: Checked for any missing data in important fields like Customer ID, Product ID, Country, and Transaction Date.
3) Reliability: Compared the data against business rules, like Age being a positive number, Customer IDs not being repeated, and dates not being in the future.

Output:
The results are shown using SQL queries that display any problems found, missing data, and summaries of data distribution.

**Part 2 – Requirements & Domain Model**
--------------------------------------
Goal: Based on findings from Part 1, figure out the structure of data needed to meet the business reporting needs.

Deliverables
------------
Anticipated Datasets: List of tables or entities needed, along with key columns, data types, and expected rules.
Proposed Domain Model: A description or diagram of how the datasets are connected (like Customers, Orders, Products, and Countries).

**Part 3 – Technical Specification**
--------------------------------
Goal: Create a detailed guide for building one table from the data model.

Acceptance Criteria
-------------------
- All data transformations should check the accuracy, completeness, and reliability of raw data.
- Define and describe the datasets needed, including the proposed domain model to support the reporting needs.
- The guide should have enough information so a Data Engineer can build the table and a QA engineer can test it.

Business Reporting Requirements Enabled
---------------------------------------
The final data model should support:
- Total spending and country for “Pending delivery” status, grouped by country.

- Total transactions, total quantity sold, and total spending for each customer, along with product details.
- The most purchased product in each country.
- The most purchased product, broken down by age group (under 30 and 30 or older).
- The country with the least number of transactions and sales.

Tools & Technologies Used
-------------------------
- SQL (PostgreSQL, MySQL, or another specified database)

Deliverables
------------
- SQL scripts showing the data checks.
- A documented definition of the datasets needed.
- A domain model diagram.
- One detailed story for a part of the data model.
- This README file for reference.


Assumptions
-----------
- Customer_ID is the main key in the `Customer` table and also a link in both `Order` and `Shipping` tables.
- The Amount in the `Order` table represents the total money spent on the order.
- The delivery status is stored in the `Shipping` table under the `Status` column.

Contact
-------
For any questions or clarifications about the data or requirements, contact the project owner.
