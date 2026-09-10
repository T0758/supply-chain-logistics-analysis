SELECT *
FROM orderlist;

SELECT *
FROM orderlist
WHERE OrderDate = '2013-05-26';

ALTER TABLE orderlist
ADD COLUMN OrderDate_New date;

UPDATE orderlist
SET OrderDate_New = str_to_date(OrderDate, '%m/%d/%Y');

ALTER TABLE orderlist
DROP COLUMN OrderDate;

ALTER TABLE  orderlist
RENAME COLUMN OrderDate_New TO OrderDate;

WITH duplicate_cte AS(
SELECT *,
RANK() OVER(PARTITION BY OrderID) AS rnk_column
FROM orderlist)
SELECT *
FROM duplicate_cte;

ALTER TABLE freightrates
RENAME COLUMN Carrier TO freight_carrier;

SELECT
	SUM(OrderID IS NULL) AS order_id_nulls,
    SUM(OriginPort IS NULL) AS origin_port_nulls,
    SUM(Carrier IS NULL) AS carrier_nulls,
    SUM(TPT IS NULL) AS TPT_nulls,
    SUM(ServiceLevel IS NULL) AS service_level_nulls,
    SUM(Ship_ahead_day_count IS NULL) AS ShipAheadDayCount_nulls,
    SUM(Ship_Late_Day_Count IS NULL) AS ShipLateDayCount_nulls,
    SUM(Customer IS NULL) AS Customer_nulls,
    SUM(ProductID IS NULL) AS product_id_nulls,
    SUM(PlantCode IS NULL) AS plant_code_nulls,
    SUM(DestinationPort IS NULL) AS destination_port_nulls,
    SUM(Unitquantity IS NULL) AS unit_quantity_nulls,
    SUM(Weight IS NULL) AS weight_nulls,
    SUM(OrderDate IS NULL) AS order_date_nulls
FROM orderlist;

SELECT
	SUM(CASE WHEN OrderID = " " THEN 1 ELSE 0 END ) AS order_id_blanks,
    SUM(CASE WHEN OriginPort = " " THEN 1 ELSE 0 END) AS origin_port_blanks,
    SUM(CASE WHEN Carrier = " " THEN 1 ELSE 0 END) AS carrier_blanks,
    SUM(CASE WHEN TPT = " " THEN 1 ELSE 0 END) AS TPT_blanks,
    SUM(CASE WHEN ServiceLevel = " " THEN 1 ELSE 0 END ) AS service_level_blanks,
    SUM(CASE WHEN Ship_ahead_day_count = " " THEN 1 ELSE 0 END) AS ShipAheadDayCount_blanks,
    SUM(CASE WHEN Ship_Late_Day_Count = " " THEN 1 ELSE 0 END) AS ShipLateDayCount_blanks,
    SUM(CASE WHEN Customer = " " THEN 1 ELSE 0 END) AS Customer_blanks,
    SUM(CASE WHEN ProductID = " " THEN 1 ELSE 0 END) AS product_id_blanks,
    SUM(CASE WHEN PlantCode = " " THEN 1 ELSE 0 END) AS plant_code_blanks,
    SUM(CASE WHEN DestinationPort = " " THEN 1 ELSE 0 END) AS destination_port_blanks,
    SUM(CASE WHEN Unitquantity = " " THEN 1 ELSE 0 END) AS unit_quantity_blanks,
    SUM(CASE WHEN Weight = " " THEN 1 ELSE 0 END) AS weight_blanks
FROM orderlist;

-- There are two orders in which weight is zero with enormous unit quantities which is illogical.

SELECT DISTINCT OrderDate
FROM orderlist;

SELECT 
	SUM(freight_carrier IS NULL) AS freight_carrier_nulls,
    SUM(orig_port_cd IS NULL) AS orig_port_cd_nulls,
    SUM(dest_port_cd IS NULL) AS dest_port_cd_nulls,
    SUM(minm_wgh_qty IS NULL) AS minm_wgh_qty_nulls,
    SUM(max_wgh_qty IS NULL) AS max_wgh_qty_nulls,
    SUM(svc_cd IS NULL) AS svc_cd_nulls,
    SUM(minimumcost IS NULL) AS minimumcost_nulls,
    SUM(rate IS NULL) AS rate_nulls,
    SUM(mode_dsc IS NULL) AS mode_dsc_nulls,
    SUM(tpt_day_cnt IS NULL) AS tpt_day_cnt,
    SUM(Carriertype IS NULL) AS carrier_type_nulls
FROM freightrates;

