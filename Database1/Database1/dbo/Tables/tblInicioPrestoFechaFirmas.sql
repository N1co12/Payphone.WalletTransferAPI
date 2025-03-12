CREATE TABLE [dbo].[tblInicioPrestoFechaFirmas] (
    [id]         NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [idPresto]   NUMERIC (18)    NULL,
    [fechaFirma] DATE            NULL,
    [horaFirma]  DECIMAL (10, 2) NULL
);

