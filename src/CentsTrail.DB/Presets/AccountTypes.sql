MERGE INTO [dbo].[AccountType] AS Target
USING ( VALUES (1, 'Cheque'),
			   (2, 'Savings'),
			   (3, 'Credit Card') ) 
	  AS Source ([Id], [Name])
	  ON (Target.[Id] = Source.[Id])
	  WHEN MATCHED THEN
		UPDATE SET [Name] = Source.[Name]
	  WHEN NOT MATCHED BY TARGET THEN
		INSERT ([Id], [Name])
		VALUES (Source.[Id], Source.[Name])
	  WHEN NOT MATCHED BY SOURCE THEN
		DELETE;
GO