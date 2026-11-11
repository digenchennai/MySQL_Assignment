CREATE DATABASE AmazonDB;

USE AmazonDB;

CREATE TABLE Users(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    registered_date DATE NOT NULL,
    membership ENUM('Basic', 'Prime') DEFAULT 'Basic'
);

CREATE TABLE Products(
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(100) NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE Orders(
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL
);

CREATE TABLE OrderDetails(
    order_details_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT, 
    product_id INT, 
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Users (name, email, registered_date, membership) VALUES
('Alice Johnson', 'alice.j@example.com', '2024-01-15', 'Prime'),
('Bob Smith', 'bob.s@example.com', '2024-02-01', 'Basic'),
('Charlie Brown', 'charlie.b@example.com', '2024-03-10', 'Prime'),
('Daisy Ridley', 'daisy.r@example.com', '2024-04-12', 'Basic');

INSERT INTO Products (name, price, category, stock) VALUES
('Echo Dot', 49.99, 'Electronics', 120),
('Kindle Paperwhite', 129.99, 'Books', 50),
('Fire Stick', 39.99, 'Electronics', 80),
('Yoga Mat', 19.99, 'Fitness', 200),
('Wireless Mouse', 24.99, 'Electronics', 150);

INSERT INTO Orders (user_id, order_date, total_amount) VALUES
(1, '2024-05-01', 79.98),
(1, '2024-05-01', 79.98),
(2, '2024-05-03', 129.99),
(1, '2024-05-04', 49.99),
(3, '2024-05-05', 24.99);

UPDATE orders set order_date = '2026-10-01' where user_id = 3;

INSERT INTO OrderDetails (order_id, product_id, quantity) VALUES
(1, 1, 2),
(2, 2, 1),
(3, 1, 1),
(4, 5, 1);

select * from users;
select * from Products;
select * from Orders;
select * from OrderDetails;

-- 1. List all customers who have made purchases of more than $80.--
select users.user_id, users.name,orders.Total_amount from users LEFT JOIN orders ON users.user_id = orders.user_id where orders.total_amount > 80;

-- 2. Retrieve all orders placed in the last 280 days along with the customer name and email.
select users.user_id,users.name, users.email,orders.order_date from users 
LEFT JOIN orders on users.user_id = orders.user_id where order_date >= CURDATE() - INTERVAL 280 DAY;

-- 3.Find the average product price for each category.--
select category,avg(price) as price from products GROUP by category;

-- 4.List all customers who have purchased a product from the category Electronics.--
select users.user_id,users.name as user_name,products.product_id,products.name as product_name,products.category from products 
LEFT JOIN orderdetails on products.product_id = orderdetails.product_id
LEFT JOIN orders on orders.order_id = orderdetails.order_id
LEFT JOIN users on orders.user_id = users.user_id where products.category = "Electronics" and users.user_id is NOT NULL;

-- 5.Find the total number of products sold and the total revenue generated for each product.--
select products.name as product_name,orderdetails.quantity,orders.total_amount from orderdetails
LEFT JOIN orders on orderdetails.order_id = orders.order_id
LEFT JOIN products on orderdetails.product_id = products.product_id;

-- 6.Update the price of all products in the Books category, increasing it by 10%.--
select * from products;
update products set price = price * 1.10 where category = "Books";
select * from products;

-- Query.--
-- 7.Remove all orders that were placed before 2020.--
select * from orders;
delete from orders where YEAR(order_date) < 2020;

-- 8.Write a query to fetch the order details, including customer name, product name, and quantity, for orders placed on 2024-05-01.--
select users.name,products.name,orderdetails.order_details_id,orderdetails.order_id,orderdetails.product_id,orderdetails.quantity from orderdetails
LEFT JOIN orders on orders.order_id = orderdetails.order_id
LEFT JOIN products on products.product_id = orderdetails.product_id
LEFT JOIN users on orders.user_id = users.user_id where orders.order_date = '2024-05-01'; 

-- 9.Fetch all customers and the total number of orders they have placed.--
select users.name,count(orders.order_id) as total_number_orders from users 
LEFT JOIN orders on users.user_id = orders.user_id GROUP by users.name;

-- 10.Retrieve the average rating for all products in the Electronics category.--
select * from products;
ALTER TABLE products ADD COLUMN rating DECIMAL(2,1);
UPDATE products set rating = 4.7 where category = "Fitness";
select category,avg(rating) from products GROUP by category;

-- 11.List all customers who purchased more than 1 units of any product, including the product name and total quantity purchased.--
select users.name as user_name,products.name as product_name,products.category,orderdetails.quantity from orderdetails
LEFT JOIN orders on orders.order_id = orderdetails.order_id
LEFT JOIN products on products.product_id = orderdetails.product_id
LEFT JOIN users on orders.user_id = users.user_id where orderdetails.quantity >= 2; 

-- 12.Find the total revenue generated by each category along with the category name.--
select products.category, SUM(orders.total_amount) from orderdetails
LEFT JOIN products on products.product_id = orderdetails.product_id
LEFT JOIN orders on orders.order_id = orderdetails.order_id GROUP BY products.category;
