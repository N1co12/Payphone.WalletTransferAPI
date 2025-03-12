CREATE TABLE [dbo].[tblHeader] (
    [idPresto]      NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [nombre]        NVARCHAR (80) NULL,
    [idPrograma]    NVARCHAR (50) NULL,
    [destino]       NVARCHAR (50) NULL,
    [banco]         NVARCHAR (50) NULL,
    [rfc]           VARCHAR (20)  NULL,
    [crSucursal]    NVARCHAR (80) NULL,
    [noCaso]        NVARCHAR (50) NULL,
    [bancoCte]      VARCHAR (20)  NULL,
    [noCliente]     NVARCHAR (30) NULL,
    [usrAsignado]   NVARCHAR (50) NULL,
    [tipoCredito]   VARCHAR (20)  NULL,
    [fechaRegistro] DATETIME      CONSTRAINT [DF_tblHeader_fechaRegistro] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblHeader_1] PRIMARY KEY CLUSTERED ([idPresto] ASC) WITH (FILLFACTOR = 90)
);

