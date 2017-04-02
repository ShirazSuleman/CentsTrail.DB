SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

IF EXISTS (
			SELECT 1
			FROM sys.procedures
			WHERE name = 'UpdateUserTransaction'
		  )
BEGIN
	DROP PROCEDURE [dbo].[UpdateUserTransaction];
END;
GO

CREATE PROCEDURE [dbo].[UpdateUserTransaction] @UserTransactionID BIGINT,
											   @UserID NVARCHAR(128),
											   @Description NVARCHAR(512) = NULL,
											   @Amount DECIMAL(15, 2) = NULL,
											   @TransactionDate DATETIME = NULL,
											   @UserCategoryID BIGINT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TranCount INT = @@TRANCOUNT;
	
	DECLARE @ErrorProcedure NVARCHAR(256);
	DECLARE @ErrorMessage NVARCHAR(2048);
	DECLARE @ErrorLine INT;
	
	BEGIN TRY

		IF NOT EXISTS (
						SELECT TOP 1 NULL
						FROM [dbo].[UserTransaction]
						WHERE UserTransactionID = @UserTransactionID
						AND UserID = @UserID
					  )
		BEGIN
			RAISERROR('UserTransactionID %I64d does not exist for UserID %s.', 16, -1, @UserTransactionID, @UserID);
		END;
	
		IF (@TranCount = 0)
			BEGIN TRANSACTION;
		
				UPDATE [dbo].[UserTransaction]
				   SET [UserCategoryID] = ISNULL(@UserCategoryID, [UserCategoryID]),
					   [Description] = ISNULL(@Description, [Description]),
					   [Amount] = ISNULL(@Amount, [Amount]),
					   [TransactionDate] = ISNULL(@TransactionDate, [TransactionDate])
				 WHERE UserTransactionID = @UserTransactionID
				 AND UserID = @UserID;
		
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
END;
GO