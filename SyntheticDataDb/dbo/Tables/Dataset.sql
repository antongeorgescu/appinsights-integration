CREATE TABLE [dbo].[Dataset] (
    [DatasetID] [int] IDENTITY(1,1) NOT NULL,
	[ContentTypeID] [smallint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ContentText] [text] NOT NULL,
	[Description] [varchar](500) NULL,
	[LastUpdated] [datetime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Dataset] PRIMARY KEY CLUSTERED ([DatasetID] ASC),
	CONSTRAINT [FK_Dataset_ContentType] FOREIGN KEY ([ContentTypeID]) REFERENCES [dbo].[ContentType] ([ContentTypeID])
);

