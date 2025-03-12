CREATE TABLE [dbo].[tblDataCREa_Informacion] (
    [id]                 BIGINT        NOT NULL,
    [noCaso]             NVARCHAR (50) NOT NULL,
    [decreto]            NVARCHAR (50) NOT NULL,
    [fechaEvaluacion]    DATE          NOT NULL,
    [idTipoPagoCliente ] INT           NOT NULL,
    [idTipoPagoVendedor] INT           NOT NULL,
    CONSTRAINT [PK_tblDataCREa_Informacion] PRIMARY KEY CLUSTERED ([id] ASC)
);

