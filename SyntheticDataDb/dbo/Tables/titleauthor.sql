CREATE TABLE [dbo].[titleauthor](
	[au_id] [dbo].[id] NOT NULL,
	[title_id] [dbo].[tid] NOT NULL,
	[au_ord] [tinyint] NULL,
	[royaltyper] [int] NULL,
 CONSTRAINT [UPKCL_taind] PRIMARY KEY CLUSTERED 
(
	[au_id] ASC,
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[titleauthor]  WITH CHECK ADD FOREIGN KEY([au_id])
REFERENCES [dbo].[authors] ([au_id])
GO
ALTER TABLE [dbo].[titleauthor]  WITH CHECK ADD FOREIGN KEY([title_id])
REFERENCES [dbo].[titles] ([title_id])
GO
ALTER TABLE [dbo].[titleauthor]  WITH CHECK ADD FOREIGN KEY([au_id])
REFERENCES [dbo].[authors] ([au_id])
GO
ALTER TABLE [dbo].[titleauthor]  WITH CHECK ADD FOREIGN KEY([title_id])
REFERENCES [dbo].[titles] ([title_id])