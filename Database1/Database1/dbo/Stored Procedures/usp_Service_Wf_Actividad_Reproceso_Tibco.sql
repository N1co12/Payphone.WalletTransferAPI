-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 27-12-2017
-- Description:	Obtener usuario y rol para nueva actividad
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Wf_Actividad_Reproceso_Tibco] 
	
	@idExpediente bigint,
	@transition varchar(200),
	@idUsuario bigint,
	@idActividadNueva varchar(200) 

AS
BEGIN
	SET NOCOUNT ON;

    exec dbPrestoCibergestionBanorte.dbo.usp_Reproceso_Tibco @idExpediente, @transition, @idUsuario, @idActividadNueva

END
