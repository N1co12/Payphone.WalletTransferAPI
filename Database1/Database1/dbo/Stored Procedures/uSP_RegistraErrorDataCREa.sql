-- =============================================
-- Author:		Eduardo
-- Create date: 31Agosto2015
-- Description:	Store que almacena los datos enviado por el banco en formato XML sin Procesarlo
-- exec [uSP_RegistraErrorDataCREa] false,'DatosPersonales.conyuge: campo enviado vacíoDatosPersonales.rfcConyuge: campo enviado vacíoDatosDomicilio.numero: campo enviado vacíoDatosDomicilio.departamento: campo enviado vacíoDatosDomicilio.numero: campo enviado vacíoDatosDomicilio.departamento: campo enviado vacío',99
-- =============================================
CREATE PROCEDURE [dbo].[uSP_RegistraErrorDataCREa]
	-- Add the parameters for the stored procedure here
	 @status bit,
     @Comentarios nvarchar(2500),
	 @idTblDataCREa int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update tblDataCREa set status=@status, Comentarios=@Comentarios, fechaValidacion=getdate() where id=@idTblDataCREa

END
