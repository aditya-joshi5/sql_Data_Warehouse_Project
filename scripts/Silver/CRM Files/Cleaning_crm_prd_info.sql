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

SELECT * FROM Bronze.crm_prd_info





