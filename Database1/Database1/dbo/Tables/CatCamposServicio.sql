CREATE TABLE [dbo].[CatCamposServicio] (
    [IdCampo]     INT          IDENTITY (1, 1) NOT NULL,
    [NombreNodo]  VARCHAR (50) NULL,
    [NombreCampo] VARCHAR (50) NOT NULL,
    [TipoDato]    VARCHAR (50) NOT NULL,
    [Min]         VARCHAR (50) NULL,
    [Max]         VARCHAR (50) NULL,
    [Activo]      BIT          NOT NULL,
    [Formato]     VARCHAR (50) NULL,
    [Eliminado]   BIT          DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_idcampo] PRIMARY KEY CLUSTERED ([IdCampo] ASC) WITH (FILLFACTOR = 90)
);

