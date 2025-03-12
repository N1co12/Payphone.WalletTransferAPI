-- =============================================
-- Author:		igs
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec  uSp_ConsultaPlazo 240
-- =============================================
CREATE PROCEDURE [dbo].uSp_ConsultaPlazo
	-- Add the parameters for the stored procedure here
    @plazoBanco nVARCHAR(5)
AS 
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

       SELECT TOP 1 id FROM dbPrestoCibergestionBanorte.[dbo].[CatPlazos] WHERE ID_PLAZO=@plazoBanco


    END
