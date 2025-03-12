CREATE TABLE [dbo].[UsuariosWS] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Usuario]      VARCHAR (150) NOT NULL,
    [Clave]        VARCHAR (250) NOT NULL,
    [FechaAlta]    DATETIME      CONSTRAINT [DF_UsuariosWS_FechaAlta] DEFAULT (getdate()) NOT NULL,
    [FechaIngreso] DATETIME      NULL,
    [Tipo]         VARCHAR (250) NOT NULL,
    [Activo]       BIT           CONSTRAINT [DF_UsuariosWS_Activo] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_UsuariosWS] PRIMARY KEY CLUSTERED ([Id] ASC)
);

