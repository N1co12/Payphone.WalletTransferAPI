CREATE TABLE [dbo].[catMarcaComercial] (
    [id]                 INT           NOT NULL,
    [IDMARCACOMERCIAL]   INT           NULL,
    [MARCACOMERCIALDESC] NVARCHAR (60) NOT NULL,
    [FLAG]               BIT           NULL,
    CONSTRAINT [PK_catMarcaComercial] PRIMARY KEY CLUSTERED ([id] ASC)
);

