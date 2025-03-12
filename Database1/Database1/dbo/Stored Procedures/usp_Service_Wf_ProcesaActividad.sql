-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 27-12-2017
-- Description:	Cambio de 
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Wf_ProcesaActividad]
	
	@id		   bigint, -- Id de la actividad
	@idUsuario bigint = 0

AS
BEGIN
	SET NOCOUNT ON;

    exec [dbPrestoCibergestionBanorte].[dbo].[SP_ProcesaActividad] @id, @idUsuario

END
