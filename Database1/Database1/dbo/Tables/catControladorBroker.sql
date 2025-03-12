CREATE TABLE [dbo].[catControladorBroker] (
    [id]                      SMALLINT      NOT NULL,
    [ID_USUARIO_BROKER]       NVARCHAR (10) NULL,
    [DESCRIPCION]             NVARCHAR (30) NULL,
    [FLAG]                    BIT           NULL,
    [IDCONDICIONESESPECIALES] SMALLINT      NULL,
    CONSTRAINT [PK_catControladorBroker] PRIMARY KEY CLUSTERED ([id] ASC)
);

