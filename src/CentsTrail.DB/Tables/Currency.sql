CREATE TABLE [dbo].[Currency]
(
	[Id] INT NOT NULL,
	[Name] NVARCHAR(256) NOT NULL,
	[Symbol] CHAR(3) NOT NULL,

	CONSTRAINT [pk_Currency_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [uq_Currency_Name] UNIQUE ([Name])
)
