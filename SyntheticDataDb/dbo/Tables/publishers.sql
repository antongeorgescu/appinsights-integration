CREATE TABLE [dbo].[publishers](
	[pub_id] [char](4) NOT NULL,
	[pub_name] [varchar](40) NULL,
	[city] [varchar](20) NULL,
	[state] [char](2) NULL,
	[country] [varchar](30) NULL,
 CONSTRAINT [UPKCL_pubind] PRIMARY KEY CLUSTERED 
(
	[pub_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[publishers] ADD  DEFAULT ('USA') FOR [country]
GO
ALTER TABLE [dbo].[publishers]  WITH CHECK ADD CHECK  (([pub_id]='1756' OR [pub_id]='1622' OR [pub_id]='0877' OR [pub_id]='0736' OR [pub_id]='1389' OR [pub_id] like '99[0-9][0-9]'))
GO
