CREATE TABLE [dbo].[UserLogin]
(
    [LoginProvider] NVARCHAR(128) NOT NULL,
    [ProviderKey] NVARCHAR(128) NOT NULL,
    [UserId] NVARCHAR(128) NOT NULL,

    CONSTRAINT [pk_UserLogin_LoginProvider_ProviderKey_UserId] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC, [UserId] ASC),
	CONSTRAINT [fk_UserLogin_User_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id]) ON DELETE CASCADE
)
GO

CREATE INDEX [ix_UserLogin_UserId] ON [dbo].[UserLogin] ([UserId])
