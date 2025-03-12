CREATE TABLE [dbo].[CatCamposServicioMapeo] (
    [IdCamposServicioMapeo] INT           IDENTITY (1, 1) NOT NULL,
    [IdCampo]               INT           NOT NULL,
    [IdServicio]            INT           NOT NULL,
    [CampoArregloDatos]     BIT           NOT NULL,
    [Requerido]             INT           NOT NULL,
    [Dependencias]          VARCHAR (100) NULL,
    [Catalogo]              VARCHAR (100) NULL,
    [Condicion]             VARCHAR (100) NULL,
    [EsActivo]              BIT           NOT NULL,
    [Eliminado]             BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_idcamposervicios] PRIMARY KEY CLUSTERED ([IdCamposServicioMapeo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_IdCampo_CatCamposServicio] FOREIGN KEY ([IdCampo]) REFERENCES [dbo].[CatCamposServicio] ([IdCampo]),
    CONSTRAINT [FK_IdServicio_CatServicio] FOREIGN KEY ([IdServicio]) REFERENCES [dbo].[CatServicio] ([IdServicio])
);

