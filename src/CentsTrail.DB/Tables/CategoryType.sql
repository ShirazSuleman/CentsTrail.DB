CREATE TABLE [dbo].[CategoryType]
(
	[Id] INT NOT NULL,
	[Name] NVARCHAR(256) NOT NULL,
	[IsLimitSupported] BIT NOT NULL CONSTRAINT [df_CategoryType_IsLimitSupported] DEFAULT ((0)),

	CONSTRAINT [pk_CategoryType_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [uq_CategoryType_Name] UNIQUE ([Name])
)
