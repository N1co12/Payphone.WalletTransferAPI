CREATE TABLE [dbo].[CatServicio] (
    [IdServicio] INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]     VARCHAR (100) NOT NULL,
    [Codigo]     VARCHAR (10)  NOT NULL,
    [Aplicativo] VARCHAR (100) NULL,
    [EsActivo]   BIT           DEFAULT ((1)) NOT NULL,
    [Eliminado]  BIT           DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([IdServicio] ASC)
);

