CREATE PROCEDURE [dbo].[GetCurrency]
	@Id INT = NULL
AS
BEGIN
	SELECT [Id],
		   [Name],
		   [Symbol]
	FROM [dbo].[Currency]
	WHERE (@Id IS NULL OR [Id] = @Id);
END
