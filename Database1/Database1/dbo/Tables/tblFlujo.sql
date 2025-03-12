CREATE TABLE [dbo].[tblFlujo] (
    [id]                    INT            IDENTITY (1, 1) NOT NULL,
    [idPresto]              NUMERIC (18)   NOT NULL,
    [resultadopaso]         INT            NULL,
    [idTipoRechazo]         INT            NULL,
    [idmotivorechazo]       INT            NULL,
    [resultadoNotificacion] BIT            NULL,
    [comentarios]           NVARCHAR (100) NULL,
    [fecha]                 NVARCHAR (20)  NULL,
    [status]                BIT            NULL,
    [mensaje]               NVARCHAR (500) NULL
);

