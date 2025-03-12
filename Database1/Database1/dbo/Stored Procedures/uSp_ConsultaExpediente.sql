-- =============================================
-- Author:		igs
-- Create date: 02Septiembre2015
-- Description:	Store que consulta catalogos
-- exec uSp_ConsultaExpediente '2015092900000017'
-- =============================================
create PROCEDURE  uSp_ConsultaExpediente
	-- Add the parameters for the stored procedure here
	@noCaso NVARCHAR(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        TOP (1) idExpediente
FROM            dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales
WHERE        (folioBanco = @noCaso)




END
