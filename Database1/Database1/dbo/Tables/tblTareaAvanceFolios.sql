CREATE TABLE [dbo].[tblTareaAvanceFolios] (
    [Id]             BIGINT       IDENTITY (1, 1) NOT NULL,
    [FolioBanco]     VARCHAR (30) NULL,
    [IdActividad]    BIGINT       NULL,
    [IdExpediente]   BIGINT       NULL,
    [IdWorkflow]     BIGINT       NULL,
    [Status]         VARCHAR (50) NULL,
    [IdActividadStr] VARCHAR (50) NULL,
    [IdTransicion]   VARCHAR (50) NULL,
    [Codigo]         INT          NULL,
    [Avanzado]       BIT          NULL
);

