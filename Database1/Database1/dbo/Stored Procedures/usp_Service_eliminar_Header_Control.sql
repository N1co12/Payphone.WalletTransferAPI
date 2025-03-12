-- =============================================
-- Create date: 11-07-2021
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_eliminar_Header_Control]	
	  @FolioBanco			nvarchar(30)

AS
BEGIN
	SET NOCOUNT OFF;

	declare @idPresto bigint =0;

	 select top 1 @idPresto = idPresto from tblHeader where noCaso=@FolioBanco order by fechaRegistro desc
	 delete from tblHeader where idpresto = @idPresto and  noCaso=@FolioBanco 
END
