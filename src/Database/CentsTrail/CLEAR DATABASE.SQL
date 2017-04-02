
DELETE FROM [dbo].[UserTransaction];
DELETE FROM [dbo].[UserCategory];
DELETE FROM [dbo].[User];

DBCC CHECKIDENT ('dbo.UserTransaction', RESEED, 0); 
DBCC CHECKIDENT ('dbo.UserCategory', RESEED, 0); 
DBCC CHECKIDENT ('dbo.User', RESEED, 0); 