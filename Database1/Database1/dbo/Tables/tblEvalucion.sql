CREATE TABLE [dbo].[tblEvalucion] (
    [id]                       NUMERIC (18)  NULL,
    [idPresto]                 NUMERIC (18)  NULL,
    [importe]                  NVARCHAR (50) NULL,
    [valorEstimadoInmueble]    NVARCHAR (50) NULL,
    [bonificacionEfect]        NVARCHAR (50) NULL,
    [porcentajeFinanciamiento] NVARCHAR (50) NULL,
    [montoEnganche]            NVARCHAR (50) NULL,
    [tasaAplicable]            NVARCHAR (50) NULL,
    [plazo]                    NVARCHAR (50) NULL,
    [tipoComision]             NVARCHAR (50) NULL,
    [comisionApertura]         NVARCHAR (50) NULL,
    [comisionAdmin]            NVARCHAR (50) NULL,
    [comisionMinistracion]     NVARCHAR (50) NULL,
    [comisionPrepago]          NVARCHAR (50) NULL,
    [comInvest]                NVARCHAR (50) NULL,
    [fechaEvaluacion]          DATE          NULL
);

