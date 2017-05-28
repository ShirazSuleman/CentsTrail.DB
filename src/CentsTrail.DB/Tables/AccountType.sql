CREATE TABLE [dbo].[AccountType]
(
	[Id] INT NOT NULL,
	[Name] NVARCHAR(256) NOT NULL,

	CONSTRAINT [pk_AccountType_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [uq_AccountType_Name] UNIQUE ([Name])
)
