SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

IF EXISTS (
			SELECT 1
			FROM sys.procedures
			WHERE name = 'UpdateUser'
		  )
BEGIN
	DROP PROCEDURE [dbo].[UpdateUser];
END;
GO

CREATE PROCEDURE [dbo].[UpdateUser] @UserID BIGINT,
									@PasswordHash NVARCHAR(128) = NULL,
									@PasswordSalt NVARCHAR(128) = NULL,
									@EmailConfirmed BIT = NULL,
									@FailedLoginAttempts INT = NULL,
									@IsLocked BIT = NULL,
									@FirstName NVARCHAR(256) = NULL,
									@LastName NVARCHAR(256) = NULL,
									@CurrencyID INT = NULL
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
						FROM [dbo].[User]
						WHERE UserID = @UserID
					  )
		BEGIN
			RAISERROR('UserID %I64d does not exist.', 16, -1, @UserID);
		END;
	
		IF (@TranCount = 0)
			BEGIN TRANSACTION;
		
				UPDATE [dbo].[User]
				   SET [PasswordHash] = ISNULL(@PasswordHash, [PasswordHash]),
					   [PasswordSalt] = ISNULL(@PasswordSalt, [PasswordSalt]),
					   [EmailConfirmed] = ISNULL(@EmailConfirmed, [EmailConfirmed]),
					   [FailedLoginAttempts] = ISNULL(@FailedLoginAttempts, [FailedLoginAttempts]),
					   [IsLocked] = ISNULL(@IsLocked, [IsLocked]),
					   [FirstName] = ISNULL(@FirstName, [FirstName]),
					   [LastName] = ISNULL(@LastName, [LastName]),
					   [CurrencyID] = ISNULL(@CurrencyID, [CurrencyID])
				 WHERE UserID = @UserID;
		
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