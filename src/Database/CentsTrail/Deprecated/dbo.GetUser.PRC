SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

IF EXISTS (
			SELECT 1
			FROM sys.procedures
			WHERE name = 'GetUser'
		  )
BEGIN
	DROP PROCEDURE [dbo].[GetUser];
END;
GO

CREATE PROCEDURE [dbo].[GetUser] @Email NVARCHAR(256) = NULL,
								 @UserID BIGINT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	IF (@Email IS NOT NULL AND @UserID IS NOT NULL)
	BEGIN
		RAISERROR('Both UserID and Email may not be supplied.', 16, -1);
		RETURN;
	END

	SELECT [UserID],
		   [Email],
		   [PasswordHash],
		   [PasswordSalt],
		   [EmailConfirmed],
		   [FailedLoginAttempts],
		   [IsLocked],
		   [FirstName],
		   [LastName],
		   [CurrencyID]
	FROM [dbo].[User]
	WHERE Email = RTRIM(LTRIM(@Email)) OR UserID = @UserID;
END;
GO