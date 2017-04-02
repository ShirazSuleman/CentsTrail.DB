SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

IF EXISTS (
			SELECT 1
			FROM sys.procedures
			WHERE name = 'GetCurrency'
		  )
BEGIN
	DROP PROCEDURE [dbo].[GetCurrency];
END;
GO

CREATE PROCEDURE [dbo].[GetCurrency] @CurrencyID INT = NULL
AS
BEGIN
	SELECT [CurrencyID],
		   [Name],
		   [Symbol]
	FROM [dbo].[Currency]
	WHERE (@CurrencyID IS NULL OR CurrencyID = @CurrencyID);
END;
GO


