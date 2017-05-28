CREATE PROCEDURE [dbo].[GetPeriod]
	@UserId NVARCHAR(128),
	@Id BIGINT = NULL
AS
BEGIN
	SELECT [Id]
		  ,[UserId]
		  ,[Name]
		  ,[StartDate]
		  ,[EndDate]
		  ,[DateAdded]
	FROM [dbo].[Period]
	WHERE [UserId] = @UserId
	AND (@Id IS NULL OR [Id] = @Id);
END
