-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 29-01-2019
-- Description:	Recepción código 160 (Aprobación de facultades)
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_Codigo160]
	
	  @FolioBanco	nvarchar(25)
	, @IdXml		bigint
	, @XmlData		xml
	, @XmlDatos		xml

AS
BEGIN
	SET NOCOUNT ON;

	--begin try
	--begin transaction

		Declare @statusServicio bit
		Declare @comentarios varchar(1500)
		Declare @resultadoNotificacion varchar(1500)

		declare @idExpediente bigint
		set @idExpediente = (Select top 1 idExpediente from [dbPrestoCibergestionBanorte].[dbo].[tblIngreso_DatosGenerales] where folioBanco = @FolioBanco)

		Select 
			  @statusServicio			= Flujo.value('status[1]', 'bit')
			, @comentarios				= Flujo.value('comentarios[1]', 'varchar(1500)')
			, @resultadoNotificacion	= Flujo.value('resultadoNotificacion[1]', 'varchar(1500)')
		from @XmlData.nodes('//DataCREa/FlujoCREa') N1(Flujo)

		-- [tblBiometria
		Update [dbPrestoCibergestionBanorte].[dbo].[tblBiometria] set Activo = 0 where idExpediente = @idExpediente

		Insert into [dbPrestoCibergestionBanorte].[dbo].[tblBiometria] (IdExpediente, EstatusVerificacion, MensajeVerificacion, TipoValidacion, TipoValidacionDesc, FolioUnicoIdentificador
												, FolioInterno, TipoIdentificacion1, TipoIdentificacionDesc1, NumeroIdentificacion1, TipoIdentificacion2, TipoIdentificacionDesc2
												, NumeroIdentificacion2, EjecutarVerificacionBiometrica, FechaAlta, Activo, Status260, Comentarios260, ResultadoNotificacion260)
			Select 
				  @idExpediente
				, Biometria.value('estatusVerificacion[1]', 'varchar(100)') 
				, Biometria.value('mensajeVerificacion[1]', 'varchar(1000)')
				, Biometria.value('tipoValidacion[1]', 'varchar(10)') 
				, Biometria.value('tipoValidacionDesc[1]', 'varchar(1000)') 
				, Biometria.value('fui[1]', 'varchar(500)')
				, Biometria.value('folioInterno[1]', 'varchar(100)') 
				, Biometria.value('tipoIdentificacion1[1]', 'varchar(10)') 
				, Biometria.value('tipoIdentificacion1Desc[1]', 'varchar(1000)')
				, Biometria.value('numeroIdentificacion1[1]', 'varchar(1000)') 
				, Biometria.value('tipoIdentificacion2[1]', 'varchar(10)') 
				, Biometria.value('tipoIdentificacion2Desc[1]', 'varchar(1000)')
				, Biometria.value('numeroIdentificacion2[1]', 'varchar(1000)')
				, Biometria.value('EjecutarVerificacionBiometrica[1]', 'varchar(10)')
				, current_timestamp
				, 1
				, @statusServicio
				, @comentarios
				, @resultadoNotificacion
			from @XmlDatos.nodes('//Datos/Biometria') N1 (Biometria)

		-- Reactivar folio RECHAZADO
		if exists (Select 1 from dbPrestoCibergestionBanorte.dbo.Actividades where idExpediente = @idExpediente and [status] in ('En rechazo'))
			begin
				declare @status varchar(100) = 'En progreso'

				set @status = (Select top 1 [status] from dbPrestoCibergestionBanorte.dbo.tblRechazos where idExpediente = @idExpediente and fechaFin is null order by id desc)
				
				Update dbPrestoCibergestionBanorte.dbo.Actividades
					set [status] = rtrim(ltrim(@status))
				where 
					idExpediente = @idExpediente and 
					[status] = 'En rechazo'
			end

		Update dbPrestoCibergestionBanorte.dbo.tblRechazos set fechaFin = current_timestamp where idExpediente = @idExpediente and fechaFin is null

		-- Registro de XML en BD de Negocio
		Update [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa] 
			set [status] = 0 where noCaso = @FolioBanco

		Insert into [dbPrestoCibergestionBanorte].[dbo].[tblDataCREa]
			(xmlDataCREa, codigo, idExpediente, noCaso, [status], fechaRegistro)
		values
			(@XmlData, 160, @idExpediente, @FolioBanco, 1, current_timestamp)

		-- Cambio de estatus de código 140
		Update [dbo].[tblDataCREa] set enviadoPresto = cast(1 as bit) where id = @IdXml

	--	commit
	--end try
	--begin catch
	--	if(@@trancount > 0)      
	--		begin    
	--			rollback  transaction
	--			INSERT INTO tblError SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity,
	--						ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, ERROR_LINE() AS ErrorLine,
	--						ERROR_MESSAGE() AS ErrorMessage, GETDATE() AS Fecha_Error, 0 AS USUARIO;
		
	--			DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	--			SELECT @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()
	--			RAISERROR(@ErrMsg, @ErrSeverity, 1)
	--		end
	--end catch

END

