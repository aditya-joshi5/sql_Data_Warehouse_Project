CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY pi.prd_start_dt,prd_id) AS product_key,
	pi.prd_id AS product_id,
	pi.prd_key AS product_number,
	pi.prd_nm AS product_name,
	pi.cat_id AS category_id,
	pc.CAT AS category,
	pc.SUBCAT AS sub_category,
	pc.MAINTENANCE ,
	pi.prd_cost AS cost,
	pi.prd_line AS product_line,
	pi.prd_start_dt AS start_date
FROM Silver.crm_prd_info as pi
LEFT JOIN Silver.erp_px_cat_g1v2 as pc
		ON pi.cat_id=pc.ID
WHERE prd_end_dt IS NULL --filter out historical date

