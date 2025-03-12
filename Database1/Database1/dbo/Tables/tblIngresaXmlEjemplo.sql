CREATE TABLE [dbo].[tblIngresaXmlEjemplo] (
    [id]         NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [XMLEjemplo] XML           NULL,
    [noCaso]     NVARCHAR (50) NULL,
    [Enviado]    BIT           CONSTRAINT [DF_tblIngresaXmlEjemplo_Enviado] DEFAULT ((0)) NULL
);

