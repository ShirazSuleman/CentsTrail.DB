SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

MERGE INTO dbo.TransactionType AS Target
USING ( VALUES (1, 'Income', 0),
			   (2, 'Expense', 1) ) 
	  AS Source (TransactionTypeID, Name, IsLimitSupported)
	  ON (Target.TransactionTypeID = Source.TransactionTypeID)
	  WHEN MATCHED THEN
		UPDATE SET Name = Source.Name,
				   IsLimitSupported = Source.IsLimitSupported
	  WHEN NOT MATCHED BY TARGET THEN
		INSERT (TransactionTypeID, Name, IsLimitSupported)
		VALUES (Source.TransactionTypeID, Source.Name, Source.IsLimitSupported)
	  WHEN NOT MATCHED BY SOURCE THEN
		DELETE;
GO

