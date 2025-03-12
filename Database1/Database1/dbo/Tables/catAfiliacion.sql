CREATE TABLE [dbo].[catAfiliacion] (
    [id]             SMALLINT      NOT NULL,
    [IDAFILIACION]   SMALLINT      NULL,
    [AFILIACIONDESC] NVARCHAR (10) NULL,
    [FLAG]           BIT           NULL,
    CONSTRAINT [PK_catAfiliacion] PRIMARY KEY CLUSTERED ([id] ASC)
);

