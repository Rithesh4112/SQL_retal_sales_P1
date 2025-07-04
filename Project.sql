CREATE DATABASE sql_project_p2;

CREATE TABLE retail_sales           
             (
 transactions_id INT PRIMARY KEY, 
 sale_date DATE,
 sale_time TIME,
 customer_id INT,
 gender VARCHAR(15),
 age INT,
 category VARCHAR(25),
 quantiy INT,
 price_per_unit FLOAT,
 cogs FLOAT,
 total_sale FLOAT
                 );

SELECT 
*
FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL 
OR
 sale_time IS NULL
 OR
 customer_id IS NULL
 OR
 gender IS NULL
 OR
 age IS NULL
 OR
 category IS NULL
 OR
 quantiy IS NULL
 OR
 price_per_unit IS NULL
 OR
 cogs IS NULL
 OR
 total_sale IS NULL;

DELETE  FROM retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL 
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

SELECT COUNT(DISTINCT customer_id) as toatl_sales FROM retail_sales

--1Q)columns from the date 2022-11-05
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--2)All the transactions where the catogorie is clothing and quantity is more than 4 in nov-2022
SELECT * 
FROM retail_sales
WHERE  category='clothing' 
AND To_CHAR(sale_date,'YYYY-MM')='2022-11'
AND quantiy >= 4
--3Q) write a query to calculate the total scale for each category

SELECT 
category,
SUM(total_sale) as net_sale
FROM retail_sales
GROUP BY 1
--4Q)Find the avg age of the customer who purchased from the beauty
SELECT 
Round(AVG(age),2) as avg_age
FROM retail_sales
WHERE category='Beauty'

--5Q)Find all the transactions where total sales is gtreater than 1000
SELECT *
FROM retail_sales
WHERE total_sale >1000

--6Q)total no of transactions made by each gender in each categorie
SELECT category,gender,
COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category,gender
ORDER BY 1

--7Q)calculate the avg sale for each month,Find out the best selling month in each year
SELECT *from(
SELECT 
EXTRACT(year from sale_date) as year,
EXTRACT(month from sale_date) as month,avg(total_sale),
RANK() OVER(
PARTITION BY EXTRACT(year from sale_date)
ORDER BY AVG(total_sale)DESC
) 
FROM retail_sales
GROUP BY 1,2
) as t1
WHERE rank=1

--8Q) find the top 5 customers based on the total highest sales
SELECT customer_id,SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--9Q)Number of unique customers who purchased items from each category
SELECT 
category,
COUNT(customer_id)
FROM retail_sales
GROUP BY category

--10Q)create each shift and number of orders (morning<=12, Afternoon Between 12 & 17,Evening >17)
WITH hourly_sale
AS
(
SELECT *,
CASE
WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN'Afternoon'
ELSE 'Evening'
END as shift
FROM retail_sales
)
SELECT
shift,
COUNT(*) as taotal_orders
FROM hourly_sale
GROUP BY shift