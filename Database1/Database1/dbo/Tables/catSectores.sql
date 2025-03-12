CREATE TABLE [dbo].[catSectores] (
    [id]             INT            NOT NULL,
    [IDSECTOR]       NVARCHAR (10)  NULL,
    [SECTORGENERICO] NVARCHAR (100) NULL,
    [FLAG]           BIT            NULL,
    CONSTRAINT [PK_catSectores] PRIMARY KEY CLUSTERED ([id] ASC)
);

