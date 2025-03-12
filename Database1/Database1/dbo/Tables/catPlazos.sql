CREATE TABLE [dbo].[catPlazos] (
    [id]       INT           NOT NULL,
    [ID_PLAZO] NVARCHAR (10) NULL,
    [PLAZO]    NVARCHAR (10) NULL,
    [FLAG]     BIT           NULL,
    CONSTRAINT [PK_catPlazos] PRIMARY KEY CLUSTERED ([id] ASC)
);

