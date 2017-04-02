SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

IF EXISTS (
			SELECT 1
			FROM sys.procedures
			WHERE name = 'GetUserTransaction'
		  )
BEGIN
	DROP PROCEDURE [dbo].[GetUserTransaction];
END;
GO

CREATE PROCEDURE [dbo].[GetUserTransaction] @UserID NVARCHAR(128),
											@UserCategoryID BIGINT = NULL,
											@UserTransactionID BIGINT = NULL,
											@StartDate DATETIME = NULL,
											@EndDate DATETIME = NULL,
											@TransactionTypeID INT = NULL
									 
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ut.[UserTransactionID]
		  ,ut.[UserCategoryID]
		  ,ut.[UserID]
		  ,ut.[Description]
		  ,ut.[Amount]
		  ,ut.[TransactionDate]
		  ,ut.[DateAdded]
		  ,uc.[TransactionTypeID]
	FROM [dbo].[UserTransaction] AS ut
	INNER JOIN [dbo].[UserCategory] AS uc
		ON uc.UserCategoryID = ut.UserCategoryID 
		AND uc.UserID = ut.UserID
	WHERE ut.UserID = @UserID
	AND (@UserCategoryID IS NULL OR ut.UserCategoryID = @UserCategoryID)
	AND (@UserTransactionID IS NULL OR ut.UserTransactionID = @UserTransactionID)
	AND (@StartDate IS NULL OR ut.TransactionDate >= @StartDate)
	AND (@EndDate IS NULL OR ut.TransactionDate <= @EndDate)
	AND (@TransactionTypeID IS NULL OR uc.TransactionTypeID = @TransactionTypeID);
END;
GO