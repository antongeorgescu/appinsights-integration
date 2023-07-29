/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [alvazpoc]    Script Date: 7/29/2023 8:46:24 AM ******/
CREATE LOGIN [alvazpoc] WITH PASSWORD=N'MuP258nKp95CSQYQeoxJn28B/QL4ySDdU7l/xYB+Fzk=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [alvazpoc] DISABLE
GO

ALTER SERVER ROLE [securityadmin] ADD MEMBER [alvazpoc]
GO

ALTER SERVER ROLE [serveradmin] ADD MEMBER [alvazpoc]
GO

ALTER SERVER ROLE [dbcreator] ADD MEMBER [alvazpoc]
GO

/****** Object:  User [alvaz-agent]    Script Date: 7/29/2023 8:44:03 AM ******/
CREATE USER [alvaz-agent] FOR LOGIN [alvazpoc] WITH DEFAULT_SCHEMA=[dbo]