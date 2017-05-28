MERGE INTO [dbo].[CategoryType] AS Target
USING ( VALUES (1, 'Income', 0),
			   (2, 'Expense', 1),
			   (3, 'Transfer', 0) ) 
	  AS Source ([CategoryTypeId], [Name], [IsLimitSupported])
	  ON (Target.[CategoryTypeId] = Source.[CategoryTypeId])
	  WHEN MATCHED THEN
		UPDATE SET [Name] = Source.[Name],
				   [IsLimitSupported] = Source.[IsLimitSupported]
	  WHEN NOT MATCHED BY TARGET THEN
		INSERT ([CategoryTypeId], [Name], [IsLimitSupported])
		VALUES (Source.[CategoryTypeId], Source.[Name], Source.[IsLimitSupported])
	  WHEN NOT MATCHED BY SOURCE THEN
		DELETE;
GO