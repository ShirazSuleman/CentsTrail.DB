CREATE TABLE [dbo].[Account]
(
	[Id] BIGINT IDENTITY(1, 1) NOT NULL,
	[Name] NVARCHAR(256) NOT NULL,
	[UserId] NVARCHAR(128) NOT NULL,
	[AccountTypeId] INT NOT NULL,
	[DateAdded] DATETIME NOT NULL CONSTRAINT [df_Account_DateAdded] DEFAULT (GETUTCDATE())

	CONSTRAINT [pk_Account_Id_UserId] PRIMARY KEY CLUSTERED ([Id] ASC, [UserId] ASC),
	CONSTRAINT [uq_Account_Name_UserId] UNIQUE ([Name], [UserId]),
	CONSTRAINT [fk_Account_User_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id]),
	CONSTRAINT [fk_Account_AccountType_AccountTypeId] FOREIGN KEY ([AccountTypeId]) REFERENCES [dbo].[AccountType] ([Id])
)