SELECT 
	SUM(CASE WHEN freight_carrier = " " THEN 1 ELSE 0 END) AS freight_carrier_blanks,
    SUM(CASE WHEN orig_port_cd = " " THEN 1 ELSE 0 END) AS orig_port_cd_blanks,
    SUM(CASE WHEN dest_port_cd = " " THEN 1 ELSE 0 END) AS dest_port_cd_blanks,
    SUM(CASE WHEN minm_wgh_qty = " " THEN 1 ELSE 0 END) AS minm_wgh_qty_blanks,
    SUM(CASE WHEN max_wgh_qty = " " THEN 1 ELSE 0 END) AS max_wgh_qty_blanks,
    SUM(CASE WHEN svc_cd = " " THEN 1 ELSE 0 END) AS svc_cd_blanks,
    SUM(CASE WHEN minimumcost = " " THEN 1 ELSE 0 END) AS minimumcost_blanks,
    SUM(CASE WHEN rate = " " THEN 1 ELSE 0 END) AS rate_blanks,
    SUM(CASE WHEN mode_dsc = " " THEN 1 ELSE 0 END) AS mode_dsc_blanks,
    SUM(CASE WHEN tpt_day_cnt = " " THEN 1 ELSE 0 END) AS tpt_day_cnt_blanks,
    SUM(CASE WHEN Carriertype = " " THEN 1 ELSE 0 END) AS carrier_type_blanks
FROM freightrates;

SELECT *
FROM freightrates
WHERE minm_wgh_qty = " ";

SELECT *
FROM freightrates
WHERE tpt_day_cnt = " ";

SELECT DISTINCT 
PlantCode,
Port
FROM plantports;

SELECT DISTINCT 
PlantCode,
ProductID
FROM productsperplant;

SELECT *
FROM vmicustomers;

SELECT *
FROM orderlist;

-- routes most expensive
WITH base_data AS(
SELECT OrderID, OriginPort,
Carrier, Weight, minm_wgh_qty,
max_wgh_qty, ServiceLevel, TPT,
AVG(weight) AS avg_weight,
AVG(rate) AS avg_rate,
ROW_NUMBER() OVER(PARTITION BY o.OrderID
ORDER BY (fr.max_wgh_qty - fr.minm_wgh_qty)ASC) AS row_num
FROM orderlist o 
LEFT JOIN freightrates fr 
ON o.Carrier = fr.freight_carrier
AND o.OriginPort = fr.orig_port_cd
AND o.Weight BETWEEN fr.minm_wgh_qty AND fr.max_wgh_qty
AND O.ServiceLevel = fr.svc_cd
AND O.TPT = tpt_day_cnt
GROUP BY OrderID, OriginPort, Carrier,
Weight, minm_wgh_qty, max_wgh_qty,
ServiceLevel, TPT)
SELECT OriginPort,
ROUND(AVG(avg_weight * avg_rate),2) AS avg_cost
FROM base_data
WHERE row_num = 1
GROUP BY OriginPort
ORDER BY avg_cost DESC;

-- ports used often
WITH base_data AS(
SELECT OrderID, OriginPort,
Carrier, ProductID, Weight, minm_wgh_qty,
max_wgh_qty, ServiceLevel, TPT,
AVG(weight) AS avg_weight,
AVG(rate) AS avg_rate,
ROW_NUMBER () OVER(PARTITION BY o.OrderID
ORDER BY (fr.max_wgh_qty - fr.minm_wgh_qty)ASC) AS row_num
FROM orderlist o 
LEFT JOIN freightrates fr 
ON o.Carrier = fr.freight_carrier
AND o.OriginPort = fr.orig_port_cd
AND o.Weight BETWEEN fr.minm_wgh_qty AND fr.max_wgh_qty
AND O.ServiceLevel = fr.svc_cd
AND O.TPT = tpt_day_cnt
GROUP BY OrderID, OriginPort, Carrier,
ProductID, Weight,minm_wgh_qty, max_wgh_qty,
ServiceLevel, TPT)
SELECT OriginPort,
COUNT(OriginPort) AS Port_Count
FROM base_data
WHERE row_num = 1
GROUP BY OriginPort
ORDER BY Port_Count DESC;

-- avg freight cost by carrier
WITH base_data AS(
SELECT OrderID, OriginPort,
Carrier,ProductID, Weight, minm_wgh_qty,
max_wgh_qty, ServiceLevel, TPT,
AVG(weight) AS avg_weight,
AVG(rate) AS avg_rate,
ROW_NUMBER () OVER(PARTITION BY o.OrderID
ORDER BY (fr.max_wgh_qty - fr.minm_wgh_qty)ASC) AS row_num
FROM orderlist o 
LEFT JOIN freightrates fr 
ON o.Carrier = fr.freight_carrier
AND o.OriginPort = fr.orig_port_cd
AND o.Weight BETWEEN fr.minm_wgh_qty AND fr.max_wgh_qty
AND O.ServiceLevel = fr.svc_cd
AND O.TPT = tpt_day_cnt
GROUP BY OrderID, OriginPort,ProductID, Carrier,
Weight, minm_wgh_qty, max_wgh_qty,
ServiceLevel, TPT)
SELECT Carrier,
COUNT(Carrier) AS carrier_count,
ROUND(AVG(avg_weight * avg_rate),2) AS avg_freight_cost
FROM base_data
WHERE row_num = 1
GROUP BY Carrier
ORDER BY avg_freight_cost DESC;

