CREATE TABLE [dbo].[catCorredorInmobiliario] (
    [id]                       SMALLINT      NOT NULL,
    [IDCORREDORINMOBILIARIO]   INT           NULL,
    [CORREDORINMOBILIARIODESC] NVARCHAR (80) NULL,
    [IDCONDICIONESESPECIALES]  SMALLINT      NULL,
    [FLAG]                     BIT           NULL,
    CONSTRAINT [PK_catCorredorInmobiliario] PRIMARY KEY CLUSTERED ([id] ASC) WITH (FILLFACTOR = 90)
);

