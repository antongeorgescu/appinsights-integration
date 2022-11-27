CREATE TABLE [dbo].[ContentType] (
    [ContentTypeID] SMALLINT      NOT NULL,
    [Code]          VARCHAR (10)  NOT NULL,
    [Name]          VARCHAR (50)  NOT NULL,
    [Description]   VARCHAR (300) NULL,
    CONSTRAINT [PK_ContentType] PRIMARY KEY CLUSTERED ([ContentTypeID] ASC)
);

