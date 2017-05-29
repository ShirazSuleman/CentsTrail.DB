MERGE INTO [dbo].[Currency] AS Target
USING ( VALUES (1, 'USD', '$'),
			   (2, 'EUR', '€'),
			   (3, 'ZAR', 'R'),
			   (4, 'GBP', '£'),
			   (5, 'AUD', '$'),
			   (6, 'CAD', '$') ) 
	  AS Source ([Id], [Name], [Symbol])
	  ON (Target.[Id] = Source.[Id])
	  WHEN MATCHED THEN
		UPDATE SET [Name] = Source.[Name],
				   [Symbol] = Source.[Symbol]
	  WHEN NOT MATCHED BY TARGET THEN
		INSERT ([Id], [Name], [Symbol])
		VALUES (Source.[Id], Source.[Name], Source.[Symbol])
	  WHEN NOT MATCHED BY SOURCE THEN
		DELETE;
GO