-- freight cost by product
WITH base_data AS(
SELECT OrderID, OriginPort,
Carrier,ProductID, Weight, minm_wgh_qty,
max_wgh_qty, ServiceLevel, TPT,
AVG(weight) AS avg_weight,
AVG(rate) AS avg_rate,
ROW_NUMBER() OVER(PARTITION BY o.OrderID 
ORDER BY (fr.max_wgh_qty - fr.minm_wgh_qty) ASC ) AS row_num
FROM orderlist o 
LEFT JOIN freightrates fr 
ON o.Carrier = fr.freight_carrier
AND o.OriginPort = fr.orig_port_cd
AND o.Weight BETWEEN fr.minm_wgh_qty AND fr.max_wgh_qty
AND O.ServiceLevel = fr.svc_cd
AND O.TPT = tpt_day_cnt
GROUP BY OrderID, OriginPort,ProductID, Carrier,
Weight, minm_wgh_qty, max_wgh_qty,
ServiceLevel, TPT)
SELECT ProductID,
COUNT(ProductID) AS Product_Count,
AVG(avg_weight) AS Product_Avg_Weight,
ROUND(AVG(avg_weight * avg_rate),2) AS avg_freight_cost
FROM base_data
WHERE row_num = 1
GROUP BY ProductID
ORDER BY avg_freight_cost DESC;

-- warehouse with the highest utilization
SELECT PlantCode,
COUNT(OrderID) AS total_orders,
AVG(DailyCapacity) AS avg_daily_capacity
FROM orderlist o
LEFT JOIN whcapacities whc
ON o.PlantCode = whc.PlantID
LEFT JOIN whcosts wh 
ON whc.PlantID = wh.WH
GROUP BY PlantCode
ORDER BY total_orders DESC;

SELECT PlantCode,
COUNT(OrderID) AS total_orders,
AVG(DailyCapacity) AS avg_daily_capacity
FROM orderlist o
LEFT JOIN whcapacities whc
ON o.PlantCode = whc.PlantID
LEFT JOIN whcosts wh 
ON whc.PlantID = wh.WH
GROUP BY PlantCode
HAVING total_orders > avg_daily_capacity;

-- warehouse with the highest operating cost
SELECT WH, Cost
FROM whcosts
ORDER BY Cost DESC;

-- plant with the most products
SELECT PlantCode,
COUNT(ProductID) AS product_id_count
FROM productsperplant
GROUP BY PlantCode
ORDER BY product_id_count DESC;

-- products in multiple plants
SELECT ProductID,
COUNT(PlantCode) AS plants_with_product
FROM productsperplant
GROUP BY ProductID
HAVING COUNT(PlantCode) >1;

SELECT ServiceLevel,
COUNT(OrderID) AS No_of_orders
FROM orderlist
GROUP BY ServiceLevel
ORDER BY No_of_orders DESC; 

SELECT *
FROM orderlist O
LEFT JOIN vmicustomers vc
ON o.PlantCode = vc.PlantCode
AND o.Customer = vc.Customers
WHERE vc.PlantCode AND vc.Customers != NULL;

-- COST OPTIMIZATION
-- total shipping cost
WITH base_data AS(
SELECT OrderID, OriginPort,
Carrier,ProductID, Weight, minm_wgh_qty,
max_wgh_qty, ServiceLevel, TPT,
AVG(weight) AS avg_weight,
AVG(rate) AS avg_rate,
ROW_NUMBER() OVER (PARTITION BY o.OrderID 
ORDER BY (fr.max_wgh_qty - fr.minm_wgh_qty) ASC ) AS row_num
FROM orderlist o 
LEFT JOIN freightrates fr 
ON o.Carrier = fr.freight_carrier
AND o.OriginPort = fr.orig_port_cd
AND o.Weight BETWEEN fr.minm_wgh_qty AND fr.max_wgh_qty
AND O.ServiceLevel = fr.svc_cd
AND O.TPT = tpt_day_cnt
GROUP BY OrderID, OriginPort,ProductID, Carrier,
Weight, minm_wgh_qty, max_wgh_qty,
ServiceLevel, TPT)
SELECT ROUND(SUM(avg_weight * avg_rate),2) AS total_shipping_cost
FROM base_data
WHERE row_num = 1;

-- warehouse cost per unit shipped
SELECT
SUM(Unitquantity) AS total_quantity,
ROUND(SUM(Unitquantity * whc.Cost),2) AS Warehouse_cost,
ROUND(SUM(Unitquantity * whc.cost)/SUM(Unitquantity),2) AS cost_per_unit_shipped
FROM orderlist o 
LEFT JOIN whcosts whc 
ON o.PlantCode = whc.WH;

SELECT 
ProductID,
SUM(Unitquantity) AS total_quantity,
ROUND(SUM(Unitquantity * whc.Cost),2) AS Warehouse_cost
FROM orderlist o 
LEFT JOIN whcosts whc 
ON o.PlantCode = whc.WH
GROUP BY ProductID
ORDER BY Warehouse_cost DESC; 

