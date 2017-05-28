CREATE PROCEDURE [dbo].[GetTransactionSummary]
	@UserId NVARCHAR(128),
	@AccountId BIGINT = NULL,
	@PartitionByCategory BIT = NULL,
	@PeriodId BIGINT = NULL,
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL 
AS
BEGIN
	IF (ISNULL(@PartitionByCategory, 0) = 0)
	BEGIN
		SELECT t.[UserId],
			   CAST(SUM(t.[Amount]) AS DECIMAL(15, 2)) AS AmountTotal,
			   c.[CategoryTypeId],
			   NULL AS [CategoryId]
		FROM [dbo].[Transaction] AS t
		INNER JOIN [dbo].[Category] AS c
			ON c.[Id] = t.[CategoryId]
			AND c.[UserId] = t.[UserId]
		WHERE t.[UserId] = @UserId
		AND (@AccountId IS NULL OR t.[AccountId] = @AccountId)
		AND (@PeriodId IS NULL OR t.[PeriodId] = @PeriodId)
		AND (@StartDate IS NULL OR t.[TransactionDate] >= @StartDate)
		AND (@EndDate IS NULL OR t.[TransactionDate] <= @EndDate)
		GROUP BY t.[UserId],
				 c.[CategoryTypeId];
	END
	ELSE
	BEGIN
		SELECT t.[UserID],
			   CAST(SUM(t.[Amount]) AS DECIMAL(15, 2)) AS AmountTotal,
			   c.[CategoryTypeId],
			   t.[CategoryId]
		FROM [dbo].[Transaction] AS t
		INNER JOIN [dbo].[Category] AS c
			ON c.[Id] = t.[CategoryId]
			AND c.[UserId] = t.[UserId]
		WHERE t.[UserId] = @UserId
		AND (@AccountId IS NULL OR t.[AccountId] = @AccountId)
		AND (@PeriodId IS NULL OR t.[PeriodId] = @PeriodId)
		AND (@StartDate IS NULL OR t.[TransactionDate] >= @StartDate)
		AND (@EndDate IS NULL OR t.[TransactionDate] <= @EndDate)
		GROUP BY t.[UserId],
				 c.[CategoryTypeId],
				 t.[CategoryId];
	END
END
