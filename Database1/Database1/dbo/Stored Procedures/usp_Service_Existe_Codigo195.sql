-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 21-12-2017
-- Description:	Verificar existencia de código 195
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Existe_Codigo195]
	
	@FolioBanco nvarchar(25)

AS
BEGIN
	SET NOCOUNT ON;
	Set transaction isolation level read uncommitted;
	if exists (Select 1 from dbo.tblDataCrea where codigo = 195 and 
												   enviadoPresto in ('true') and 
												   noCaso = @FolioBanco)
		begin
			Select [Existe] = cast(1 as bit)
		end
	else
		begin
			Select [Existe] = cast(0 as bit)
		end

END
