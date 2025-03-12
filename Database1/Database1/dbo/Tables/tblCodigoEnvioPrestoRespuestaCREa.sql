CREATE TABLE [dbo].[tblCodigoEnvioPrestoRespuestaCREa] (
    [id]                     NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [codigo]                 SMALLINT      NOT NULL,
    [idExpediente]           NUMERIC (18)  NOT NULL,
    [noCaso]                 NVARCHAR (30) NOT NULL,
    [xmlEnvioPrestoCREa]     XML           NULL,
    [fechaEnvio]             DATETIME      NULL,
    [xmlRespuestaCREaPresto] XML           NULL,
    [fechaRespuesta]         DATETIME      NULL,
    [status]                 BIT           CONSTRAINT [DF_tblCodigoEnvioPrestoRespuestaCREa_status] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblCodigoEnvioPrestoRespuestaCREa] PRIMARY KEY CLUSTERED ([id] ASC)
);

