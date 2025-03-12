-- =============================================
-- Author:		igs
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec  usp_Select_Folios_REchasoMasivo
-- =============================================
create PROCEDURE [dbo].[usp_Select_Folios_REchasoMasivo]
	-- Add the parameters for the stored procedure here

AS 
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

      select noCaso from [dbo].[tblRechazoMasivoProgramaConvenio]
      where exito=0


    END
