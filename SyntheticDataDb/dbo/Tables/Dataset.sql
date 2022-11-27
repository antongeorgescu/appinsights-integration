CREATE TABLE [dbo].[Dataset] (
    [DatasetID]     INT           NOT NULL,
    [ContentTypeID] SMALLINT      NOT NULL,
    [Name]          VARCHAR (50)  NOT NULL,
    [ContentText]   VARCHAR (MAX) NOT NULL,
    [Description]   VARCHAR (500) NULL,
    [OnLastUpdated] DATETIME      NOT NULL,
    CONSTRAINT [PK_Dataset] PRIMARY KEY CLUSTERED ([DatasetID] ASC),
    CONSTRAINT [FK_Dataset_ContentType] FOREIGN KEY ([ContentTypeID]) REFERENCES [dbo].[ContentType] ([ContentTypeID])
);

