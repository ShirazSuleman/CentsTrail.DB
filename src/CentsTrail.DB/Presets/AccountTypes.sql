MERGE INTO [dbo].[AccountType] AS Target
USING ( VALUES (1, 'Cheque'),
			   (2, 'Savings'),
			   (3, 'Credit Card') ) 
	  AS Source ([AccountTypeId], [Name])
	  ON (Target.[AccountTypeId] = Source.[AccountTypeId])
	  WHEN MATCHED THEN
		UPDATE SET [Name] = Source.[Name]
	  WHEN NOT MATCHED BY TARGET THEN
		INSERT ([AccountTypeId], [Name])
		VALUES (Source.[AccountTypeId], Source.[Name])
	  WHEN NOT MATCHED BY SOURCE THEN
		DELETE;
GO