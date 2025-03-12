CREATE TABLE [dbo].[tblMemorandum] (
    [id]                          NUMERIC (18)    NULL,
    [idPresto]                    NUMERIC (18)    NULL,
    [claveNotaria]                NVARCHAR (10)   NULL,
    [nombreNotario]               NVARCHAR (120)  NULL,
    [razonSocial]                 NVARCHAR (120)  NULL,
    [numeroNotaria]               NVARCHAR (120)  NULL,
    [entidad]                     INT             NULL,
    [notariaPadron]               INT             NULL,
    [vigentePreventivo]           DATE            NULL,
    [numeroContrato]              NVARCHAR (10)   NULL,
    [fechaPrimerPago]             DATE            NULL,
    [acreedor]                    NVARCHAR (120)  NULL,
    [plazaCredito]                NVARCHAR (30)   NULL,
    [cartaInstruccionIrrevocable] INT             NULL,
    [gtsNotariales]               NUMERIC (12, 2) NULL,
    [cuentaAbonoGtsNotariales]    INT             NULL,
    [honrsNotariales]             NUMERIC (10, 2) NULL,
    [cuentaAbonoHonrsNotariales]  INT             NULL,
    [gravamen]                    INT             NULL
);

