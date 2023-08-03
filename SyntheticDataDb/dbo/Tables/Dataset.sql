CREATE TABLE [dbo].[Dataset] (
    [DatasetID]     INT           NOT NULL,
    [ContentTypeID] SMALLINT      NOT NULL,
    [Name]          VARCHAR (50)  NOT NULL,
    [ContentText]   TEXT          NOT NULL,
    [Description]   VARCHAR (500) NULL,
    [LastUpdated]   DATETIME      DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Dataset] PRIMARY KEY CLUSTERED ([DatasetID] ASC),
    CONSTRAINT [FK_Dataset_ContentType] FOREIGN KEY ([ContentTypeID]) REFERENCES [dbo].[ContentType] ([ContentTypeID])
);

