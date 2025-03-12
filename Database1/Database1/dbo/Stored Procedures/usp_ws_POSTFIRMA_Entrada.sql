-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 12-06-2019
-- Description:	Obtiene información para servicio de postfima (ENTRADA)
-- exec [dbPrestoCibergestionBanorte].[dbo].[usp_ws_POSTFIRMA_Entrada] 9831
-- =============================================
CREATE PROCEDURE [dbo].[usp_ws_POSTFIRMA_Entrada]
	
	@IdExpediente bigint

AS
BEGIN
	set nocount on;
	Set transaction isolation level read uncommitted;


	exec [dbPrestoCibergestionBanorte].[dbo].[usp_ws_POSTFIRMA_Entrada] @IdExpediente
	
END