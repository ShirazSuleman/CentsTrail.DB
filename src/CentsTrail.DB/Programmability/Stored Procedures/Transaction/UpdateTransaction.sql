CREATE PROCEDURE [dbo].[UpdateTransaction]
	@Id BIGINT,
	@UserId NVARCHAR(128),
	@Description NVARCHAR(512) = NULL,
	@Amount DECIMAL(15, 2) = NULL,
	@TransactionDate DATETIME = NULL,
	@AccountId BIGINT = NULL,
	@CategoryId BIGINT = NULL,
	@PeriodId BIGINT = NULL
AS
BEGIN
	DECLARE @TranCount INT = @@TRANCOUNT;
	
	DECLARE @ErrorProcedure NVARCHAR(256);
	DECLARE @ErrorMessage NVARCHAR(2048);
	DECLARE @ErrorLine INT;
	
	BEGIN TRY

		IF NOT EXISTS (
						SELECT TOP 1 NULL
						FROM [dbo].[Transaction]
						WHERE [Id] = @Id
						AND [UserId] = @UserId
					  )
		BEGIN
			RAISERROR('Transaction does not exist: Id %I64d, UserId %s.', 16, -1, @Id, @UserId);
		END
	
		IF (@TranCount = 0)
			BEGIN TRANSACTION;
		
				UPDATE [dbo].[Transaction]
				   SET [AccountId] = ISNULL(@AccountId, [AccountId]),
					   [CategoryId] = ISNULL(@CategoryId, [CategoryId]),
					   [PeriodId] = ISNULL(@PeriodId, [PeriodId]),
					   [Description] = ISNULL(@Description, [Description]),
					   [Amount] = ISNULL(@Amount, [Amount]),
					   [TransactionDate] = ISNULL(@TransactionDate, [TransactionDate])
				 WHERE [Id] = @Id
				 AND [UserId] = @UserId;
		
		IF (@TranCount = 0 AND XACT_STATE() != 0)
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		IF (@TranCount = 0 AND XACT_STATE() != 0)
			ROLLBACK TRANSACTION;
		
		SELECT @ErrorMessage = ERROR_MESSAGE(),
			   @ErrorProcedure = ERROR_PROCEDURE(),
			   @ErrorLine = ERROR_LINE();
			   
		SET @ErrorMessage = 'Error in %s on line %d. ' + @ErrorMessage;
		RAISERROR(@ErrorMessage, 16, -1, @ErrorProcedure, @ErrorLine);
	
	END CATCH
END
