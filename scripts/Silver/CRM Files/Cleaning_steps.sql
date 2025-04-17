-- Checking for repeating columns if prd_key is primary key
SELECT prd_id,
COUNT(*) 
FROM Silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1 or prd_id IS NULL

-- Check for unwanted spaces
-- Expectation : No results
SELECT prd_nm
FROM Silver.crm_prd_info
WHERE prd_nm !=TRIM(prd_nm)

--check for nulls in cost
SELECT prd_cost 
FROM Silver.crm_prd_info
WHERE prd_cost<0 or prd_cost is null

--Data Standardization and consistency
SELECT DISTINCT prd_line 
FROM Silver.crm_prd_info

-- Check for invalid date orders 
SELECT *
FROM Bronze.crm_prd_info
WHERE prd_start_dt>prd_end_dt 
ORDER BY prd_key

SELECT *
FROM Bronze.crm_prd_info
WHERE prd_key='AC-HE-HL-U509'
