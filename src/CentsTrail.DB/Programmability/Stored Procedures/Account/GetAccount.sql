CREATE PROCEDURE [dbo].[GetAccount]
	@UserId NVARCHAR(128),
	@Id BIGINT = NULL
AS
BEGIN
	SELECT [Id]
		  ,[UserId]
		  ,[Name]
		  ,[AccountTypeId]
		  ,[DateAdded]
	FROM [dbo].[Account]
	WHERE [UserId] = @UserId
	AND (@Id IS NULL OR [Id] = @Id);
END