-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 26-12-2017
-- Description:	Servicio 192
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_Codigo192]
	
	  @FolioBanco nvarchar(30)
	, @IdXml		bigint
	, @XmlData		xml

AS
BEGIN
	SET NOCOUNT ON;

	Declare @idExpediente bigint = (Select idExpediente from dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales where folioBanco = @FolioBanco)

	-- Cambio de estatus de código 192
	Update [dbo].[tblDataCREa] set enviadoPresto = cast(1 as bit) where id = @IdXml

	-- Registro de XML en BD de Negocio
	Update [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa] 
		set [status] = 0 where noCaso = @FolioBanco

	Insert into [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa]
		(xmlDataCREa, codigo, idExpediente, noCaso, [status], fechaRegistro)
	values
		(@XmlData, 192, @idExpediente, @FolioBanco, 1, current_timestamp)

	-- Response
	Select
		  [Id] = cast(Id as bigint)
		, IdExpediente
		, IdWorkflow
		, [Status]
	from dbPrestoCibergestionBanorte.dbo.Actividades
	where 
		idActividad = '_WqTnEk_wEeWmubI992vDXg'
		and [Status] not in ('Completada')
		and idExpediente = @IdExpediente

END
