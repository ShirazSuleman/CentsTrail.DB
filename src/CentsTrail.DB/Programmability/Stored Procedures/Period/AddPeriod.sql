CREATE PROCEDURE [dbo].[AddPeriod]
	@Name NVARCHAR(512),
	@UserId NVARCHAR(128),
	@StartDate DATETIME,
	@EndDate DATETIME = NULL,
	@Id BIGINT OUTPUT
AS
BEGIN
	DECLARE @TranCount INT = @@TRANCOUNT;
	
	DECLARE @ErrorProcedure NVARCHAR(256);
	DECLARE @ErrorMessage NVARCHAR(2048);
	DECLARE @ErrorLine INT;
	
	BEGIN TRY
		
		IF (@TranCount = 0)
			BEGIN TRANSACTION;
		
				INSERT INTO [dbo].[Period]
					   ([Name],
						[UserId],
						[StartDate],
						[EndDate])
				 VALUES
					   (@Name,
						@UserId,
						@StartDate,
						@EndDate);
						
				SET @Id = SCOPE_IDENTITY();
		
		IF (@TranCount = 0 AND XACT_STATE() != 0)
			COMMIT TRANSACTION;
				
	END TRY
	BEGIN CATCH
	
		IF (@TranCount = 0 AND XACT_STATE() != 0)
			ROLLBACK TRANSACTION;
		
		SELECT @ErrorMessage = ERROR_MESSAGE(),
			   @ErrorProcedure = ERROR_PROCEDURE(),
			   @ErrorLine = ERROR_LINE();
			   
		SET @ErrorMessage = 'Error in %s on line %d. ' + @ErrorMessage;
		RAISERROR(@ErrorMessage, 16, -1, @ErrorProcedure, @ErrorLine);
	
	END CATCH
END
