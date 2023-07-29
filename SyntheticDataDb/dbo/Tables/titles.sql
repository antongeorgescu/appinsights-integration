CREATE TABLE [dbo].[titles](
	[title_id] [dbo].[tid] NOT NULL,
	[title] [varchar](80) NOT NULL,
	[type] [char](12) NOT NULL,
	[pub_id] [char](4) NULL,
	[price] [money] NULL,
	[advance] [money] NULL,
	[royalty] [int] NULL,
	[ytd_sales] [int] NULL,
	[notes] [varchar](200) NULL,
	[pubdate] [datetime] NOT NULL,
 CONSTRAINT [UPKCL_titleidind] PRIMARY KEY CLUSTERED 
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[titles]  WITH CHECK ADD FOREIGN KEY([pub_id])
REFERENCES [dbo].[publishers] ([pub_id])
GO
ALTER TABLE [dbo].[titles] ADD  DEFAULT ('UNDECIDED') FOR [type]
GO
ALTER TABLE [dbo].[titles] ADD  DEFAULT (getdate()) FOR [pubdate]
GO
ALTER TABLE [dbo].[titles]  WITH CHECK ADD FOREIGN KEY([pub_id])
REFERENCES [dbo].[publishers] ([pub_id])
GO

