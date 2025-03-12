-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 26-12-2017
-- Description:	Servicio 192
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_Codigo195]
	
		  @FolioBanco	nvarchar(30)
		, @NoAcreditado	nvarchar(30)
		, @NoCredito	nvarchar(30)
		, @IdXml		bigint
		, @XmlData		xml

AS
BEGIN
	SET NOCOUNT ON;

	Declare @idExpediente bigint = (Select idExpediente from dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales where folioBanco = @FolioBanco)

	Update dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosCredito set
		  numeroAcreditado = @NoAcreditado
		, numeroCredito = @NoCredito
	where idExpediente = @idExpediente

	-- Cambio de estatus de código 195
	Update [dbo].[tblDataCREa] set enviadoPresto = cast(1 as bit) where id = @IdXml

	-- Registro de XML en BD de Negocio
	Update [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa] 
		set [status] = 0 where noCaso = @FolioBanco

	Insert into [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa]
		(xmlDataCREa, codigo, idExpediente, noCaso, [status], fechaRegistro)
	values
		(@XmlData, 195, @idExpediente, @FolioBanco, 1, current_timestamp)

	Insert into [dbo].[tblTareaAvanceFolios] (IdActividad, FolioBanco, IdExpediente, IdWorkflow, [Status], IdActividadStr, IdTransicion, Codigo, Avanzado)
		Select
			  [Id] = cast(Id as bigint)
			, @FolioBanco
			, IdExpediente
			, IdWorkflow
			, [Status]
			, '_WqTnEk_wEeWmubI992vDXg'
			, '_ilV1sE_wEeWmubI992vDXg'
			, 195
			, cast(0 as bit)
		from dbPrestoCibergestionBanorte.dbo.Actividades
		where 
			idActividad = '_WqTnEk_wEeWmubI992vDXg'
			and [Status] not in ('Completada')
			and idExpediente = @IdExpediente

END