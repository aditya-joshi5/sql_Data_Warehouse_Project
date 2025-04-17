INSERT INTO Silver.crm_sales_details
	(sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
	)
SELECT [sls_ord_num],
       [sls_prd_key],
       [sls_cust_id],
       CASE WHEN sls_order_dt<=0 OR LEN(sls_order_dt)!=8 THEN NULL
			ELSE CAST(CAST(NULLIF (sls_order_dt,0) AS VARCHAR)AS date) 
	   END AS [sls_order_dt],
       CASE WHEN sls_ship_dt<=0 OR LEN(sls_ship_dt)!=8 THEN NULL
			ELSE CAST(CAST(NULLIF (sls_ship_dt,0) AS VARCHAR)AS date)  
	   END AS sls_ship_dt,
       CASE WHEN sls_order_dt<=0 OR LEN(sls_order_dt)!=8 THEN NULL
			ELSE CAST(CAST(NULLIF (sls_order_dt,0) AS VARCHAR)AS date)  
	   END AS sls_due_dt,
	   CASE WHEN sls_sales<=0 OR sls_sales IS NULL OR sls_sales!=sls_quantity*sls_price
				THEN sls_quantity*ABS(sls_price)
			ELSE sls_sales
	   END AS sls_sales,
       sls_quantity,
	   CASE  WHEN sls_price IS NULL OR sls_price<=0 
				THEN ABS(sls_sales/COALESCE(sls_quantity,0))
			ELSE sls_price
	   END AS sls_price
FROM Data_Warehouse.Bronze.crm_sales_details
 

