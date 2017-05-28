CREATE TABLE [dbo].[__MigrationHistory]
(
    [MigrationId] NVARCHAR(150) NOT NULL,
    [ContextKey] NVARCHAR(300) NOT NULL,
    [Model] VARBINARY(MAX) NOT NULL,
    [ProductVersion] NVARCHAR(32) NOT NULL,

    CONSTRAINT [pk_MigrationHistory_MigrationId_ContextKey] PRIMARY KEY CLUSTERED ([MigrationId] ASC, [ContextKey] ASC)
)
