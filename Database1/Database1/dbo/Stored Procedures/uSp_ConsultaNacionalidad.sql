-- =============================================
-- Author:		igs
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec  uSp_ConsultaNacionalidad '001'
-- =============================================
CREATE PROCEDURE [dbo].uSp_ConsultaNacionalidad
	-- Add the parameters for the stored procedure here
    @codNacionalidad nVARCHAR(5)
AS 
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

      SELECT id FROM dbPrestoCibergestionBanorte.[dbo].[CatNacionalidad] WHERE idBanco=@codNacionalidad


    END
