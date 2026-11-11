CREATE DATABASE scenario_set2;
use scenario_set2;
CREATE TABLE employee_salary_history (
    employee_id INT,
    employee_name VARCHAR(50),
    salary_year INT,
    salary DECIMAL(10,2),
    PRIMARY KEY (employee_id, salary_year)
);

INSERT INTO employee_salary_history VALUES
(101,'John',2021,50000),
(101,'John',2022,55000),
(101,'John',2023,60000),
(101,'John',2024,65000),

(102,'Alice',2021,70000),
(102,'Alice',2022,72000),
(102,'Alice',2023,71000),
(102,'Alice',2024,75000),

(103,'Bob',2021,45000),
(103,'Bob',2022,48000),
(103,'Bob',2023,52000),
(103,'Bob',2024,55000),

(104,'Carol',2021,60000),
(104,'Carol',2022,60000),
(104,'Carol',2023,62000),
(104,'Carol',2024,65000);


CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    customer_id INT,
    purchase_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO customers VALUES
(1,'Raj'),
(2,'Priya'),
(3,'Kumar'),
(4,'Anita'),
(5,'Vijay');

INSERT INTO purchases VALUES
(101,1,'2024-01-15',500),
(102,1,'2024-03-20',1000),

(103,2,'2024-09-10',1500),
(104,2,'2024-10-15',1200),

(105,3,'2024-02-15',800),
(106,3,'2024-11-05',900),

(107,4,'2024-08-01',700),
(108,4,'2024-10-10',900),

(109,5,'2024-04-12',600);


CREATE TABLE product_sales (
    product_id INT,
    product_name VARCHAR(50),
    sales_month DATE,
    sales_amount DECIMAL(10,2)
);

INSERT INTO product_sales VALUES
(1,'Laptop','2024-09-01',100000),
(1,'Laptop','2024-10-01',90000),

(2,'Mobile','2024-09-01',80000),
(2,'Mobile','2024-10-01',50000),

(3,'Keyboard','2024-09-01',40000),
(3,'Keyboard','2024-10-01',39000),

(4,'Monitor','2024-09-01',70000),
(4,'Monitor','2024-10-01',45000);


CREATE TABLE monthly_sales (
    product_id INT,
    product_name VARCHAR(50),
    sales_month DATE,
    sales_amount DECIMAL(10,2)
);

INSERT INTO monthly_sales VALUES
(1,'Laptop','2024-01-01',50000),
(1,'Laptop','2024-02-01',55000),
(1,'Laptop','2024-03-01',60000),
(1,'Laptop','2024-04-01',70000),
(1,'Laptop','2024-05-01',65000),
(1,'Laptop','2024-06-01',80000),

(2,'Mobile','2024-01-01',30000),
(2,'Mobile','2024-02-01',35000),
(2,'Mobile','2024-03-01',32000),
(2,'Mobile','2024-04-01',40000),
(2,'Mobile','2024-05-01',42000),
(2,'Mobile','2024-06-01',45000);

CREATE TABLE customer_details (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(15)
);

INSERT INTO customer_details VALUES
(1,'Raj','raj@gmail.com','9876543210'),
(2,'Priya','priya@gmail.com','9876543211'),
(3,'Kumar','kumar@gmail.com','9876543212'),

(4,'Rajesh','raj@gmail.com','9876543210'),

(5,'Anita','anita@gmail.com','9876543215'),

(6,'Anitha','anita@gmail.com','9876543215'),

(7,'Vijay','vijay@gmail.com','9876543217');


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50)
);


CREATE TABLE sales_history (
    sale_id INT PRIMARY KEY,
    product_id INT,
    sale_month DATE,
    quantity INT
);

INSERT INTO products VALUES
(1,'Laptop'),
(2,'Mobile'),
(3,'Keyboard'),
(4,'Monitor');


INSERT INTO sales_history VALUES
(1,1,'2024-01-01',10),
(2,1,'2024-02-01',12),
(3,1,'2024-03-01',15),
(4,1,'2024-04-01',20),

(5,2,'2024-01-01',25),
(6,2,'2024-05-01',22),

(7,3,'2024-01-01',15),
(8,3,'2024-02-01',12),
(9,3,'2024-06-01',18),

(10,4,'2024-01-01',30),
(11,4,'2024-02-01',32),
(12,4,'2024-03-01',35),
(13,4,'2024-04-01',38);

-- Scenario 1: Identify Consistent High Performers
-- Question: Find employees who have consistently received a salary increase for the past 3 years.
select * from employee_salary_history;

WITH emp AS (select *, LAG(salary) OVER (PARTITION BY employee_id ORDER BY salary_year) as previous_salary from employee_salary_history) SELECT *
FROM emp WHERE salary > previous_salary; 


-- Scenario 2: Customer Retention Analysis
-- Question: Find customers who made purchases in the last 6 months but not in the previous 6 months.
select * from customers;
select * from purchases;

UPDATE purchases set purchase_date = '2026-02-15' where amount > 1000;

select customers.customer_name from customers
WHERE EXISTS (SELECT 3 FROM purchases where customers.customer_id = purchases.customer_id AND purchase_date <= CURDATE() - INTERVAL 6 MONTH)
AND NOT EXISTS (select 3 FROM purchases where customers.customer_id = purchases.customer_id AND purchase_date <= CURDATE() - INTERVAL 12 MONTH
AND purchase_date < CURDATE() - INTERVAL 6 MONTH);



-- Scenario 3: Identify Products with Declining Sales
-- Question: Find products whose sales decreased by more than 30% compared to the previous month.
select * from monthly_sales;
select * from product_sales;


WITH sales_comparison AS (
    SELECT
        product_id,
        product_name,
        sales_month,
        sales_amount,
        LAG(sales_amount) OVER (
            PARTITION BY product_id
            ORDER BY sales_month
        ) AS previous_month_sales
    FROM product_sales
)
SELECT
    product_id,
    product_name,
    sales_month,
    previous_month_sales,
    sales_amount
FROM sales_comparison
WHERE previous_month_sales IS NOT NULL
  AND sales_amount < previous_month_sales * 0.7;

-- Scenario 4: Calculate Moving Average of Sales
-- Question: Calculate a 3-month moving average for product sales.

select product_name,sales_month,sales_amount,AVG(sales_amount) OVER (PARTITION BY Product_name ORDER BY sales_month  
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as Avg_amount from product_sales;

-- Scenario 5: Detect Duplicate Records
-- Question: Find all duplicate records from a customer table based on email and phone number.
WITH cus AS (
    SELECT *, 
        ROW_NUMBER() OVER (
            PARTITION BY email ORDER BY customer_id
        ) AS dup
    FROM customer_details
)
SELECT * 
FROM cus 
WHERE dup > 1;

-- Scenario 6: Identify Products with No Sales for 3 Consecutive Months
-- Question: List products that have not had any sales for 3 consecutive months.

select * from product_sales;

WITH monthly_sales AS (
    SELECT DISTINCT
           product_id,
           DATE_FORMAT(sale_date, '%Y-%m-01') AS sale_month
    FROM sales
),
sales_gap AS (
    SELECT product_id,
           sale_month,
           LEAD(sale_month) OVER (
               PARTITION BY product_id
               ORDER BY sale_month
           ) AS next_sale_month
    FROM monthly_sales
)
SELECT DISTINCT product_id
FROM sales_gap
WHERE TIMESTAMPDIFF(MONTH, sale_month, next_sale_month) > 3;
