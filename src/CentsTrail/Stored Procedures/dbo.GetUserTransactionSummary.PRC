SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

IF EXISTS (
			SELECT 1
			FROM sys.procedures
			WHERE name = 'GetUserTransactionSummary'
		  )
BEGIN
	DROP PROCEDURE [dbo].[GetUserTransactionSummary];
END;
GO

CREATE PROCEDURE [dbo].[GetUserTransactionSummary] @UserID NVARCHAR(128),
												   @PartitionByCategory BIT = 0,
												   @StartDate DATETIME = NULL,
												   @EndDate DATETIME = NULL 
AS
BEGIN
	IF (@PartitionByCategory = 0)
	BEGIN
		SELECT ut.[UserID],
			   CAST(SUM(ut.[Amount]) AS DECIMAL(15, 2)) AS AmountTotal,
			   uc.[TransactionTypeID],
			   NULL AS [UserCategoryID]
		FROM [dbo].[UserTransaction] AS ut
		INNER JOIN [dbo].[UserCategory] AS uc
			ON uc.UserCategoryID = ut.UserCategoryID 
			AND uc.UserID = ut.UserID
		WHERE ut.UserID = @UserID
		AND (@StartDate IS NULL OR ut.TransactionDate >= @StartDate)
		AND (@EndDate IS NULL OR ut.TransactionDate <= @EndDate)
		GROUP BY ut.UserID,
				 uc.TransactionTypeID;
	END
	ELSE
	BEGIN
		SELECT ut.[UserID],
			   CAST(SUM(ut.[Amount]) AS DECIMAL(15, 2)) AS AmountTotal,
			   uc.[TransactionTypeID],
			   ut.[UserCategoryID]
		FROM [dbo].[UserTransaction] AS ut
		INNER JOIN [dbo].[UserCategory] AS uc
			ON uc.UserCategoryID = ut.UserCategoryID 
			AND uc.UserID = ut.UserID
		WHERE ut.UserID = @UserID
		AND (@StartDate IS NULL OR ut.TransactionDate >= @StartDate)
		AND (@EndDate IS NULL OR ut.TransactionDate <= @EndDate)
		GROUP BY ut.UserID,
				 uc.TransactionTypeID,
				 ut.UserCategoryID;
	END
END;
GO