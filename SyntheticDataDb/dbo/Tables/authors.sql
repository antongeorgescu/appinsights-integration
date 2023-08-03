﻿CREATE TABLE [dbo].[authors] (
    [au_id]    [dbo].[id]   NOT NULL,
    [au_lname] VARCHAR (40) NOT NULL,
    [au_fname] VARCHAR (20) NOT NULL,
    [phone]    CHAR (12)    DEFAULT ('UNKNOWN') NOT NULL,
    [address]  VARCHAR (40) NULL,
    [city]     VARCHAR (20) NULL,
    [state]    CHAR (2)     NULL,
    [zip]      CHAR (5)     NULL,
    [contract] BIT          NOT NULL,
    PRIMARY KEY CLUSTERED ([au_id] ASC)
);

