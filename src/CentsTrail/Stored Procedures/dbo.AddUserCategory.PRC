SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

IF EXISTS (
			SELECT 1
			FROM sys.procedures
			WHERE name = 'AddUserCategory'
		  )
BEGIN
	DROP PROCEDURE [dbo].[AddUserCategory];
END;
GO

CREATE PROCEDURE [dbo].[AddUserCategory] @Name NVARCHAR(512),
										 @UserID NVARCHAR(128),
										 @Limit DECIMAL(15, 2) = NULL,
										 @TransactionTypeID INT
AS
BEGIN	
	DECLARE @TranCount INT = @@TRANCOUNT;
	
	DECLARE @ErrorProcedure NVARCHAR(256);
	DECLARE @ErrorMessage NVARCHAR(2048);
	DECLARE @ErrorLine INT;
	
	BEGIN TRY
	
		DECLARE @UserCategoryID BIGINT;
	
		IF (@TranCount = 0)
			BEGIN TRANSACTION;
		
				INSERT INTO [dbo].[UserCategory]
					   ([Name],
						[UserID],
						[Limit],
						[TransactionTypeID])
				 VALUES
					   (@Name,
						@UserID,
						@Limit,
						@TransactionTypeID);
						
				SELECT @UserCategoryID = SCOPE_IDENTITY();
		
		IF (@TranCount = 0 AND XACT_STATE() != 0)
			COMMIT TRANSACTION;
		
		RETURN @UserCategoryID;
		
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