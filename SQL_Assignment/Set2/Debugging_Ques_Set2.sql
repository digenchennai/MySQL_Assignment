CREATE DATABASE employee_set2;
use employee_set2;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    salary INT,
    department_id INT
);

INSERT INTO employees (employee_id, name, age, salary, department_id) VALUES
(1, 'John', 30, 60000, 101),
(2, 'Emily', 25, 48000, 102),
(3, 'Michael', 40, 75000, 103),
(4, 'Sara', 35, 56000, 101),
(5, 'David', 28, 49000, 102);

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

INSERT INTO departments (department_id, department_name) VALUES
(101, 'HR'),
(102, 'Finance'),
(103, 'IT'),
(104, 'Marketing');


CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO sales (sale_id, customer_id, amount, sale_date) VALUES
(1, 101, 4500.00, '2023-03-15'),
(2, 102, 5500.00, '2023-03-16'),
(3, 103, 7000.00, '2023-03-17'),
(4, 104, 3000.00, '2023-03-18'),
(5, 105, 6000.00, '2023-03-19');

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

INSERT INTO customers (customer_id, customer_name) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Alice Johnson'),
(104, NULL),
(105, 'Robert Brown');

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price INT
);

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Laptop', 1000),
(2, 'Mobile', 500),
(3, 'Tablet', 300),
(4, 'Headphones', 100),
(5, 'Smartwatch', 200);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    order_date DATE,
    order_amount INT
);

INSERT INTO orders (order_id, customer_name, order_date, order_amount) VALUES
(1, 'John', '2023-05-01', 500),
(2, 'Emily', '2023-05-02', 700),
(3, 'Michael', '2023-05-03', 1200),
(4, 'Sara', '2023-05-04', 450),
(5, 'David', '2023-05-05', 900);


-- 1. Retrieve Employees in Finance Department
-- Incorrect Code
-- SELECT name, salary FROM employees WHERE department_id = 'Finance';
select * from employees;
select * from departments;

select employees.name,employees.salary from employees
LEFT JOIN departments on employees.department_id = departments.department_id where departments.department_name = 'Finance';


-- 2. Calculate Total Sales for Each Customer
-- Incorrect Code
-- SELECT customer_name, SUM(amount) AS total_sales
-- FROM sales
-- GROUP BY customer_name;

SELECT customer_name, SUM(amount) AS total_sales FROM sales
LEFT JOIN customers on sales.customer_id = customers.customer_id WHERE customers.customer_name IS NOT NULL GROUP BY customers.customer_name;

-- 3. Find Products Priced Over the Average Price
-- Incorrect Code
-- SELECT product_name, price
-- FROM products
-- WHERE price > AVG(price);

SELECT product_name, price FROM products WHERE price > (select AVG(price) from products);

-- 4. Get Customers Who Have Placed Orders Over 1000
-- Incorrect Code
-- SELECT DISTINCT customer_name
-- FROM orders
-- WHERE order_amount = 1000;
select * from orders;
SELECT customer_name,order_amount from orders WHERE order_amount > 1000;

-- 5. Find Total Sales for Each Customer
-- Incorrect Code
--SELECT customer_id, SUM(amount) 
--FROM sales;  -- Missing GROUP BY for aggregation

SELECT customer_id, SUM(amount) FROM sales GROUP BY customer_id;