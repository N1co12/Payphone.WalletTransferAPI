CREATE TABLE [dbo].[CatEstatusResponse] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [CodigoEstatus] VARCHAR (10)  NOT NULL,
    [Descripcion]   VARCHAR (100) NULL,
    [Eliminado]     BIT           DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

