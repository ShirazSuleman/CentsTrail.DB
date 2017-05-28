CREATE PROCEDURE [dbo].[GetCategory]
	@UserId NVARCHAR(128),
	@Id BIGINT = NULL
AS
BEGIN
	SELECT [Id]
		  ,[UserId]
		  ,[Name]
		  ,[Limit]
		  ,[CategoryTypeId]
		  ,[DateAdded]
	FROM [dbo].[Category]
	WHERE [UserId] = @UserId
	AND (@Id IS NULL OR [Id] = @Id);
END
