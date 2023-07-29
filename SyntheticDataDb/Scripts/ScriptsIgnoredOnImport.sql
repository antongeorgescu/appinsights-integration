
USE [ArchitectWorks]
GO

/****** Object:  Table [dbo].[authors]    Script Date: 7/29/2023 8:31:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[ContentType]    Script Date: 7/29/2023 8:31:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[Dataset]    Script Date: 7/29/2023 8:31:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[publishers]    Script Date: 7/29/2023 8:31:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[titleauthor]    Script Date: 7/29/2023 8:31:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[titles]    Script Date: 7/29/2023 8:31:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[WorkItem]    Script Date: 7/29/2023 8:31:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[WorkType]    Script Date: 7/29/2023 8:31:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'172-32-1176', N'White', N'Johnson', N'408 496-7223', N'10932 Bigge Rd.', N'Menlo Park', N'CA', N'94025', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'213-46-8915', N'Green', N'Marjorie', N'415 986-7020', N'309 63rd St. #411', N'Oakland', N'CA', N'94618', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'238-95-7766', N'Carson', N'Cheryl', N'415 548-7723', N'589 Darwin Ln.', N'Berkeley', N'CA', N'94705', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'267-41-2394', N'O''Leary', N'Michael', N'408 286-2428', N'22 Cleveland Av. #14', N'San Jose', N'CA', N'95128', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'274-80-9391', N'Straight', N'Dean', N'415 834-2919', N'5420 College Av.', N'Oakland', N'CA', N'94609', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'341-22-1782', N'Smith', N'Meander', N'913 843-0462', N'10 Mississippi Dr.', N'Lawrence', N'KS', N'66044', 0)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'409-56-7008', N'Bennet', N'Abraham', N'415 658-9932', N'6223 Bateman St.', N'Berkeley', N'CA', N'94705', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'427-17-2319', N'Dull', N'Ann', N'415 836-7128', N'3410 Blonde St.', N'Palo Alto', N'CA', N'94301', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'472-27-2349', N'Gringlesby', N'Burt', N'707 938-6445', N'PO Box 792', N'Covelo', N'CA', N'95428', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'486-29-1786', N'Locksley', N'Charlene', N'415 585-4620', N'18 Broadway Av.', N'San Francisco', N'CA', N'94130', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'527-72-3246', N'Greene', N'Morningstar', N'615 297-2723', N'22 Graybar House Rd.', N'Nashville', N'TN', N'37215', 0)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'648-92-1872', N'Blotchet-Halls', N'Reginald', N'503 745-6402', N'55 Hillsdale Bl.', N'Corvallis', N'OR', N'97330', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'672-71-3249', N'Yokomoto', N'Akiko', N'415 935-4228', N'3 Silver Ct.', N'Walnut Creek', N'CA', N'94595', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'712-45-1867', N'del Castillo', N'Innes', N'615 996-8275', N'2286 Cram Pl. #86', N'Ann Arbor', N'MI', N'48105', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'722-51-5454', N'DeFrance', N'Michel', N'219 547-9982', N'3 Balding Pl.', N'Gary', N'IN', N'46403', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'724-08-9931', N'Stringer', N'Dirk', N'415 843-2991', N'5420 Telegraph Av.', N'Oakland', N'CA', N'94609', 0)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'724-80-9391', N'MacFeather', N'Stearns', N'415 354-7128', N'44 Upland Hts.', N'Oakland', N'CA', N'94612', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'756-30-7391', N'Karsen', N'Livia', N'415 534-9219', N'5720 McAuley St.', N'Oakland', N'CA', N'94609', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'807-91-6654', N'Panteley', N'Sylvia', N'301 946-8853', N'1956 Arlington Pl.', N'Rockville', N'MD', N'20853', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'846-92-7186', N'Hunter', N'Sheryl', N'415 836-7128', N'3410 Blonde St.', N'Palo Alto', N'CA', N'94301', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'893-72-1158', N'McBadden', N'Heather', N'707 448-4982', N'301 Putnam', N'Vacaville', N'CA', N'95688', 0)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'899-46-2035', N'Ringer', N'Anne', N'801 826-0752', N'67 Seventh Av.', N'Salt Lake City', N'UT', N'84152', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'998-72-3567', N'Ringer', N'Albert', N'801 826-0752', N'67 Seventh Av.', N'Salt Lake City', N'UT', N'84152', 1)
GO

INSERT [dbo].[ContentType] ([ContentTypeID], [Code], [Name], [Description]) VALUES (1, N'IPSLOR', N'Ipsum lorem message', N'Mock words in an ipsum lorem generated message')
GO

INSERT [dbo].[Dataset] ([DatasetID], [ContentTypeID], [Name], [ContentText], [Description], [LastUpdated]) VALUES (1, 1, N'Ipsum lorem multi-paragraph', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce et augue justo. Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed condimentum lorem quis dignissim pulvinar. Morbi rhoncus ante dolor, in fermentum orci egestas in. Integer sed imperdiet dolor. Aliquam feugiat laoreet sem venenatis malesuada. Vivamus congue quis sapien vitae pulvinar. Aenean sed lectus vitae erat dapibus finibus. Proin ut malesuada nulla.Suspendisse eu neque ex. Donec mauris magna, facilisis nec arcu sit amet, ultricies efficitur nunc. Donec dapibus sodales tellus sed sodales. Interdum et malesuada fames ac ante ipsum primis in faucibus. Duis ac magna mollis, pellentesque metus nec, aliquam lorem. Cras purus turpis, consequat eget dignissim eu, tristique a risus. Mauris vitae ultricies ante, a venenatis nisl. Proin non purus magna. Vivamus maximus, ex laoreet dignissim congue, libero neque dignissim leo, eget porttitor mi eros eu tellus. Sed mauris arcu, dictum vitae interdum ac, mollis vitae turpis. Nulla imperdiet sapien vel vulputate ornare. Suspendisse sapien lorem, dapibus eu malesuada et, maximus in diam. Vestibulum consectetur eleifend metus, quis imperdiet risus fringilla a. Nam at nunc ut est mollis ultrices.Curabitur eget pellentesque est. Duis ac felis lobortis, dapibus orci at, sodales est. Fusce a lobortis mauris. Suspendisse vehicula suscipit turpis, vitae consequat felis scelerisque eget. Nullam facilisis at massa non pellentesque. In porta vitae eros vel finibus. Pellentesque vehicula lacus vitae odio tristique sodales. Etiam viverra quam at pretium tempor. Morbi varius aliquam nulla, auctor semper tortor feugiat eu. Vivamus at lobortis purus, et rutrum orci. Pellentesque placerat vitae nulla ac vulputate.Morbi vitae augue commodo, maximus nibh in, vulputate felis. Praesent ac dui bibendum lacus cursus posuere eget eu ipsum. Praesent pulvinar cursus tortor eget convallis. Etiam iaculis rutrum quam nec lobortis. Nunc sit amet felis nisl. Quisque dapibus justo magna, in eleifend lacus congue in. Aenean ut augue est. Mauris nisl lacus, bibendum id dapibus eu, vestibulum in neque. Proin lobortis ante in suscipit dictum. Nullam orci quam, mollis in lectus nec, elementum volutpat risus. Quisque aliquam nibh et lectus sodales, ac posuere lectus mattis.Nullam in elit justo. Vestibulum venenatis diam ut odio vulputate convallis. Phasellus nec ultrices ligula, nec dictum ante. Ut eget facilisis urna. Etiam vel sollicitudin eros, rhoncus tincidunt urna. Cras id neque vitae dolor molestie dapibus id et ipsum. Mauris a aliquam turpis. Sed eu suscipit ipsum. Praesent in elementum lorem. Sed sem dolor, fringilla a viverra et, ultricies a felis. Quisque in nunc et lectus venenatis bibendum hendrerit in ligula.Maecenas mi diam, aliquet ut sem a, varius convallis augue. Sed tincidunt ornare felis ac viverra. Cras nec velit diam. Morbi est velit, hendrerit a commodo sed, molestie vel massa. Vivamus eu arcu sit amet enim ultrices vestibulum semper nec justo. Suspendisse euismod porta dolor, nec volutpat eros tempor sed. Nunc pulvinar est sed magna ultricies, nec elementum ligula maximus. Phasellus tempus lorem aliquam odio feugiat vehicula. Integer fermentum blandit rhoncus. Integer convallis sagittis vehicula. Nulla et maximus risus, sed consequat velit. Donec rutrum risus risus, ac accumsan magna porta et. Nulla scelerisque malesuada urna, non imperdiet mi volutpat eu. Phasellus facilisis, ipsum finibus euismod venenatis, lacus elit facilisis metus, sed commodo elit eros vitae lacus. Cras facilisis ac mauris eget efficitur.Phasellus ac ante vel nulla malesuada mattis et nec nisl. Integer feugiat id dui non tempus. Proin ultrices, leo eu finibus pellentesque, turpis risus vulputate risus, ut volutpat magna ipsum eu nulla. Nunc porttitor, lacus eu fermentum ullamcorper, lacus sem pharetra nunc, id hendrerit enim purus in odio. Curabitur eget purus augue. Fusce feugiat mauris ac arcu finibus, non rhoncus ipsum volutpat. Sed ultrices dictum aliquet. Curabitur nisi nisi, rutrum eget pulvinar nec, bibendum ac metus. Nullam accumsan velit non mollis aliquet. Mauris purus velit, pharetra eu efficitur a, porttitor a dolor. Integer sed nisl gravida, vulputate felis eget, lacinia arcu. Nulla non aliquam nunc. Cras bibendum blandit finibus. Donec et velit scelerisque, tempor diam eget, convallis orci. In nulla sem, pretium sit amet fringilla interdum, luctus hendrerit nibh.Etiam gravida lacus nec vehicula maximus. Phasellus aliquam purus a vehicula scelerisque. Proin feugiat turpis a massa porta, pharetra congue nulla ultrices. Nunc non finibus ipsum. Duis mattis condimentum diam non tempor. Aenean suscipit mi ex, nec venenatis nunc tincidunt in. Ut quam leo, lobortis et euismod ac, egestas a massa. In sit amet lectus a lorem congue porttitor non quis purus. Mauris eleifend nisl ac aliquet luctus. Vestibulum id lorem interdum, pharetra dolor et, lobortis dui. Nam sagittis dapibus fringilla. Vivamus vehicula molestie diam, vitae congue turpis bibendum vitae.Nulla fringilla et nisi id porta. Proin fringilla suscipit nisi. Aliquam vel arcu metus. Ut sodales fermentum est, nec fringilla magna tempor et. Duis vitae bibendum velit. Vivamus faucibus dui eros, id tempus arcu faucibus a. Curabitur elit lacus, volutpat sed risus eget, fringilla euismod libero. Maecenas odio est, interdum ut lacus sed, molestie tempor arcu. Suspendisse mollis eros vel dolor ornare, non venenatis nunc lobortis. Sed mi risus, consectetur in eleifend sed, sagittis sit amet elit. Proin rutrum ullamcorper mi sit amet facilisis. Etiam placerat ullamcorper velit. Etiam sollicitudin sapien sagittis, aliquam lacus iaculis, euismod nunc. Vivamus rutrum quam et sapien porta lobortis.Integer euismod quam nisl, quis tristique magna hendrerit sit amet. Suspendisse venenatis nibh ac nibh ullamcorper, eget vulputate lacus volutpat. Sed massa justo, facilisis in quam a, rutrum tincidunt est. Nunc posuere magna eget eleifend rutrum. Fusce feugiat sed metus sed faucibus. Fusce elementum, libero eu convallis dapibus, eros eros efficitur nisi, quis cursus quam sapien et augue. Pellentesque bibendum elit at mi egestas fermentum. Praesent at lacus ultricies, viverra arcu sit amet, scelerisque ante. Quisque odio nibh, semper nec nisl in, pulvinar vulputate odio. Aliquam ipsum turpis, congue in magna nec, efficitur consectetur est. Fusce eget faucibus turpis.', N'Set of poaragraphs with ipsum lorem content', CAST(N'2023-07-27T16:59:16.943' AS DateTime))
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'0736', N'New Moon Books', N'Boston', N'MA', N'USA')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'0877', N'Binnet & Hardley', N'Washington', N'DC', N'USA')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'1389', N'Algodata Infosystems', N'Berkeley', N'CA', N'USA')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'1622', N'Five Lakes Publishing', N'Chicago', N'IL', N'USA')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'1756', N'Ramona Publishers', N'Dallas', N'TX', N'USA')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'9901', N'GGG&G', N'M?nchen', NULL, N'Germany')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'9952', N'Scootney Books', N'New York', N'NY', N'USA')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'9999', N'Lucerne Publishing', N'Paris', NULL, N'France')
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'172-32-1176', N'PS3333', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'213-46-8915', N'BU1032', 2, 40)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'213-46-8915', N'BU2075', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'238-95-7766', N'PC1035', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'267-41-2394', N'BU1111', 2, 40)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'267-41-2394', N'TC7777', 2, 30)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'274-80-9391', N'BU7832', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'409-56-7008', N'BU1032', 1, 60)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'427-17-2319', N'PC8888', 1, 50)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'472-27-2349', N'TC7777', 3, 30)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'486-29-1786', N'PC9999', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'486-29-1786', N'PS7777', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'648-92-1872', N'TC4203', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'672-71-3249', N'TC7777', 1, 40)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'712-45-1867', N'MC2222', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'722-51-5454', N'MC3021', 1, 75)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'724-80-9391', N'BU1111', 1, 60)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'724-80-9391', N'PS1372', 2, 25)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'756-30-7391', N'PS1372', 1, 75)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'807-91-6654', N'TC3218', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'846-92-7186', N'PC8888', 2, 50)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'899-46-2035', N'MC3021', 2, 25)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'899-46-2035', N'PS2091', 2, 50)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'998-72-3567', N'PS2091', 1, 50)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'998-72-3567', N'PS2106', 1, 100)
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'BU1032', N'The Busy Executive''s Database Guide', N'business    ', N'1389', 19.9900, 5000.0000, 10, 4095, N'An overview of available database systems with emphasis on common business applications. Illustrated.', CAST(N'1991-06-12T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'BU1111', N'Cooking with Computers: Surreptitious Balance Sheets', N'business    ', N'1389', 11.9500, 5000.0000, 10, 3876, N'Helpful hints on how to use your electronic resources to the best advantage.', CAST(N'1991-06-09T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'BU2075', N'You Can Combat Computer Stress!', N'business    ', N'0736', 2.9900, 10125.0000, 24, 18722, N'The latest medical and psychological techniques for living with the electronic office. Easy-to-understand explanations.', CAST(N'1991-06-30T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'BU7832', N'Straight Talk About Computers', N'business    ', N'1389', 19.9900, 5000.0000, 10, 4095, N'Annotated analysis of what computers can do for you: a no-hype guide for the critical user.', CAST(N'1991-06-22T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'MC2222', N'Silicon Valley Gastronomic Treats', N'mod_cook    ', N'0877', 19.9900, 0.0000, 12, 2032, N'Favorite recipes for quick, easy, and elegant meals.', CAST(N'1991-06-09T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'MC3021', N'The Gourmet Microwave', N'mod_cook    ', N'0877', 2.9900, 15000.0000, 24, 22246, N'Traditional French gourmet recipes adapted for modern microwave cooking.', CAST(N'1991-06-18T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'MC3026', N'The Psychology of Computer Cooking', N'UNDECIDED   ', N'0877', NULL, NULL, NULL, NULL, NULL, CAST(N'2023-07-28T18:59:12.747' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PC1035', N'But Is It User Friendly?', N'popular_comp', N'1389', 22.9500, 7000.0000, 16, 8780, N'A survey of software for the naive user, focusing on the ''friendliness'' of each.', CAST(N'1991-06-30T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PC8888', N'Secrets of Silicon Valley', N'popular_comp', N'1389', 20.0000, 8000.0000, 10, 4095, N'Muckraking reporting on the world''s largest computer hardware and software manufacturers.', CAST(N'1994-06-12T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PC9999', N'Net Etiquette', N'popular_comp', N'1389', NULL, NULL, NULL, NULL, N'A must-read for computer conferencing.', CAST(N'2023-07-28T18:59:12.747' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PS1372', N'Computer Phobic AND Non-Phobic Individuals: Behavior Variations', N'psychology  ', N'0877', 21.5900, 7000.0000, 10, 375, N'A must for the specialist, this book examines the difference between those who hate and fear computers and those who don''t.', CAST(N'1991-10-21T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PS2091', N'Is Anger the Enemy?', N'psychology  ', N'0736', 10.9500, 2275.0000, 12, 2045, N'Carefully researched study of the effects of strong emotions on the body. Metabolic charts included.', CAST(N'1991-06-15T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PS2106', N'Life Without Fear', N'psychology  ', N'0736', 7.0000, 6000.0000, 10, 111, N'New exercise, meditation, and nutritional techniques that can reduce the shock of daily interactions. Popular audience. Sample menus included, exercise video available separately.', CAST(N'1991-10-05T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PS3333', N'Prolonged Data Deprivation: Four Case Studies', N'psychology  ', N'0736', 19.9900, 2000.0000, 10, 4072, N'What happens when the data runs dry?  Searching evaluations of information-shortage effects.', CAST(N'1991-06-12T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PS7777', N'Emotional Security: A New Algorithm', N'psychology  ', N'0736', 7.9900, 4000.0000, 10, 3336, N'Protecting yourself and your loved ones from undue emotional stress in the modern world. Use of computer and nutritional aids emphasized.', CAST(N'1991-06-12T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'TC3218', N'Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean', N'trad_cook   ', N'0877', 20.9500, 7000.0000, 10, 375, N'Profusely illustrated in color, this makes a wonderful gift book for a cuisine-oriented friend.', CAST(N'1991-10-21T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'TC4203', N'Fifty Years in Buckingham Palace Kitchens', N'trad_cook   ', N'0877', 11.9500, 4000.0000, 14, 15096, N'More anecdotes from the Queen''s favorite cook describing life among English royalty. Recipes, techniques, tender vignettes.', CAST(N'1991-06-12T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'TC7777', N'Sushi, Anyone?', N'trad_cook   ', N'0877', 14.9900, 8000.0000, 10, 4095, N'Detailed instructions on how to make authentic Japanese sushi in your spare time.', CAST(N'1991-06-12T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[WorkItem] ([WorkID], [TypeID], [Title], [Description], [Notes]) VALUES (1, 1, N'.NET Logger integration with APM', N'.NET Nlog Logger integration with Application Performance Monitoring (APM)', N'Scope confined to Azure Monitor, Cosmos Db, and App Dynamics')
GO

INSERT [dbo].[WorkItem] ([WorkID], [TypeID], [Title], [Description], [Notes]) VALUES (2, 2, N'Resume Document Automatic Parser (RAP)', N'Machine Learning powered Python service that parses a resume for high correlation with desired skills.', N'Based on Python REST API')
GO

INSERT [dbo].[WorkType] ([TypeID], [Name], [Description]) VALUES (1, N'Proof of Concept Work', N'Implementation supported by light design that demonstrates the feasibility of a concept (such as a product idea or a business plan)')
GO

INSERT [dbo].[WorkType] ([TypeID], [Name], [Description]) VALUES (2, N'Hackathon Submission', N'Social coding event that brings computer programmers and other interested people together to improve upon or build a new software program')
GO

INSERT [dbo].[WorkType] ([TypeID], [Name], [Description]) VALUES (3, N'Design Work', N'Organization of a system that includes all components, how they interact with each other, the environment in which they operate, and the principles used to design the software')
GO

USE [ArchitectWorks]
GO

/****** Object:  Table [dbo].[authors]    Script Date: 7/29/2023 8:44:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[ContentType]    Script Date: 7/29/2023 8:44:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[Dataset]    Script Date: 7/29/2023 8:44:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[publishers]    Script Date: 7/29/2023 8:44:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[titleauthor]    Script Date: 7/29/2023 8:44:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[titles]    Script Date: 7/29/2023 8:44:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[WorkItem]    Script Date: 7/29/2023 8:44:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[WorkType]    Script Date: 7/29/2023 8:44:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'172-32-1176', N'White', N'Johnson', N'408 496-7223', N'10932 Bigge Rd.', N'Menlo Park', N'CA', N'94025', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'213-46-8915', N'Green', N'Marjorie', N'415 986-7020', N'309 63rd St. #411', N'Oakland', N'CA', N'94618', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'238-95-7766', N'Carson', N'Cheryl', N'415 548-7723', N'589 Darwin Ln.', N'Berkeley', N'CA', N'94705', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'267-41-2394', N'O''Leary', N'Michael', N'408 286-2428', N'22 Cleveland Av. #14', N'San Jose', N'CA', N'95128', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'274-80-9391', N'Straight', N'Dean', N'415 834-2919', N'5420 College Av.', N'Oakland', N'CA', N'94609', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'341-22-1782', N'Smith', N'Meander', N'913 843-0462', N'10 Mississippi Dr.', N'Lawrence', N'KS', N'66044', 0)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'409-56-7008', N'Bennet', N'Abraham', N'415 658-9932', N'6223 Bateman St.', N'Berkeley', N'CA', N'94705', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'427-17-2319', N'Dull', N'Ann', N'415 836-7128', N'3410 Blonde St.', N'Palo Alto', N'CA', N'94301', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'472-27-2349', N'Gringlesby', N'Burt', N'707 938-6445', N'PO Box 792', N'Covelo', N'CA', N'95428', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'486-29-1786', N'Locksley', N'Charlene', N'415 585-4620', N'18 Broadway Av.', N'San Francisco', N'CA', N'94130', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'527-72-3246', N'Greene', N'Morningstar', N'615 297-2723', N'22 Graybar House Rd.', N'Nashville', N'TN', N'37215', 0)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'648-92-1872', N'Blotchet-Halls', N'Reginald', N'503 745-6402', N'55 Hillsdale Bl.', N'Corvallis', N'OR', N'97330', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'672-71-3249', N'Yokomoto', N'Akiko', N'415 935-4228', N'3 Silver Ct.', N'Walnut Creek', N'CA', N'94595', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'712-45-1867', N'del Castillo', N'Innes', N'615 996-8275', N'2286 Cram Pl. #86', N'Ann Arbor', N'MI', N'48105', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'722-51-5454', N'DeFrance', N'Michel', N'219 547-9982', N'3 Balding Pl.', N'Gary', N'IN', N'46403', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'724-08-9931', N'Stringer', N'Dirk', N'415 843-2991', N'5420 Telegraph Av.', N'Oakland', N'CA', N'94609', 0)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'724-80-9391', N'MacFeather', N'Stearns', N'415 354-7128', N'44 Upland Hts.', N'Oakland', N'CA', N'94612', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'756-30-7391', N'Karsen', N'Livia', N'415 534-9219', N'5720 McAuley St.', N'Oakland', N'CA', N'94609', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'807-91-6654', N'Panteley', N'Sylvia', N'301 946-8853', N'1956 Arlington Pl.', N'Rockville', N'MD', N'20853', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'846-92-7186', N'Hunter', N'Sheryl', N'415 836-7128', N'3410 Blonde St.', N'Palo Alto', N'CA', N'94301', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'893-72-1158', N'McBadden', N'Heather', N'707 448-4982', N'301 Putnam', N'Vacaville', N'CA', N'95688', 0)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'899-46-2035', N'Ringer', N'Anne', N'801 826-0752', N'67 Seventh Av.', N'Salt Lake City', N'UT', N'84152', 1)
GO

INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'998-72-3567', N'Ringer', N'Albert', N'801 826-0752', N'67 Seventh Av.', N'Salt Lake City', N'UT', N'84152', 1)
GO

INSERT [dbo].[ContentType] ([ContentTypeID], [Code], [Name], [Description]) VALUES (1, N'IPSLOR', N'Ipsum lorem message', N'Mock words in an ipsum lorem generated message')
GO

INSERT [dbo].[Dataset] ([DatasetID], [ContentTypeID], [Name], [ContentText], [Description], [LastUpdated]) VALUES (1, 1, N'Ipsum lorem multi-paragraph', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce et augue justo. Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed condimentum lorem quis dignissim pulvinar. Morbi rhoncus ante dolor, in fermentum orci egestas in. Integer sed imperdiet dolor. Aliquam feugiat laoreet sem venenatis malesuada. Vivamus congue quis sapien vitae pulvinar. Aenean sed lectus vitae erat dapibus finibus. Proin ut malesuada nulla.Suspendisse eu neque ex. Donec mauris magna, facilisis nec arcu sit amet, ultricies efficitur nunc. Donec dapibus sodales tellus sed sodales. Interdum et malesuada fames ac ante ipsum primis in faucibus. Duis ac magna mollis, pellentesque metus nec, aliquam lorem. Cras purus turpis, consequat eget dignissim eu, tristique a risus. Mauris vitae ultricies ante, a venenatis nisl. Proin non purus magna. Vivamus maximus, ex laoreet dignissim congue, libero neque dignissim leo, eget porttitor mi eros eu tellus. Sed mauris arcu, dictum vitae interdum ac, mollis vitae turpis. Nulla imperdiet sapien vel vulputate ornare. Suspendisse sapien lorem, dapibus eu malesuada et, maximus in diam. Vestibulum consectetur eleifend metus, quis imperdiet risus fringilla a. Nam at nunc ut est mollis ultrices.Curabitur eget pellentesque est. Duis ac felis lobortis, dapibus orci at, sodales est. Fusce a lobortis mauris. Suspendisse vehicula suscipit turpis, vitae consequat felis scelerisque eget. Nullam facilisis at massa non pellentesque. In porta vitae eros vel finibus. Pellentesque vehicula lacus vitae odio tristique sodales. Etiam viverra quam at pretium tempor. Morbi varius aliquam nulla, auctor semper tortor feugiat eu. Vivamus at lobortis purus, et rutrum orci. Pellentesque placerat vitae nulla ac vulputate.Morbi vitae augue commodo, maximus nibh in, vulputate felis. Praesent ac dui bibendum lacus cursus posuere eget eu ipsum. Praesent pulvinar cursus tortor eget convallis. Etiam iaculis rutrum quam nec lobortis. Nunc sit amet felis nisl. Quisque dapibus justo magna, in eleifend lacus congue in. Aenean ut augue est. Mauris nisl lacus, bibendum id dapibus eu, vestibulum in neque. Proin lobortis ante in suscipit dictum. Nullam orci quam, mollis in lectus nec, elementum volutpat risus. Quisque aliquam nibh et lectus sodales, ac posuere lectus mattis.Nullam in elit justo. Vestibulum venenatis diam ut odio vulputate convallis. Phasellus nec ultrices ligula, nec dictum ante. Ut eget facilisis urna. Etiam vel sollicitudin eros, rhoncus tincidunt urna. Cras id neque vitae dolor molestie dapibus id et ipsum. Mauris a aliquam turpis. Sed eu suscipit ipsum. Praesent in elementum lorem. Sed sem dolor, fringilla a viverra et, ultricies a felis. Quisque in nunc et lectus venenatis bibendum hendrerit in ligula.Maecenas mi diam, aliquet ut sem a, varius convallis augue. Sed tincidunt ornare felis ac viverra. Cras nec velit diam. Morbi est velit, hendrerit a commodo sed, molestie vel massa. Vivamus eu arcu sit amet enim ultrices vestibulum semper nec justo. Suspendisse euismod porta dolor, nec volutpat eros tempor sed. Nunc pulvinar est sed magna ultricies, nec elementum ligula maximus. Phasellus tempus lorem aliquam odio feugiat vehicula. Integer fermentum blandit rhoncus. Integer convallis sagittis vehicula. Nulla et maximus risus, sed consequat velit. Donec rutrum risus risus, ac accumsan magna porta et. Nulla scelerisque malesuada urna, non imperdiet mi volutpat eu. Phasellus facilisis, ipsum finibus euismod venenatis, lacus elit facilisis metus, sed commodo elit eros vitae lacus. Cras facilisis ac mauris eget efficitur.Phasellus ac ante vel nulla malesuada mattis et nec nisl. Integer feugiat id dui non tempus. Proin ultrices, leo eu finibus pellentesque, turpis risus vulputate risus, ut volutpat magna ipsum eu nulla. Nunc porttitor, lacus eu fermentum ullamcorper, lacus sem pharetra nunc, id hendrerit enim purus in odio. Curabitur eget purus augue. Fusce feugiat mauris ac arcu finibus, non rhoncus ipsum volutpat. Sed ultrices dictum aliquet. Curabitur nisi nisi, rutrum eget pulvinar nec, bibendum ac metus. Nullam accumsan velit non mollis aliquet. Mauris purus velit, pharetra eu efficitur a, porttitor a dolor. Integer sed nisl gravida, vulputate felis eget, lacinia arcu. Nulla non aliquam nunc. Cras bibendum blandit finibus. Donec et velit scelerisque, tempor diam eget, convallis orci. In nulla sem, pretium sit amet fringilla interdum, luctus hendrerit nibh.Etiam gravida lacus nec vehicula maximus. Phasellus aliquam purus a vehicula scelerisque. Proin feugiat turpis a massa porta, pharetra congue nulla ultrices. Nunc non finibus ipsum. Duis mattis condimentum diam non tempor. Aenean suscipit mi ex, nec venenatis nunc tincidunt in. Ut quam leo, lobortis et euismod ac, egestas a massa. In sit amet lectus a lorem congue porttitor non quis purus. Mauris eleifend nisl ac aliquet luctus. Vestibulum id lorem interdum, pharetra dolor et, lobortis dui. Nam sagittis dapibus fringilla. Vivamus vehicula molestie diam, vitae congue turpis bibendum vitae.Nulla fringilla et nisi id porta. Proin fringilla suscipit nisi. Aliquam vel arcu metus. Ut sodales fermentum est, nec fringilla magna tempor et. Duis vitae bibendum velit. Vivamus faucibus dui eros, id tempus arcu faucibus a. Curabitur elit lacus, volutpat sed risus eget, fringilla euismod libero. Maecenas odio est, interdum ut lacus sed, molestie tempor arcu. Suspendisse mollis eros vel dolor ornare, non venenatis nunc lobortis. Sed mi risus, consectetur in eleifend sed, sagittis sit amet elit. Proin rutrum ullamcorper mi sit amet facilisis. Etiam placerat ullamcorper velit. Etiam sollicitudin sapien sagittis, aliquam lacus iaculis, euismod nunc. Vivamus rutrum quam et sapien porta lobortis.Integer euismod quam nisl, quis tristique magna hendrerit sit amet. Suspendisse venenatis nibh ac nibh ullamcorper, eget vulputate lacus volutpat. Sed massa justo, facilisis in quam a, rutrum tincidunt est. Nunc posuere magna eget eleifend rutrum. Fusce feugiat sed metus sed faucibus. Fusce elementum, libero eu convallis dapibus, eros eros efficitur nisi, quis cursus quam sapien et augue. Pellentesque bibendum elit at mi egestas fermentum. Praesent at lacus ultricies, viverra arcu sit amet, scelerisque ante. Quisque odio nibh, semper nec nisl in, pulvinar vulputate odio. Aliquam ipsum turpis, congue in magna nec, efficitur consectetur est. Fusce eget faucibus turpis.', N'Set of poaragraphs with ipsum lorem content', CAST(N'2023-07-27T16:59:16.943' AS DateTime))
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'0736', N'New Moon Books', N'Boston', N'MA', N'USA')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'0877', N'Binnet & Hardley', N'Washington', N'DC', N'USA')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'1389', N'Algodata Infosystems', N'Berkeley', N'CA', N'USA')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'1622', N'Five Lakes Publishing', N'Chicago', N'IL', N'USA')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'1756', N'Ramona Publishers', N'Dallas', N'TX', N'USA')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'9901', N'GGG&G', N'M?nchen', NULL, N'Germany')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'9952', N'Scootney Books', N'New York', N'NY', N'USA')
GO

INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'9999', N'Lucerne Publishing', N'Paris', NULL, N'France')
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'172-32-1176', N'PS3333', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'213-46-8915', N'BU1032', 2, 40)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'213-46-8915', N'BU2075', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'238-95-7766', N'PC1035', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'267-41-2394', N'BU1111', 2, 40)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'267-41-2394', N'TC7777', 2, 30)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'274-80-9391', N'BU7832', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'409-56-7008', N'BU1032', 1, 60)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'427-17-2319', N'PC8888', 1, 50)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'472-27-2349', N'TC7777', 3, 30)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'486-29-1786', N'PC9999', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'486-29-1786', N'PS7777', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'648-92-1872', N'TC4203', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'672-71-3249', N'TC7777', 1, 40)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'712-45-1867', N'MC2222', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'722-51-5454', N'MC3021', 1, 75)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'724-80-9391', N'BU1111', 1, 60)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'724-80-9391', N'PS1372', 2, 25)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'756-30-7391', N'PS1372', 1, 75)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'807-91-6654', N'TC3218', 1, 100)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'846-92-7186', N'PC8888', 2, 50)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'899-46-2035', N'MC3021', 2, 25)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'899-46-2035', N'PS2091', 2, 50)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'998-72-3567', N'PS2091', 1, 50)
GO

INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'998-72-3567', N'PS2106', 1, 100)
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'BU1032', N'The Busy Executive''s Database Guide', N'business    ', N'1389', 19.9900, 5000.0000, 10, 4095, N'An overview of available database systems with emphasis on common business applications. Illustrated.', CAST(N'1991-06-12T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'BU1111', N'Cooking with Computers: Surreptitious Balance Sheets', N'business    ', N'1389', 11.9500, 5000.0000, 10, 3876, N'Helpful hints on how to use your electronic resources to the best advantage.', CAST(N'1991-06-09T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'BU2075', N'You Can Combat Computer Stress!', N'business    ', N'0736', 2.9900, 10125.0000, 24, 18722, N'The latest medical and psychological techniques for living with the electronic office. Easy-to-understand explanations.', CAST(N'1991-06-30T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'BU7832', N'Straight Talk About Computers', N'business    ', N'1389', 19.9900, 5000.0000, 10, 4095, N'Annotated analysis of what computers can do for you: a no-hype guide for the critical user.', CAST(N'1991-06-22T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'MC2222', N'Silicon Valley Gastronomic Treats', N'mod_cook    ', N'0877', 19.9900, 0.0000, 12, 2032, N'Favorite recipes for quick, easy, and elegant meals.', CAST(N'1991-06-09T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'MC3021', N'The Gourmet Microwave', N'mod_cook    ', N'0877', 2.9900, 15000.0000, 24, 22246, N'Traditional French gourmet recipes adapted for modern microwave cooking.', CAST(N'1991-06-18T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'MC3026', N'The Psychology of Computer Cooking', N'UNDECIDED   ', N'0877', NULL, NULL, NULL, NULL, NULL, CAST(N'2023-07-28T18:59:12.747' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PC1035', N'But Is It User Friendly?', N'popular_comp', N'1389', 22.9500, 7000.0000, 16, 8780, N'A survey of software for the naive user, focusing on the ''friendliness'' of each.', CAST(N'1991-06-30T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PC8888', N'Secrets of Silicon Valley', N'popular_comp', N'1389', 20.0000, 8000.0000, 10, 4095, N'Muckraking reporting on the world''s largest computer hardware and software manufacturers.', CAST(N'1994-06-12T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PC9999', N'Net Etiquette', N'popular_comp', N'1389', NULL, NULL, NULL, NULL, N'A must-read for computer conferencing.', CAST(N'2023-07-28T18:59:12.747' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PS1372', N'Computer Phobic AND Non-Phobic Individuals: Behavior Variations', N'psychology  ', N'0877', 21.5900, 7000.0000, 10, 375, N'A must for the specialist, this book examines the difference between those who hate and fear computers and those who don''t.', CAST(N'1991-10-21T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PS2091', N'Is Anger the Enemy?', N'psychology  ', N'0736', 10.9500, 2275.0000, 12, 2045, N'Carefully researched study of the effects of strong emotions on the body. Metabolic charts included.', CAST(N'1991-06-15T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PS2106', N'Life Without Fear', N'psychology  ', N'0736', 7.0000, 6000.0000, 10, 111, N'New exercise, meditation, and nutritional techniques that can reduce the shock of daily interactions. Popular audience. Sample menus included, exercise video available separately.', CAST(N'1991-10-05T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PS3333', N'Prolonged Data Deprivation: Four Case Studies', N'psychology  ', N'0736', 19.9900, 2000.0000, 10, 4072, N'What happens when the data runs dry?  Searching evaluations of information-shortage effects.', CAST(N'1991-06-12T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'PS7777', N'Emotional Security: A New Algorithm', N'psychology  ', N'0736', 7.9900, 4000.0000, 10, 3336, N'Protecting yourself and your loved ones from undue emotional stress in the modern world. Use of computer and nutritional aids emphasized.', CAST(N'1991-06-12T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'TC3218', N'Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean', N'trad_cook   ', N'0877', 20.9500, 7000.0000, 10, 375, N'Profusely illustrated in color, this makes a wonderful gift book for a cuisine-oriented friend.', CAST(N'1991-10-21T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'TC4203', N'Fifty Years in Buckingham Palace Kitchens', N'trad_cook   ', N'0877', 11.9500, 4000.0000, 14, 15096, N'More anecdotes from the Queen''s favorite cook describing life among English royalty. Recipes, techniques, tender vignettes.', CAST(N'1991-06-12T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) VALUES (N'TC7777', N'Sushi, Anyone?', N'trad_cook   ', N'0877', 14.9900, 8000.0000, 10, 4095, N'Detailed instructions on how to make authentic Japanese sushi in your spare time.', CAST(N'1991-06-12T00:00:00.000' AS DateTime))
GO

INSERT [dbo].[WorkItem] ([WorkID], [TypeID], [Title], [Description], [Notes]) VALUES (1, 1, N'.NET Logger integration with APM', N'.NET Nlog Logger integration with Application Performance Monitoring (APM)', N'Scope confined to Azure Monitor, Cosmos Db, and App Dynamics')
GO

INSERT [dbo].[WorkItem] ([WorkID], [TypeID], [Title], [Description], [Notes]) VALUES (2, 2, N'Resume Document Automatic Parser (RAP)', N'Machine Learning powered Python service that parses a resume for high correlation with desired skills.', N'Based on Python REST API')
GO

INSERT [dbo].[WorkType] ([TypeID], [Name], [Description]) VALUES (1, N'Proof of Concept Work', N'Implementation supported by light design that demonstrates the feasibility of a concept (such as a product idea or a business plan)')
GO

INSERT [dbo].[WorkType] ([TypeID], [Name], [Description]) VALUES (2, N'Hackathon Submission', N'Social coding event that brings computer programmers and other interested people together to improve upon or build a new software program')
GO

INSERT [dbo].[WorkType] ([TypeID], [Name], [Description]) VALUES (3, N'Design Work', N'Organization of a system that includes all components, how they interact with each other, the environment in which they operate, and the principles used to design the software')
GO
