EXEC Silver.load_silver

CREATE OR ALTER PROCEDURE Silver.load_silver AS
BEGIN
	PRINT'>> Truncating Table: Silver.crm_sales_details';
	TRUNCATE TABLE Silver.crm_sales_details
	PRINT'>> Inserting Data Into: Silver.crm_sales_details'
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

	PRINT'>> Truncating Table: Silver.crm_prd_info';
	TRUNCATE TABLE Silver.crm_prd_info
	PRINT'>> Inserting Data Into: Silver.crm_prd_info'
	INSERT INTO Silver.crm_prd_info (
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	SELECT 
		prd_id,
		REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,  -- Extract Category id from prd_key
		SUBSTRING(prd_key,7,LEN(prd_key)) prd_key,          -- EXtract Product key
		prd_nm,
		COALESCE(prd_cost,0) as prd_cost ,
		CASE UPPER(TRIM(prd_line))      -- DATA Normalization instead of code value we have friendly value
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'n/a'               -- handeled missing data
		END as prd_line,             -- map product line codes to descriptive values
		CAST(prd_start_dt as DATE ) prd_start_dt,
		CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) as prd_end_dt
	FROM Bronze.crm_prd_info


	PRINT'>> Truncating Table: Silver.crm_sales_details';
	TRUNCATE TABLE Silver.crm_sales_details
	PRINT'>> Inserting Data Into: Silver.crm_sales_details'
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


	PRINT'>> Truncating Table: Silver.erp_cust_az12';
	TRUNCATE TABLE Silver.erp_cust_az12
	PRINT'>> Inserting Data Into: Silver.erp_cust_az12'
	INSERT INTO Silver.erp_cust_az12
	   (CID,
		BDATE,
		GEN
	)
	SELECT 
		CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(TRIM(CID),4,LEN(CID))
			 ELSE CID
		END AS CID,
		CASE WHEN BDATE > GETDATE() THEN NULL
			ELSE BDATE
		END AS BDATE,
		CASE 
			WHEN GEN IS NULL THEN 'n/a'
			WHEN UPPER(TRIM(GEN)) IN ('F','FEMALE') THEN 'Female'
			WHEN UPPER(TRIM(GEN))IN ('M','MALE')THEN 'Male'
			WHEN UPPER(TRIM(GEN))='' THEN 'n/a'
			ELSE TRIM(GEN)
		END AS GEN
	FROM Bronze.erp_cust_az12


	PRINT'>> Truncating Table: Silver.erp_loc_a101';
	TRUNCATE TABLE Silver.erp_loc_a101
	PRINT'>> Inserting Data Into: Silver.erp_loc_a101'
	INSERT INTO Silver.erp_loc_a101
	 (	CID,
		CNTRY
	  )
	SELECT 
		REPLACE(CID,'-','')AS CID,
		CASE WHEN TRIM(CNTRY) IN ('USA','US') THEN 'United States'
			 WHEN TRIM(CNTRY) IN ('Germany','DE') THEN 'Germany'
			 WHEN TRIM(CNTRY)='' OR CNTRY IS NULL THEN 'n/a'
			 ELSE TRIM(CNTRY)
		END AS CNTRY
	FROM Bronze.erp_loc_a101


	PRINT'>> Truncating Table: Silver.erp_px_cat_g1v2';
	TRUNCATE TABLE Silver.erp_px_cat_g1v2
	PRINT'>> Inserting Data Into: Silver.erp_px_cat_g1v2'
	INSERT INTO Silver.erp_px_cat_g1v2
	(	ID,
		CAT,
		SUBCAT,
		MAINTENANCE
		)
	SELECT 
		ID,
		CAT,
		SUBCAT,
		MAINTENANCE
	FROM Bronze.erp_px_cat_g1v2 
END 