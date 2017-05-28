CREATE PROCEDURE [dbo].[GetAccountType]
	@Id INT = NULL
AS
BEGIN
	SELECT [Id],
		   [Name]
	FROM [dbo].[AccountType]
	WHERE (@Id IS NULL OR [Id] = @Id);
END
