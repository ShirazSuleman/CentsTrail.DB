CREATE PROCEDURE [dbo].[UpdateAccount]
	@Id BIGINT,
	@UserId NVARCHAR(128),
	@Name NVARCHAR(512) = NULL,
	@AccountTypeId INT = NULL
AS
BEGIN
	DECLARE @TranCount INT = @@TRANCOUNT;
	
	DECLARE @ErrorProcedure NVARCHAR(256);
	DECLARE @ErrorMessage NVARCHAR(2048);
	DECLARE @ErrorLine INT;
	
	BEGIN TRY

		IF NOT EXISTS (
						SELECT TOP 1 NULL
						FROM [dbo].[Account]
						WHERE [Id] = @Id
						AND [UserId] = @UserId
					  )
		BEGIN
			RAISERROR('Account does not exist: Id %I64d, UserId %s.', 16, -1, @Id, @UserId);
		END
	
		IF (@TranCount = 0)
			BEGIN TRANSACTION;
		
				UPDATE [dbo].[Account]
				   SET [Name] = ISNULL(@Name, [Name]),
					   [AccountTypeId] = ISNULL(@AccountTypeId, [AccountTypeId])
				 WHERE [Id] = @Id
				 AND [UserId] = @UserId;
		
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