# Supply Chain Analytics

# Project Overview
This project uses SQL and MySQL to analyze supply chain operations, with a focus on freight costs, transportation routes, product movement, warehouse utilization, and operation costs.
The objective was to transform raw supply-chain data into actionable insights that could help identify cost drivers, heavily utilized facilities, transportation patterns, and potential capacity issues.
Rather than focusing only on producing SQL queries, the analysis approaches the dataset from a business perspective: What is happening in the supply chain, where are the inefficiencies, and what areas deserve further investigation?

# Business Questions
The analysis investigates questions such as:
- Which transportation routes have the highest freight costs?
- Which ports are used most frequently?
- Which carriers have the highest average freight rates?
- Which products generate the highest freight costs?
- Which warehouses handle the greatest volume?
- Which warehouses appear to be operating beyond their stated capacity?
- Which facilities have the highest average operating costs?

# Tools & Technologies
- MySQL
- SQL
- Git & GitHub

SQL techniques used include:
- SELECT
- WHERE
- GROUP BY
- ORDER BY
- Aggregate functions such as SUM(), AVG(), and COUNT()
- JOIN
- Conditional filtering
- Subqueries
- Data aggregation and ranking

# Key Findings
## 1. Most Expensive Route
The analysis identified PORT09 as the route with the highest freight cost: $1644.33.

This makes PORT09 an important area for further investigation into transportation pricing, route characteristics, carrier selection, and shipment composition.

## 2. Port Utilization
The most frequently used ports were:

### Port        Usage
    PORT04      9041
    PORT09      173
    PORT05      1

PORT04 was used substantially more frequently than other ports in the dataset.

This concentration could be useful when evaluating transportation dependency and potential bottlenecks.

## 3. Average Freight Cost by Carrier
### Carrier    Average Freight Cost
    V444_0     $9.78
    V444_1     $1.60

The difference between the two carriers suggests that carrier selection may have a significant effect on freight expenditure.

Further analysis would be required to determine whether the difference is explained by route, shipment weight, product type, distance, or other operational factors.

## 4. Products With the Highest Freight Costs
The products associated with the highest freight costs included:

### ProductID   Freight Cost
    1686435     $17,594.58
    1696533     $6,815.74
    1691393     $835.36

Product 1686435 accounted for the largest freight cost among the products examined.

This could warrant further investigation into shipment frequency, shipment weight, destination, and transportation method.

## 5. Warehouse Utilization
Warehouse activity varied considerably across facilities.

### Warehouse     Utilization
    PLANT03       8,541
    PLANT12       300
    PLANT16       173
    PLANT08       102
    PLANT13       86
    PLANT09       12
    PLANT04       1

PLANT03 had by far the highest utilization in the analyzed data.

Such concentration may indicate that certain facilities are carrying a disproportionate share of supply-chain activity.

## 6. Warehouse Capacity
Several warehouses appeared to exceed their stated capacity.

### Warehouse     Capacity
    PLANT03       1,013
    PLANT12       209
    PLANT08       14
    PLANT09       11

PLANT03 showed the largest capacity excess.

These findings could indicate potential overcapacity, congestion, inventory-management issues, or an imbalance in the distribution of goods.

## 7. Operating Costs
The analysis also examined average operating costs across facilities.
Among the highest observed averages were:

### Warehouse   Average Operating Cost
    PLANT18      $2.04
    PLANT16      $1.92
    PLANT15      $1.42

This provides another dimension for evaluating warehouse performance beyond simple utilization.

# Analytical Approach
The analysis followed a structured workflow:
1. Raw Supply Chain Data
2. Data Exploration
3. SQL Aggregation & Filtering
4. Cost & Utilization Analysis
5. Identify Patterns & Analysis
6. Business Intepretation

# Key Takeaways
The analysis highlights several areas that could have operational significance:
- Freight costs are not evenly distributed across routes and carriers.
- PORT04 dominates port usage in the analyzed data.
- Carrier V444_0 has a substantially higher average freight cost than V444_1.
- Product 1686435 represents a major freight-cost distributor.
- PLANT03 has exceptionally high utilization and the largest identified capacity excess.
- Warehouse operating costs vary across facilities.

# Author
## Daniel Tindi
This project represents an application of analytical and investigative thinking to operational data, combining SQL, data analysis, and problem-solving to uncover patterns within a supply-chain dataset.
  

- 
