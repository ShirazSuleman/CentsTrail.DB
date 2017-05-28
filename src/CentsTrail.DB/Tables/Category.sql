CREATE TABLE [dbo].[Category]
(
	[Id] BIGINT IDENTITY(1, 1) NOT NULL,
	[Name] NVARCHAR(256) NOT NULL,
	[UserId] NVARCHAR(128) NOT NULL,
	[Limit] DECIMAL(15, 2),
	[CategoryTypeId] INT NOT NULL,
	[DateAdded] DATETIME NOT NULL CONSTRAINT [df_Category_DateAdded] DEFAULT (GETUTCDATE())

	CONSTRAINT [pk_Category_Id_UserId] PRIMARY KEY CLUSTERED ([Id] ASC, [UserId] ASC),
	CONSTRAINT [uq_Category_Name_UserId] UNIQUE ([Name], [UserId]),
	CONSTRAINT [fk_Category_User_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id]),
	CONSTRAINT [fk_Category_CategoryType_CategoryTypeId] FOREIGN KEY ([CategoryTypeId]) REFERENCES [dbo].[CategoryType] ([Id])
)
