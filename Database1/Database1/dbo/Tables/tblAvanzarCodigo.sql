CREATE TABLE [dbo].[tblAvanzarCodigo] (
    [id]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [noCaso]       NVARCHAR (30) NULL,
    [idExpediente] BIGINT        NULL,
    [codigo]       SMALLINT      NULL,
    [fechaIngreso] DATETIME      NULL,
    [activo]       BIT           NULL
);

