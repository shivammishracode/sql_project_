CREATE DATABASE retail_sales;
USE retail_sales;
-- Tables 
DROP TABLE IF EXISTS retail_tab;
create table retail_tab(
  transactions_id INT PRIMARY KEY,
  sale_date DATE,
  sale_time TIME,
  customer_id INT,
  gender VARCHAR(15),
  age INT,
  category VARCHAR(15),
  quantiy INT,
  price_per_unit FLOAT,
  cogs  FLOAT,
  total_sale FLOAT
);

SELECT * FROM retail_tab
WHERE
	transactions_id IS NULL
    or
    sale_date IS NULL
	or
    sale_time IS NULL
    or
    customer_id IS NULL
    or
    gender IS NULL
    or
    age IS NULL
    or
    category IS NULL
    or
    quantiy IS NULL
    or
    price_per_unit IS NULL
    or
    cogs IS NULL
    or
    total_sale IS NULL;
    
-- DATA Exploration 

-- how may customer we have ?
 SELECT COUNT(DISTINCT customer_id) AS "No of customer" FROM retail_tab;
 
 -- how many sales done?
 SELECT COUNT(*) AS "TOTAL SALES" FROM retail_tab;
 
 -- how many types of category ?
 SELECT COUNT(DISTINCT category) FROM retail_tab;
 
 -- how many quantity of each catagory 
SELECT category AS Name, COUNT(*) AS Total_Quantity
FROM retail_tab 
GROUP BY category;

-- Q1. write sql qery to retrive all the columns of sale made on "2022-11-05"
SELECT *
FROM retail_tab
WHERE sale_date="2022-11-05";

-- Q2. write query to count total sales made on "2022-11-05"
SELECT COUNT(*)
FROM retail_tab
WHERE sale_date="2022-11-05";

-- Q3. write a query for total amount of sales made on "2022-11-05"
SELECT SUM(total_sale)
FROM retail_tab
WHERE sale_date='2022-11-05';

-- Q4. write a query for total amount of sale on every date 

SELECT SUM(total_sale) as Sales,sale_date as Date
FROM retail_tab
group by sale_date;

-- Q5. write a query for total no. of sale on every date 

SELECT COUNT(total_sale) as Sales,sale_date as Date
FROM retail_tab
group by sale_date
order by Sales desc;

-- Q6. write sql query to retrieve all the transcaction of category 'clothing ' and the quantity sold is less than 5  in the month of nov-2022
SELECT *
FROM retail_tab
WHERE category='clothing' AND quantiy <3
	AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Q7. Write a sql query total sale for each category 
SELECT SUM(total_sale),category ,count(*)
FROM retail_tab
group by 2; -- alter group by category 2--> column category 

-- Q8.write sql query for finding avrage age of customer who purchased category ='beauty' 
select round(avg(age),2) as "Age of customer" ,category
from retail_tab 
where category='Beauty';

-- Q8.write sql query for finding avrage age of customer;
select round(avg(age),2) as "Age of customer" ,category
from retail_tab 
group by 2;

-- Q8 .Wrute Sql query where total sale is greter than 1000
select *
from retail_tab
where total_sale>1000;

-- - Q.9 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender, category, COUNT(transactions_id) AS total_transactions
FROM retail_tab
GROUP BY gender, category
order by 1;

-- Q.10 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        round(AVG(total_sale),2) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_tab
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS ranked_data
WHERE rnk = 1;

-- Q.11 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_tab
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.12 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_tab
GROUP BY category;

-- Q.13 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_tab
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

    