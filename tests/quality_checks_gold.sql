--checking for duplicates
SELECT cst_key,
		COUNT(*)	FROM
(SELECT 
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_marital_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.BDATE,
	ca.GEN,
	la.CNTRY
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca
		ON ci.cst_key=ca.CID
LEFT JOIN Silver.erp_loc_a101 la
		ON la.CID=ci.cst_key) t
GROUP BY cst_key
HAVING COUNT(cst_key)>1

--Checking For gender matching in both ca.gen & ci.cst_gndr
SELECT DISTINCT
	ci.cst_gndr,
	ca.GEN
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca
		ON ci.cst_key=ca.CID
LEFT JOIN Silver.erp_loc_a101 la
		ON la.CID=ci.cst_key
ORDER BY 1,2

-- AS we can se that there are unmatching gender from both the tables so
-- making a business rule that 
-- the master table(crm_cust_info) gender should be replicated in erp_cust_az12 table
SELECT DISTINCT
	ci.cst_gndr,
	ca.GEN, 
	CASE WHEN cst_gndr!= 'n/a' THEN ci.cst_gndr 
	ELSE COALESCE(ca.GEN,'n/a')
END AS new_gdr
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca
		ON ci.cst_key=ca.CID
LEFT JOIN Silver.erp_loc_a101 la
		ON la.CID=ci.cst_key
ORDER BY 1,2
