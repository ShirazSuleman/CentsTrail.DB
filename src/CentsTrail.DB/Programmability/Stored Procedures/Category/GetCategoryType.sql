CREATE PROCEDURE [dbo].[GetCategoryType]
	@Id INT = NULL
AS
BEGIN
	SELECT [Id],
		   [Name],
		   [IsLimitSupported]
	FROM [dbo].[CategoryType]
	WHERE (@Id IS NULL OR [Id] = @Id);
END
