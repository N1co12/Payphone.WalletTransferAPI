CREATE TABLE [dbo].[catLlaveValor] (
    [id]       INT           NOT NULL,
    [NEMONICO] NVARCHAR (50) NULL,
    [LLAVE]    SMALLINT      NULL,
    [VALOR]    NVARCHAR (30) NULL,
    [FLAG]     BIT           NULL,
    CONSTRAINT [PK_catLlaveValor] PRIMARY KEY CLUSTERED ([id] ASC)
);

