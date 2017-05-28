CREATE TABLE [dbo].[Transaction]
(
	[Id] BIGINT IDENTITY(1, 1) NOT NULL,
	[Description] NVARCHAR(256) NOT NULL,
	[UserId] NVARCHAR(128) NOT NULL,
	[Amount] DECIMAL(15, 2) NOT NULL,
	[CategoryId] BIGINT NOT NULL,
	[AccountId] BIGINT NOT NULL,
	[PeriodId] BIGINT NOT NULL,
	[DateAdded] DATETIME NOT NULL CONSTRAINT [df_Transaction_DateAdded] DEFAULT (GETUTCDATE()),
	[TransactionDate] DATETIME NOT NULL,

	CONSTRAINT [pk_Transaction_Id_UserId] PRIMARY KEY CLUSTERED ([Id] ASC, [UserId] ASC),
	CONSTRAINT [fk_Transaction_User_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id]),
	CONSTRAINT [fk_Transaction_Category_CategoryId_UserId] FOREIGN KEY ([CategoryId], [UserId]) REFERENCES [dbo].[Category] ([Id], [UserId]) ON DELETE CASCADE,
	CONSTRAINT [fk_Transaction_Account_AccountId_UserId] FOREIGN KEY ([AccountId], [UserId]) REFERENCES [dbo].[Account] ([Id], [UserId]) ON DELETE CASCADE,
	CONSTRAINT [fk_Transaction_Period_PeriodId_UserId] FOREIGN KEY ([PeriodId], [UserId]) REFERENCES [dbo].[Period] ([Id], [UserId]) ON DELETE CASCADE,
	CONSTRAINT [ck_Transaction_Amount] CHECK ([Amount] > 0)
)
