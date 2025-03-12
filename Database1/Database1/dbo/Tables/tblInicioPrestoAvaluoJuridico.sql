CREATE TABLE [dbo].[tblInicioPrestoAvaluoJuridico] (
    [id]                   NUMERIC (18)    NULL,
    [idPresto]             NUMERIC (18)    NULL,
    [noCtaChequesClientes] INT             NULL,
    [opcionPrepago]        INT             NULL,
    [importe]              DECIMAL (10, 2) NULL,
    [esCap]                INT             NULL,
    [crCap]                NVARCHAR (30)   NULL,
    [idTipoPagoCliente]    INT             NULL,
    [idPagoVendedor]       INT             NULL,
    [importePagoVendedor]  NVARCHAR (30)   NULL,
    [idTipoPagoVendedor]   NVARCHAR (30)   NULL,
    [noCuentaVendedor]     NVARCHAR (30)   NULL,
    [nombreVendedor]       NVARCHAR (200)  NULL,
    [rfcVendedor]          NCHAR (13)      NULL,
    [direccionVendedor]    NVARCHAR (200)  NULL,
    [coloniaVendedor]      NVARCHAR (150)  NULL,
    [ciudadEstadoVendedor] NVARCHAR (100)  NULL,
    [cpVendedor]           INT             NULL,
    [telCasaVendedor]      NVARCHAR (30)   NULL,
    [telOficinaVendedor]   NVARCHAR (30)   NULL,
    [reca]                 NVARCHAR (50)   NULL
);

