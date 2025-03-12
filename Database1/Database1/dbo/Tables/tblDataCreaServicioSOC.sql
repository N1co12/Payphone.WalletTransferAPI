CREATE TABLE [dbo].[tblDataCreaServicioSOC] (
    [id]                NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [noCaso]            NVARCHAR (30)  NULL,
    [codigo]            NVARCHAR (5)   NULL,
    [fechaRegistro]     DATETIME       NULL,
    [RespuestaSOC]      NVARCHAR (250) NULL,
    [FechaRespuestaSoc] DATETIME       NULL
);

