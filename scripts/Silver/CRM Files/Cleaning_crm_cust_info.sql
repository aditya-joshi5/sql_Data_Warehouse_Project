
--check nulls and duplicates in primary key
SELECT 
	cst_id
	,COUNT(*)
FROM Bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL

--1.clearing the duplicates using rank function(row_number)
SELECT * FROM 
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date desc) as Rank_
FROM Bronze.crm_cust_info) t
WHERE RANK_=1

--2.Removing for unwanted spaces
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
FROM 
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date desc) as Rank_
FROM Bronze.crm_cust_info) t
WHERE RANK_=1

-- =============== Data Standardization and consistency ==================
SELECT DISTINCT cst_gndr
FROM Bronze.crm_cust_info

-- Making M as Male and F as Female
-- and same for the maritial status
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	 WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'   
					-- use of upper case because if we get M or m then also it is converted to 'Married'
	 ELSE 'n/a'
END as cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	 WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'   
					-- use of upper case because if we get M or m then also it is converted to 'Male'
	 ELSE 'n/a'
END as cst_gndr,
cst_create_date
FROM 
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date desc) as Rank_
FROM Bronze.crm_cust_info) t
WHERE RANK_=1

-- inserting the cleared data into silver table
INSERT INTO Silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
)
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	 WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'   
					-- use of upper case because if we get M or m then also it is converted to 'Married'
	 ELSE 'n/a'
END as cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	 WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'   
					-- use of upper case because if we get M or m then also it is converted to 'Male'
	 ELSE 'n/a'
END as cst_gndr,
cst_create_date
FROM 
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date desc) as Rank_
FROM Bronze.crm_cust_info) t
WHERE RANK_=1
