-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 26-12-2017
-- Description:	Cancelar folio
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_Codigo200]
	
	  @FolioBanco	nvarchar(30)
	, @IdXml		bigint
	, @XmlData		xml

AS
BEGIN
	SET NOCOUNT ON;

	Declare @idExpediente bigint = (Select idExpediente from dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales where folioBanco = @FolioBanco)

	-- Cerrar rechazos
	Update dbPrestoCibergestionBanorte.dbo.tblRechazos set fechaFin = current_timestamp where idExpediente = @idExpediente and fechaFin is null

	-- Cancelar actividades
	Update dbPrestoCibergestionBanorte.dbo.Actividades set 
		[status] = 'Cancelado', 
		fechaCancelacion = current_timestamp 
	where 
		idExpediente = @IdExpediente and 
		[status] not in ('Completada')

	-- Cambio de estatus de código 200
	Update [dbo].[tblDataCREa] set Comentarios = '200 | Folio cancelado', enviadoPresto = cast(1 as bit) where id = @IdXml

	-- Registro de XML en BD de Negocio
	Update [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa] 
		set [status] = 0 where noCaso = @FolioBanco

	Insert into [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa]
		(xmlDataCREa, codigo, idExpediente, noCaso, [status], fechaRegistro)
	values
		(@XmlData, 200, @idExpediente, @FolioBanco, 1, current_timestamp)

END
