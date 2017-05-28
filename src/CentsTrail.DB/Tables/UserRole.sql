CREATE TABLE [dbo].[UserRole]
(
    [UserId] NVARCHAR(128) NOT NULL,
    [RoleId] NVARCHAR(128) NOT NULL,

    CONSTRAINT [pk_UserRole_UserId_RoleId] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC),
	CONSTRAINT [fk_UserRole_Role_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Role] ([Id]) ON DELETE CASCADE,
	CONSTRAINT [fk_UserRole_User_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id]) ON DELETE CASCADE
)
GO

CREATE INDEX [ix_UserRole_UserId] ON [dbo].[UserRole] ([UserId])
GO

CREATE INDEX [ix_UserRole_RoleId] ON [dbo].[UserRole] ([RoleId])