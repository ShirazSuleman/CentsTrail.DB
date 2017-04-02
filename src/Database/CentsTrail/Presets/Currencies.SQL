SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

MERGE INTO dbo.Currency AS Target
USING ( VALUES (1, 'USD', '$'),
			   (2, 'EUR', '€'),
			   (3, 'ZAR', 'R'),
			   (4, 'GBP', '£'),
			   (5, 'AUD', '$'),
			   (6, 'CAD', '$')) 
	  AS Source (CurrencyID, Name, Symbol)
	  ON (Target.CurrencyID = Source.CurrencyID)
	  WHEN MATCHED THEN
		UPDATE SET Name = Source.Name,
				   Symbol = Source.Symbol
	  WHEN NOT MATCHED BY TARGET THEN
		INSERT (CurrencyID, Name, Symbol)
		VALUES (Source.CurrencyID, Source.Name, Source.Symbol)
	  WHEN NOT MATCHED BY SOURCE THEN
		DELETE;
GO

