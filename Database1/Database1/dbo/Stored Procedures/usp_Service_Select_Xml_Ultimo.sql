-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 08-01-2017
-- Description:	Retorna último xml de un folio banco
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Select_Xml_Ultimo]
	
	@FolioBanco nvarchar(30)

AS
BEGIN
	SET NOCOUNT ON;
	Set transaction isolation level read uncommitted;

	Select top 1 
		[xmlDataCREa] = xmlDataCREa 
	from dbo.tblDataCREa 
	where 
		noCaso = @FolioBanco 
		and [status] in ('true') 
		and enviadoPresto in ('false') 
	order by id desc

END
