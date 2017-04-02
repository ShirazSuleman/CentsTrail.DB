SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

IF EXISTS (
			SELECT 1
			FROM sys.procedures
			WHERE name = 'GetTransactionType'
		  )
BEGIN
	DROP PROCEDURE [dbo].[GetTransactionType];
END;
GO

CREATE PROCEDURE [dbo].[GetTransactionType] @TransactionTypeID INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [TransactionTypeID],
		   [Name],
		   [IsLimitSupported],
		   [DateAdded]
	FROM [dbo].[TransactionType]
	WHERE (@TransactionTypeID IS NULL OR TransactionTypeID = @TransactionTypeID);
END;
GO


