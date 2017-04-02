SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

IF EXISTS (
			SELECT 1
			FROM sys.procedures
			WHERE name = 'GetUserCategory'
		  )
BEGIN
	DROP PROCEDURE [dbo].[GetUserCategory];
END;
GO

CREATE PROCEDURE [dbo].[GetUserCategory] @UserID NVARCHAR(128),
										 @UserCategoryID BIGINT = NULL
									 
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [UserCategoryID]
		  ,[UserID]
		  ,[Name]
		  ,[Limit]
		  ,[TransactionTypeID]
		  ,[DateAdded]
	FROM [dbo].[UserCategory]
	WHERE UserID = @UserID
	AND (@UserCategoryID IS NULL OR UserCategoryID = @UserCategoryID);
END;
GO


