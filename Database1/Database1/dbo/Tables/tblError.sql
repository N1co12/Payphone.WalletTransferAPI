CREATE TABLE [dbo].[tblError] (
    [ErrorNumber]    INT             NULL,
    [ErrorSeverity]  INT             NULL,
    [ErrorState]     INT             NULL,
    [ErrorProcedure] NVARCHAR (128)  NULL,
    [ErrorLine]      INT             NULL,
    [ErrorMessage]   NVARCHAR (4000) NULL,
    [Fecha_Error]    DATETIME        NOT NULL,
    [USUARIO]        NVARCHAR (15)   NULL
);

