CREATE TABLE [dbo].[tblCodigosPrestoDataCREa] (
    [id]                  NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [codigo]              NVARCHAR (10) NULL,
    [xmlEnviado]          XML           NULL,
    [xmlRespuesta]        XML           NULL,
    [noCaso]              NVARCHAR (30) NULL,
    [fechaEnvioRecepcion] DATETIME      NULL
);

