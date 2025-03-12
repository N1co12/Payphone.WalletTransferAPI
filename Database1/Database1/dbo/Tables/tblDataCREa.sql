CREATE TABLE [dbo].[tblDataCREa] (
    [id]                      NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [xmlDataCREa]             XML             NULL,
    [fechaRegistro]           DATETIME        NULL,
    [status]                  BIT             NULL,
    [Comentarios]             NVARCHAR (2500) NULL,
    [fechaValidacion]         DATETIME        NULL,
    [codigo]                  NVARCHAR (5)    NULL,
    [noCaso]                  NVARCHAR (30)   NULL,
    [enviadoPresto]           BIT             CONSTRAINT [DF_tblDataCREa_enviadoPresto] DEFAULT ((0)) NULL,
    [XMLRespuestaPrestoBanco] XML             NULL,
    [ApiId]                   INT             NULL,
    CONSTRAINT [PK_tblDataCREa_1] PRIMARY KEY CLUSTERED ([id] ASC)
);

