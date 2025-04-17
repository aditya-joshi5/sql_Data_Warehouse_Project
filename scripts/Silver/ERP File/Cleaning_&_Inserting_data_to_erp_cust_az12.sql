-- erp_cust_az12 is related to crm_cust_info via CID & cst_id
SELECT
	CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(TRIM(CID),4,LEN(CID))
		 ELSE CID
	END AS CID,
	BDATE,
	GEN
FROM Bronze.erp_cust_az12
WHERE CID LIKE 'NAS%'
SELECT * FROM Silver.crm_cust_info

--Identify Out of Range BDATES
SELECT
	CASE WHEN BDATE > GETDATE() THEN NULL
	ELSE BDATE
	END AS BDATE,
	GEN
FROM Bronze.erp_cust_az12
WHERE BDATE > GETDATE()

-- DATA Satandardization and consistency
SELECT DISTINCT GEN
FROM Bronze.erp_cust_az12

SELECT DISTINCT GEN,
	CASE 
	WHEN GEN IS NULL THEN 'n/a'
	WHEN UPPER(TRIM(GEN)) IN ('F','FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(GEN))IN ('M','MALE')THEN 'Male'
	WHEN UPPER(TRIM(GEN))='' THEN 'n/a'
	ELSE TRIM(GEN)
END AS GENDER
FROM Bronze.erp_cust_az12
WHERE GEN IS NULL
	  OR GEN = 'Female'

--===========================================
--       After Cleaning from bronze inserting into silver.erp_cust_az12 
--===========================================
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

-- Running the Table 
SELECT * FROM Silver.erp_cust_az12