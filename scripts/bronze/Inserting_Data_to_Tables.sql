
CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
	BEGIN TRY
		DECLARE @start_time DATETIME, 
				@end_time DATETIME
		SET @start_time = GETDATE()
		PRINT'------------------------------------------------'
		PRINT'Loading BRONZE Layer'
		PRINT'------------------------------------------------'

		PRINT'================================================='
		PRINT'Loading CRM file'
		PRINT'================================================='

		PRINT'>>Truncating Table: Bronze.crm_cust_info'
		TRUNCATE TABLE Bronze.crm_cust_info;

		PRINT'>>Inserting Table: Bronze.crm_cust_info'
		BULK INSERT Bronze.crm_cust_info
		FROM 'C:\Users\ADITYA JOSHI\Documents\SQL Server Management Studio\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);


		PRINT'>>Truncating Table: Bronze.crm_prd_info'
		TRUNCATE TABLE Bronze.crm_prd_info;

		PRINT'>>Inserting Table: Bronze.crm_prd_info'
		BULK INSERT Bronze.crm_prd_info
		FROM 'C:\Users\ADITYA JOSHI\Documents\SQL Server Management Studio\source_crm\prd_info.csv'
		WITH
		(	FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);

		PRINT'>>Truncating Table: Bronze.crm_sales_details'
		TRUNCATE TABLE Bronze.crm_sales_details;

		PRINT'>>Inserting Table: Bronze.crm_sales_details'
		BULK INSERT Bronze.crm_sales_details
		FROM 'C:\Users\ADITYA JOSHI\Documents\SQL Server Management Studio\source_crm\sales_details.csv'
		WITH
		(	FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);

		PRINT'================================================='
		PRINT'Loading ERP file'
		PRINT'================================================='

		PRINT'>>Truncating Table: Bronze.erp_cust_az12'
		TRUNCATE TABLE Bronze.erp_cust_az12;

		PRINT'>>Inserting Table: Bronze.erp_cust_az12'
		BULK INSERT Bronze.erp_cust_az12
		FROM 'C:\Users\ADITYA JOSHI\Documents\SQL Server Management Studio\source_erp\cust_AZ12.csv'
		WITH 
		(
			FIRSTROW =2,
			FIELDTERMINATOR=',',
			ROWTERMINATOR='\n',
			TABLOCK
			)

		PRINT'>>Truncating Table: Bronze.erp_loc_a101'
		TRUNCATE TABLE Bronze.erp_loc_a101;

		PRINT'>>Inserting Table: Bronze.erp_loc_a101'
		BULK INSERT Bronze.erp_loc_a101
		FROM 'C:\Users\ADITYA JOSHI\Documents\SQL Server Management Studio\source_erp\LOC_A101.csv'
		WITH 
		(
			FIRSTROW =2,
			FIELDTERMINATOR=',',
			ROWTERMINATOR='\n',
			TABLOCK
			)

		PRINT'>>Truncating Table: Bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2;

		PRINT'>>Inserting Table: Bronze.erp_px_cat_g1v2'
		BULK INSERT Bronze.erp_px_cat_g1v2
		FROM 'C:\Users\ADITYA JOSHI\Documents\SQL Server Management Studio\source_erp\px_cat_g1v2.csv'
		WITH
		(	FIRSTROW=2,
			FIELDTERMINATOR=',',
			ROWTERMINATOR='\n',
			TABLOCK
			);
		SET @end_time = GETDATE()

		PRINT'Total Time Taken is:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
	END TRY
	BEGIN CATCH
		PRINT'======================================='
		PRINT'ERROR OCCURED WHILE LOADING BRONZE LAYER'
		PRINT'Error Message:'+ CAST(ERROR_MESSAGE()AS NVARCHAR)
		PRINT'Error Number:' + CAST(ERROR_NUMBER() AS NVARCHAR)
		PRINT'Error State:' + CAST(ERROR_STATE() AS NVARCHAR)
		print'======================================='
	END CATCH
END

EXEC Bronze.load_bronze

