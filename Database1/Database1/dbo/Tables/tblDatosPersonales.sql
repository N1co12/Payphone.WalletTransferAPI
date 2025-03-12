CREATE TABLE [dbo].[tblDatosPersonales] (
    [id]                    NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [idPresto]              NUMERIC (18)  NULL,
    [tipoParticipante]      NVARCHAR (30) NULL,
    [nombreParticipante]    NVARCHAR (80) NULL,
    [noClienteParticipante] VARCHAR (20)  NULL,
    [rfcParticipante]       VARCHAR (20)  NULL,
    [bancoCteParticipante]  NVARCHAR (50) NULL,
    [lugarNacimiento]       NVARCHAR (40) NULL,
    [estadoCivil]           SMALLINT      NULL,
    [codNacionalidad]       NVARCHAR (50) NULL,
    [idAfiliacion]          INT           NULL,
    [afiliacion]            NVARCHAR (30) NULL,
    [fechaNacimiento]       DATE          NULL,
    [edad]                  INT           NULL,
    [sexo]                  NVARCHAR (15) NULL,
    [esquemaCredito]        NVARCHAR (30) NULL,
    [conyuge]               NVARCHAR (50) NULL,
    [rfcConyuge]            VARCHAR (25)  NULL,
    [nssc]                  NVARCHAR (30) NULL
);

