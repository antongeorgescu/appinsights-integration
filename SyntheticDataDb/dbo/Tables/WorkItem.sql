CREATE TABLE [dbo].[WorkItem] (
    [WorkID]      SMALLINT       NOT NULL,
    [TypeID]      SMALLINT       NOT NULL,
    [Title]       VARCHAR (50)   NOT NULL,
    [Description] VARCHAR (1000) NULL,
    [Notes]       VARCHAR (MAX)  NULL,
    CONSTRAINT [PK_WorkItem] PRIMARY KEY CLUSTERED ([WorkID] ASC),
    CONSTRAINT [FK_WorkItem_WorkType] FOREIGN KEY ([TypeID]) REFERENCES [dbo].[WorkType] ([TypeID])
);

