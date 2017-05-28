CREATE TABLE [dbo].[Period]
(
	[Id] BIGINT IDENTITY(1, 1) NOT NULL,
	[Name] NVARCHAR(256) NOT NULL,
	[UserId] NVARCHAR(128) NOT NULL,
	[StartDate] DATETIME NOT NULL,
	[EndDate] DATETIME,
	[DateAdded] DATETIME NOT NULL CONSTRAINT [df_Period_DateAdded] DEFAULT (GETUTCDATE())

	CONSTRAINT [pk_Period_Id_UserId] PRIMARY KEY CLUSTERED ([Id] ASC, [UserId] ASC),
	CONSTRAINT [uq_Period_Name_UserId] UNIQUE ([Name], [UserId]),
	CONSTRAINT [fk_Period_User_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id])
)
GO

CREATE UNIQUE INDEX [uq_Period_EndDate] ON [dbo].[Period] ([EndDate]) WHERE EndDate IS NULL
