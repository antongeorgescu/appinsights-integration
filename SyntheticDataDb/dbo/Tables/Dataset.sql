CREATE TABLE [dbo].[Dataset](
	[DatasetID] [int] NOT NULL,
	[ContentTypeID] [smallint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ContentText] [text] NOT NULL,
	[Description] [varchar](500) NULL,
	[LastUpdated] [datetime] NOT NULL,
 CONSTRAINT [PK_Dataset] PRIMARY KEY CLUSTERED 
(
	[DatasetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


GO
ALTER TABLE [dbo].[Dataset]  WITH CHECK ADD  CONSTRAINT [FK_Dataset_ContentType] FOREIGN KEY([ContentTypeID])
REFERENCES [dbo].[ContentType] ([ContentTypeID])
GO

ALTER TABLE [dbo].[Dataset] CHECK CONSTRAINT [FK_Dataset_ContentType]
GO


GO
ALTER TABLE [dbo].[Dataset] ADD  DEFAULT (getdate()) FOR [LastUpdated]
GO
