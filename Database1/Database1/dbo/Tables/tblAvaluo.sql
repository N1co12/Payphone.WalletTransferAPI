CREATE TABLE [dbo].[tblAvaluo] (
    [id]                        NUMERIC (18)    NULL,
    [idPresto]                  NUMERIC (18)    NULL,
    [valorAvaluoPrimerInmueble] NUMERIC (10, 2) NULL,
    [numeroAvaluo]              NCHAR (10)      NULL,
    [fechaAvaluoPrimerInmueble] DATE            NULL,
    [valorAvaluoSegInmueble]    NUMERIC (10, 2) NULL,
    [numeroAvaluoSegundoInmu]   INT             NULL,
    [fechaAvaluoSeguInmueble]   DATE            NULL,
    [valorAvaluoTercerInmueble] NUMERIC (10, 2) NULL,
    [numeroAvaluoTercerInmu]    INT             NULL,
    [fechaAvaluoTercInmueble]   DATE            NULL,
    [sumaValorAvaluos]          NUMERIC (10, 2) NULL,
    [montoPrimerMinistracion]   NUMERIC (10, 2) NULL
);

