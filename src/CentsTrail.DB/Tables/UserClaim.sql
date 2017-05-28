CREATE TABLE [dbo].[UserClaim]
(
    [Id] INT NOT NULL IDENTITY(1, 1),
    [UserId] NVARCHAR(128) NOT NULL,
    [ClaimType] NVARCHAR(MAX),
    [ClaimValue] NVARCHAR(MAX),

    CONSTRAINT [pk_UserClaim_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [fk_UserClaim_User_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id]) ON DELETE CASCADE
)
GO

CREATE INDEX [ix_UserClaim_UserId] ON [dbo].[UserClaim] ([UserId])
