SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

IF EXISTS (
			SELECT 1
			FROM sys.procedures
			WHERE name = 'UpdateUserCategory'
		  )
BEGIN
	DROP PROCEDURE [dbo].[UpdateUserCategory];
END;
GO

CREATE PROCEDURE [dbo].[UpdateUserCategory] @UserCategoryID BIGINT,
											@UserID NVARCHAR(128),
											@Name NVARCHAR(512) = NULL,
											@Limit DECIMAL(15, 2) = NULL,
											@TransactionTypeID INT = NULL
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
						FROM [dbo].[UserCategory]
						WHERE UserCategoryID = @UserCategoryID
						AND UserID = @UserID
					  )
		BEGIN
			RAISERROR('UserCategoryID %I64d does not exist for UserID %s.', 16, -1, @UserCategoryID, @UserID);
		END;
	
		IF (@TranCount = 0)
			BEGIN TRANSACTION;
		
				UPDATE [dbo].[UserCategory]
				   SET [Name] = ISNULL(@Name, [Name]),
					   [Limit] = ISNULL(@Limit, [Limit]),
					   [TransactionTypeID] = ISNULL(@TransactionTypeID, [TransactionTypeID])
				 WHERE UserCategoryID = @UserCategoryID
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