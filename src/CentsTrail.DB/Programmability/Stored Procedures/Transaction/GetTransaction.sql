CREATE PROCEDURE [dbo].[GetTransaction]
	@UserId NVARCHAR(128),
	@Id BIGINT = NULL,
	@AccountId BIGINT = NULL,
	@CategoryId BIGINT = NULL,
	@PeriodId BIGINT = NULL,
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL,
	@CategoryTypeId INT = NULL
AS
BEGIN
	SELECT t.[Id]
		  ,t.[AccountId]
		  ,t.[CategoryId]
		  ,t.[PeriodId]
		  ,c.[Name] AS Category
		  ,p.[Name] AS Period
		  ,a.[Name] AS Account
		  ,t.[UserId]
		  ,t.[Description]
		  ,t.[Amount]
		  ,t.[TransactionDate]
		  ,t.[DateAdded]
		  ,c.[CategoryTypeId]
	FROM [dbo].[Transaction] AS t
	INNER JOIN [dbo].[Account] AS a
		ON a.[Id] = t.[AccountId]
		AND a.[UserId] = t.[UserId]
	INNER JOIN [dbo].[Category] AS c
		ON c.[Id] = t.[CategoryId]
		AND c.[UserId] = t.[UserId]
	INNER JOIN [dbo].[Period] AS p
		ON p.[Id] = t.[PeriodId]
		AND p.[UserId] = t.[UserId]
	WHERE t.[UserId] = @UserId
	AND (@AccountId IS NULL OR t.[AccountId] = @AccountId)
	AND (@CategoryId IS NULL OR t.[CategoryId] = @CategoryId)
	AND (@PeriodId IS NULL OR t.[PeriodId] = @PeriodId)
	AND (@Id IS NULL OR t.[Id] = @Id)
	AND (@StartDate IS NULL OR t.[TransactionDate] >= @StartDate)
	AND (@EndDate IS NULL OR t.[TransactionDate] <= @EndDate)
	AND (@CategoryTypeId IS NULL OR c.[CategoryTypeId] = @CategoryTypeId);
END
