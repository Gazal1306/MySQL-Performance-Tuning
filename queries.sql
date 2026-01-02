-- ================================
-- SQL PERFORMANCE OPTIMIZATION
-- ================================

-- Create database
CREATE DATABASE perf_test;
USE perf_test;

-- ----------------
-- Create tables
-- ----------------
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  city VARCHAR(50),
  created_at DATETIME
);

CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  amount DECIMAL(10,2),
  status VARCHAR(20),
  created_at DATETIME
);

-- ----------------
-- Insert sample data
-- ----------------
INSERT INTO users (name, city, created_at)
SELECT
  CONCAT('User', n),
  ELT(FLOOR(1 + RAND()*3), 'Delhi','Mumbai','Pune'),
  NOW()
FROM (
  SELECT @row := @row + 1 AS n
  FROM information_schema.tables, (SELECT @row := 0) r
  LIMIT 50000
) t;

INSERT INTO orders (user_id, amount, status, created_at)
SELECT
  FLOOR(1 + RAND()*50000),
  ROUND(RAND()*5000, 2),
  ELT(FLOOR(1 + RAND()*3), 'completed','pending','cancelled'),
  NOW()
FROM information_schema.tables
LIMIT 200000;

-- ----------------
-- Slow query (BEFORE)
-- ----------------
SELECT u.city,
       COUNT(o.id) AS total_orders,
       SUM(o.amount) AS total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'completed'
GROUP BY u.city;

-- EXPLAIN before optimization
EXPLAIN
SELECT u.city,
       COUNT(o.id),
       SUM(o.amount)
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'completed'
GROUP BY u.city;

-- ----------------
-- Index optimization
-- ----------------
CREATE INDEX idx_orders_user_status
ON orders(user_id, status);

CREATE INDEX idx_users_city
ON users(city);

-- ----------------
-- Optimized query (AFTER)
-- ----------------
SELECT u.city,
       COUNT(o.id) AS total_orders,
       SUM(o.amount) AS total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'completed'
GROUP BY u.city;

-- EXPLAIN after optimization
EXPLAIN
SELECT u.city,
       COUNT(o.id),
       SUM(o.amount)
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'completed'
GROUP BY u.city;

-- ----------------
-- Date-based query
-- ----------------
SELECT u.city,
       COUNT(o.id) AS total_orders,
       SUM(o.amount) AS revenue
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'completed'
  AND o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY u.city;

-- Advanced composite index
CREATE INDEX idx_orders_status_date_user
ON orders(status, created_at, user_id);

-- ----------------
-- Profiling
-- ----------------
SET profiling = 1;
SHOW PROFILES;
