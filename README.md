# SQL Performance Optimization

## Objective
Optimize slow-performing SQL queries on large datasets using indexing, EXPLAIN analysis, and query profiling.

## Dataset
- **users**: ~50,000 records
- **orders**: ~200,000 records

## Problem Statement
JOIN-based aggregation queries filtering by status and date showed slow performance due to full table scans and inefficient filtering.

## Approach
1. Created large datasets to simulate real-world load
2. Identified slow queries involving JOIN, WHERE, and GROUP BY
3. Used EXPLAIN to analyze execution plans
4. Applied single-column and composite indexing strategies
5. Benchmarked performance using query profiling

## Optimizations Applied
- Index on `orders(user_id, status)`
- Index on `users(city)`
- Advanced composite index on `orders(status, created_at, user_id)`

## Results
- Reduced rows examined
- Faster query execution after indexing
- Improved join and filtering efficiency

## Tools Used
- MySQL 8.0
- MySQL Workbench

## Conclusion
Proper index design aligned with query patterns significantly improves query performance and scalability.
