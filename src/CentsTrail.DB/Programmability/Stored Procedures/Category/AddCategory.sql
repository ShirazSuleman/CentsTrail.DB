CREATE PROCEDURE [dbo].[AddCategory]
	@Name NVARCHAR(512),
	@UserId NVARCHAR(128),
	@Limit DECIMAL(15, 2) = NULL,
	@CategoryTypeId INT,
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
		
				INSERT INTO [dbo].[Category]
					   ([Name],
						[UserId],
						[Limit],
						[CategoryTypeId])
				 VALUES
					   (@Name,
						@UserId,
						@Limit,
						@CategoryTypeId);
						
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
