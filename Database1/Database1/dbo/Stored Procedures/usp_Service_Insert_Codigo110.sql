-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 07-06-2017
-- Description:	Servicio 110
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_Codigo110]
	
	  @FolioBanco nvarchar(30)
	, @Reca nvarchar(50)
	, @IdXml		bigint
	, @XmlData		xml

AS
BEGIN
	set nocount on;
	set transaction isolation level read uncommitted;

	Declare @response int

	Declare @idExpediente bigint
	set @idExpediente = (Select idExpediente from dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales where folioBanco = @FolioBanco)
		
	-- Actualizar dato del servicio 
	Update dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosCredito set Reca = @Reca where idExpediente = @idExpediente

	-- Cambio de estatus de código 110
	Update [dbo].[tblDataCREa] set enviadoPresto = cast(1 as bit) where id = @IdXml

	-- Registro de XML en BD de Negocio
	Update [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa] 
		set [status] = 0 where noCaso = @FolioBanco

	Insert into [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa]
		(xmlDataCREa, codigo, idExpediente, noCaso, [status], fechaRegistro)
	values
		(@XmlData, 110, @idExpediente, @FolioBanco, 1, current_timestamp)

END
