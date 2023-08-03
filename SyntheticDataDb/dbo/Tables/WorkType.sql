CREATE TABLE [dbo].[WorkType] (
    [TypeID]      SMALLINT       NOT NULL,
    [Name]        VARCHAR (50)   NOT NULL,
    [Description] VARCHAR (1000) NULL,
    CONSTRAINT [PK_WorkType] PRIMARY KEY CLUSTERED ([TypeID] ASC)
);

