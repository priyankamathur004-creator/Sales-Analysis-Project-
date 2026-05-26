# SQL Data Analysis Project: E-Commerce Business Intelligence
# Project Overview
This project simulates a comprehensive data analysis journey for an e-commerce platform. Using a series of structured SQL queries, the analysis progresses through three distinct investigative phases—moving from basic data discovery to complex relational analysis, and finally to advanced business intelligence reporting.

The goal is to interrogate the company database to uncover underlying trends in customer behavior, revenue fluctuations, product performance, and operational efficiency.

# Database Schema & Structure
The project utilizes five core tables within the Assign1 database:

Customers: Contains demographics, location (City), and registration history (SignupDate).

Product: Details the catalog inventory, item categorization (Category), and unit pricing (Price).

Orders: Records transactional metadata, including tracking timestamps (OrderDate).

Order details: The intersection table mapping specific items, unit quantities (Quantity), and transactional boundaries to individual orders.

Payments: Tracks the transactional mediums and fulfillment records (PaymentMode).

# Investigation Phases & Query Breakdown
# Phase 1: Getting Familiar with the Data (Basic Analysis)
Focuses on initial data exploration, filtering, basic aggregations, and understanding the general pricing and customer distributions.

Filtering customer demographics by geography (e.g., Mumbai).

Isolating targeted inventories (Electronics, specific naming patterns).

Evaluating baseline metrics: total customer counts, average item pricing, and distinct operating regions.

Date-bounded chronological analysis (March 2024 orders).

# Phase 2: Connecting the Dots (Intermediate Analysis)
Focuses on relational data mapping by joining tables to analyze the relationships between people, products, and financial metrics.

Cross-referencing customer timelines with transaction logs.

Itemizing order contents and calculating explicit gross metrics per transaction.

Evaluating high-velocity products, top-5 stars, and regional order distributions.

Analyzing monthly categorical revenue performance throughout the year 2024.

Identifying operational blindspots, such as churned accounts that signed up but never ordered.

# Phase 3: Thinking Like a Senior Analyst (Advanced Business Intelligence)
Employs advanced SQL methodologies—including Common Table Expressions (CTEs), Window Functions (DENSE_RANK, SUM OVER), Conditional Logic (CASE WHEN), and Date Math—to extract deep operational insights.

Window Rankings: Identifying the second highest-selling product dynamically and identifying the top-spending customer within each distinct city.

Financial Tracking: Calculating continuous rolling/running sales totals over time.

Customer Segmentation: Binning users into logical strategic tiers (Gold, Silver, Bronze) based on lifetime value calculations.

Inventory & Retention Controls: Isolating unpurchased "dead inventory" items and flagging dormant customers who haven't interacted with the platform in over 6 months.

Proportional Metrics: Calculating the percentage revenue contribution of product categories against the corporate grand total.

# Key SQL Techniques Demonstrated
Multi-table Joins: Extensive utilization of INNER JOIN and LEFT JOIN to safely map relational data.

Aggregation & Filtering: Masterful grouping via GROUP BY, filter evaluations with HAVING, and boundaries utilizing BETWEEN, LIKE, and TOP.

Common Table Expressions (CTEs): Modularized queries designed for readability, execution safety, and multi-stage calculation logic.

Window Functions: Advanced application of DENSE_RANK() OVER (PARTITION BY ... ORDER BY ...) and frame-bounded running metrics (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW).
