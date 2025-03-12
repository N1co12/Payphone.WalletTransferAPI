CREATE TABLE [dbo].[catEstados] (
    [id]          SMALLINT      IDENTITY (1, 1) NOT NULL,
    [ESTADO_ID]   NVARCHAR (20) NULL,
    [ESTADO_DESC] NVARCHAR (30) NULL,
    [FLAG]        BIT           NULL,
    CONSTRAINT [PK_catEstados] PRIMARY KEY CLUSTERED ([id] ASC)
);

