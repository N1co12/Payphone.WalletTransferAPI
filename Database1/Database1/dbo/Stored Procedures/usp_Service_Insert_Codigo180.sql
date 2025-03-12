﻿-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 26-12-2017
-- Description:	Servicio 180
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_Codigo180]
	
	  @FolioBanco	nvarchar(30)
	, @Cat			decimal(18,2)
	, @IdXml		bigint
	, @XmlData		xml

AS
BEGIN
	SET NOCOUNT ON;

	Declare @idExpediente bigint = (Select idExpediente from dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales where folioBanco = @FolioBanco)

	if exists(select 1 from dbPrestoCibergestionBanorte.dbo.tblCierreCifras where idExpediente = @idExpediente)
		begin
			Update dbPrestoCibergestionBanorte.dbo.tblCierreCifras set
				cat = @Cat
			where idExpediente = @idExpediente
		end

	-- Cambio de estatus de código 180
	Update [dbo].[tblDataCREa] set enviadoPresto = cast(1 as bit) where id = @IdXml

	-- Registro de XML en BD de Negocio
	Update [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa] 
		set [status] = 0 where noCaso = @FolioBanco

	Insert into [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa]
		(xmlDataCREa, codigo, idExpediente, noCaso, [status], fechaRegistro)
	values
		(@XmlData, 180, @idExpediente, @FolioBanco, 1, current_timestamp)

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
