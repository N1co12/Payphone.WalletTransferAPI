CREATE TABLE [dbo].[catEjecutivoBroker] (
    [id]                 INT            NOT NULL,
    [ID_ASESOR_BROKER]   INT            NULL,
    [DESCRIPCION]        NVARCHAR (100) NULL,
    [FLAG]               BIT            NULL,
    [IDFRANQUICIABROKER] INT            NULL,
    CONSTRAINT [PK_catEjecutivoBroker] PRIMARY KEY CLUSTERED ([id] ASC)
);

