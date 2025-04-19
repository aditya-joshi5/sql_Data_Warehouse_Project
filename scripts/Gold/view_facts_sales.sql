
CREATE VIEW gold.fact_sales AS
SELECT 
	sd.sls_ord_num AS order_number,
	cu.customer_key,
	pd.product_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS ship_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity quantity,
	sd.sls_price AS price
FROM Silver.crm_sales_details sd
LEFT JOIN Gold.dim_customers cu
		ON sd.sls_cust_id=cu.customer_id
LEFT JOIN Gold.dim_products as pd
		ON sd.sls_prd_key = pd.product_number

SELECT * FROM Gold.fact_sales
SELECT * FROM Gold.dim_customers
SELECT * FROM Gold.dim_products
