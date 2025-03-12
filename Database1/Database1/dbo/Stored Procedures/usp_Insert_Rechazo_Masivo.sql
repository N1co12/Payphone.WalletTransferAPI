-- =============================================
-- Author:		igs
-- Create date: 07 Feb 2016
-- Description:	Store que consulta catalogos
-- 
-- =============================================
CREATE PROCEDURE  [dbo].[usp_Insert_Rechazo_Masivo]
	-- Add the parameters for the stored procedure here
	@noCaso nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	exec [dbPrestoCibergestionBanorte].dbo.usp_Insert_Rechazo_Masivo @noCaso


	update tblRechazoMasivoProgramaConvenio set exito=1,FechaRechazo=GETDATE() where noCaso=@noCaso

END
