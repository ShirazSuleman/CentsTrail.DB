MERGE INTO [dbo].[Currency] AS Target
USING ( VALUES (1, 'USD', '$'),
			   (2, 'EUR', '€'),
			   (3, 'ZAR', 'R'),
			   (4, 'GBP', '£'),
			   (5, 'AUD', '$'),
			   (6, 'CAD', '$') ) 
	  AS Source ([CurrencyId], [Name], [Symbol])
	  ON (Target.[CurrencyId] = Source.[CurrencyId])
	  WHEN MATCHED THEN
		UPDATE SET [Name] = Source.[Name],
				   [Symbol] = Source.[Symbol]
	  WHEN NOT MATCHED BY TARGET THEN
		INSERT ([CurrencyId], [Name], [Symbol])
		VALUES (Source.[CurrencyId], Source.[Name], Source.[Symbol])
	  WHEN NOT MATCHED BY SOURCE THEN
		DELETE;
GO