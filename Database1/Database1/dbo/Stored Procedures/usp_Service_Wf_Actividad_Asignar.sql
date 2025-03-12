-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 27-12-2017
-- Description:	Obtener usuario y rol para nueva actividad
-- [dbo].[usp_Service_Wf_Actividad_Asignar] 341, '_Qj30Uk_wEeWmubI992vDXg', '_eWvk8FJ6EeWtpogMRSYlpg'
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Wf_Actividad_Asignar] 
	
	  @IdExpediente bigint 
	, @IdActividad nvarchar(30) 
	, @IdPerformer nvarchar(100) 

AS
BEGIN
	SET NOCOUNT ON;

    exec dbPrestoCibergestionBanorte.dbo.usp_Select_Actividad_Asignar @IdExpediente, @IdActividad, @IdPerformer

END
