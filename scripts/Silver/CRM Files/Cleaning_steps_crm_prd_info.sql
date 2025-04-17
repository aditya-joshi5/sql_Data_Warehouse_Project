-- Checking for repeating columns if prd_key is primary key
SELECT [sls_prd_key],
COUNT(*) 
FROM Silver.crm_sales_details
GROUP BY sls_prd_key
HAVING COUNT(*)>1 or sls_prd_key IS NULL
--=======================================================================
-- CONVERTING date time 
SELECT 
NULLIF(sls_order_dt,0) AS sls_order_dt
FROM Bronze.crm_sales_details
WHERE sls_order_dt<=0 OR LEN(sls_order_dt)!=8
OR sls_order_dt IN (205001,19000101)  -- DATES IN Between the Range When the company started

-- Same with shipping date
SELECT 
NULLIF(sls_ship_dt,0) AS sls_ship_dt
FROM Bronze.crm_sales_details
WHERE sls_ship_dt<=0 OR LEN(sls_ship_dt)!=8
OR sls_ship_dt IN (205001,19000101)  

--================================================================

--Data Standardization and consistency


-- Check for invalid date orders 
SELECT *
FROM Bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR  sls_order_dt > sls_due_dt

--=================================================================================
-- Bussiness Rule: sales= Quantity * price and not zero -ve or null
SELECT DISTINCT *
FROM Bronze.crm_sales_details
WHERE sls_sales!=sls_quantity*sls_price
OR sls_price<=0 OR sls_price is null
OR sls_sales<=0 OR sls_quantity<=0
OR sls_sales IS NULL OR sls_quantity IS NULL

/* =========Rules 1. If sales is negative, zero,or Null derieve it using Quantity and price 
			Rules 2. If Price is negative then Convert to positive 
			Rules 3. If Price is zero,or Null Calculate it using Quantity and sales */

SELECT DISTINCT [sls_ord_num],
		sls_price as old_sls_price,
	  CASE WHEN sls_sales<=0 OR sls_sales IS NULL OR sls_sales!=sls_quantity*sls_price
				THEN sls_quantity*ABS(sls_price)
			ELSE sls_sales
		END AS sls_sales,
      [sls_quantity],
	  sls_price as old_sls_price,
	  CASE  WHEN sls_price IS NULL OR sls_price<=0 
				THEN ABS(sls_sales/COALESCE(sls_quantity,0))
			ELSE sls_price
	  END AS sls_price
FROM Bronze.crm_sales_details
WHERE sls_sales!=sls_quantity*sls_price
OR sls_price<=0 OR sls_price is null
OR sls_sales<=0 OR sls_quantity<=0
OR sls_sales IS NULL OR sls_quantity IS NULL

--========================================================================

/* Now after checking that the table information has been cleaned properly
	we now insert the data into the silver.crm_sales_table and also make 
	make some changes in the silver ddl section */
