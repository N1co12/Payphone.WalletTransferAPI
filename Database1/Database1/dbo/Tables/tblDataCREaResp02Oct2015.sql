CREATE TABLE [dbo].[tblDataCREaResp02Oct2015] (
    [id]              NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [xmlDataCREa]     XML             NULL,
    [fechaRegistro]   DATETIME        NULL,
    [status]          BIT             NULL,
    [Comentarios]     NVARCHAR (2500) NULL,
    [fechaValidacion] DATETIME        NULL,
    [codigo]          NVARCHAR (5)    NULL,
    [noCaso]          NVARCHAR (30)   NULL
);

