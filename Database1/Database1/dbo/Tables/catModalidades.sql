CREATE TABLE [dbo].[catModalidades] (
    [id]        INT            NOT NULL,
    [MODID]     NVARCHAR (10)  NULL,
    [MODALIDAD] NVARCHAR (100) NULL,
    [FLAG]      BIT            NULL,
    [IDBANCO]   NVARCHAR (10)  NULL,
    CONSTRAINT [PK_catModalidades] PRIMARY KEY CLUSTERED ([id] ASC) WITH (FILLFACTOR = 90)
);

