-- SQL Retail Sales Analysis 
CREATE DATABASE sql_project2


-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
	  transactions_id INT PRIMARY KEY,
	  sale_date DATE,
	  sale_time	TIME,
	  customer_id INT,	
	  gender VARCHAR(15),
	  age	INT,
	  category	VARCHAR(25),
	  quantiy	INT,
	  price_per_unit FLOAT,	
	  cogs	FLOAT,0
	  total_sale FLOAT
	);


-- Data Cleaning
DELETE FROM retail_sales
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
	total_sale IS NULL ;


-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sales FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT (DISTINCT customer_id) FROM retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05' ;

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing' 
GROUP BY transactions_id
HAVING  quantiy > 3 AND TO_CHAR(sale_date,'MM-YYYY') = '11-2022';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,SUM(total_sale) AS Total
FROM retail_sales
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty' ;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT transactions_id AS transactions FROM retail_sales
WHERE total_sale > 1000 ;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT  gender, category,COUNT(*) FROM retail_sales
GROUP BY category, gender
ORDER BY category;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	year,
	month,
	total_sales		
FROM(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		ROUND(AVG(total_sale::numeric),2) as total_sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM 
	retail_sales
GROUP BY
	year, 
	month
) 
WHERE 
	rank = 1 ;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id,
    total_sales
FROM (
    SELECT 
        customer_id,
        SUM(total_sale) AS total_sales,
        RANK() OVER (ORDER BY SUM(total_sale) DESC) AS rank
    FROM 
        retail_sales
    GROUP BY 
        customer_id
) AS subquery
WHERE 
    rank <= 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	COUNT(DISTINCT customer_id) AS no_of_customers,
	category
FROM
	retail_sales
GROUP BY 
	category 
ORDER BY
	category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
	CASE
	WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
	END as shift
FROM
	retail_sales
)
SELECT
	COUNT(*),
	shift
FROM
	hourly_sale
GROUP BY
	shift ;


-- END OF THE PROJECT --












