CREATE TABLE [dbo].[catDocumentos] (
    [id]              INT            NOT NULL,
    [IDDOCUMENTO]     INT            NULL,
    [NOMBREDOCUMENTO] NVARCHAR (200) NULL,
    CONSTRAINT [PK_catDocumentos] PRIMARY KEY CLUSTERED ([id] ASC) WITH (FILLFACTOR = 90)
);

