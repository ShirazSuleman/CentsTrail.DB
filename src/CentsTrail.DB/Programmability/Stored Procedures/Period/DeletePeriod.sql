CREATE PROCEDURE [dbo].[DeletePeriod]
	@UserId NVARCHAR(128),
	@Id BIGINT = NULL
AS
BEGIN
	DECLARE @TranCount INT = @@TRANCOUNT;
	
	DECLARE @ErrorProcedure NVARCHAR(256);
	DECLARE @ErrorMessage NVARCHAR(2048);
	DECLARE @ErrorLine INT;
	
	BEGIN TRY
	
		IF NOT EXISTS (
						SELECT TOP 1 NULL
						FROM [dbo].[Period]
						WHERE [Id] = @Id
						AND [UserId] = @UserId
					  )
		BEGIN
			RAISERROR('Period does not exist: Id %I64d, UserId %s.', 16, -1, @Id, @UserId);
		END
	
		IF (@TranCount = 0)
			BEGIN TRANSACTION;
		
				DELETE FROM [dbo].[Period]
				 WHERE [UserId] = @UserId
				 AND (@Id IS NULL OR [Id] = @Id);
		
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