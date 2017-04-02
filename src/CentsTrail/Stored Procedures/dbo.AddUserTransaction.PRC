SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

IF EXISTS (
			SELECT 1
			FROM sys.procedures
			WHERE name = 'AddUserTransaction'
		  )
BEGIN
	DROP PROCEDURE [dbo].[AddUserTransaction];
END;
GO

CREATE PROCEDURE [dbo].[AddUserTransaction] @Description NVARCHAR(256),
											@UserID NVARCHAR(128),
											@Amount DECIMAL(15, 2),
											@UserCategoryID BIGINT,
											@TransactionDate DATETIME
AS
BEGIN
	DECLARE @TranCount INT = @@TRANCOUNT;
	
	DECLARE @ErrorProcedure NVARCHAR(256);
	DECLARE @ErrorMessage NVARCHAR(2048);
	DECLARE @ErrorLine INT;

	BEGIN TRY
	
		DECLARE @UserTransactionID BIGINT;
		
		IF (@TranCount = 0)
			BEGIN TRANSACTION;

				INSERT INTO [dbo].[UserTransaction]
						   ([Description],
							[UserID],
							[Amount],
							[UserCategoryID],
							[TransactionDate])
				VALUES
					(@Description,
					 @UserID,
					 @Amount,
					 @UserCategoryID,
					 @TransactionDate);
						
				SELECT @UserTransactionID = SCOPE_IDENTITY();
		
		IF (@TranCount = 0 AND XACT_STATE() != 0)
			COMMIT TRANSACTION;
		
		RETURN @UserTransactionID;
		
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