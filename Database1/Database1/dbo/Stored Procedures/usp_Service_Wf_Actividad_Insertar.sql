-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 27-12-2017
-- Description:	Obtener usuario y rol para nueva actividad
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Wf_Actividad_Insertar] 
	
	  @idExpediente BIGINT ,
      @idActividad VARCHAR(100) ,
      @idWorkFlow BIGINT ,
      @idRol int ,
      @idUsuario int ,
      @descripcion VARCHAR(100)

AS
BEGIN
	SET NOCOUNT ON;

    exec dbPrestoCibergestionBanorte.dbo.uSP_InsertarActividad @idExpediente, @idActividad, @idWorkFlow, @idRol, @idUsuario, @descripcion

END
