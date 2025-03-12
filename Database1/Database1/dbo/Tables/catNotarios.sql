CREATE TABLE [dbo].[catNotarios] (
    [id]            INT            NULL,
    [CLAVENOTARIA]  NVARCHAR (20)  NULL,
    [NOTARIAPADRON] INT            NULL,
    [NUMERONOTARIA] INT            NULL,
    [NOMBRENOTARIO] NVARCHAR (150) NULL,
    [RAZONSOCIAL]   NVARCHAR (150) NULL,
    [ENTIDAD]       NVARCHAR (50)  NULL,
    [HONORARIOS]    INT            NULL,
    [GASTOS]        INT            NULL,
    [MUNICIPIO]     NVARCHAR (50)  NULL,
    [FLAG]          BIT            NULL
);

