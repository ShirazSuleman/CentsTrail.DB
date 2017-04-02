SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

IF EXISTS (
			SELECT 1
			FROM sys.procedures
			WHERE name = 'DeleteUserCategory'
		  )
BEGIN
	DROP PROCEDURE [dbo].[DeleteUserCategory];
END;
GO

CREATE PROCEDURE [dbo].[DeleteUserCategory] @UserCategoryID BIGINT,
											@UserID NVARCHAR(128)
AS
BEGIN
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
		
				DELETE FROM [dbo].[UserCategory]
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