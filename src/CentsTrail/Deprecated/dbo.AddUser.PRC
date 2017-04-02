SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

IF EXISTS (
			SELECT 1
			FROM sys.procedures
			WHERE name = 'AddUser'
		  )
BEGIN
	DROP PROCEDURE [dbo].[AddUser];
END;
GO

CREATE PROCEDURE [dbo].[AddUser] @Email NVARCHAR(256),
								 @PasswordHash NVARCHAR(128),
								 @PasswordSalt NVARCHAR(128),
								 @EmailConfirmed BIT = 0,
								 @FirstName NVARCHAR(256) = NULL,
								 @LastName NVARCHAR(256) = NULL,
								 @CurrencyID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TranCount INT = @@TRANCOUNT;
	
	DECLARE @ErrorProcedure NVARCHAR(256);
	DECLARE @ErrorMessage NVARCHAR(2048);
	DECLARE @ErrorLine INT;
	
	BEGIN TRY
	
		DECLARE @UserID BIGINT;
	
		IF (@TranCount = 0)
			BEGIN TRANSACTION;
		
				INSERT INTO [dbo].[User]
						   ([PasswordHash],
						    [PasswordSalt],
						    [Email],
						    [EmailConfirmed],
						    [FirstName],
						    [LastName],
						    [CurrencyID])
				 VALUES
					   (@PasswordHash,
					    @PasswordSalt,
					    RTRIM(LTRIM(@Email)),
					    @EmailConfirmed,
					    @FirstName,
					    @LastName,
					    @CurrencyID);
						
				SELECT @UserID = SCOPE_IDENTITY();
		
		IF (@TranCount = 0 AND XACT_STATE() != 0)
			COMMIT TRANSACTION;
		
		RETURN @UserID;
		
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