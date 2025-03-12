-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 06-07-2016
-- Description:	Inicializa wf
-- =============================================
CREATE PROCEDURE [dbo].[usp_Insert_Actividades_Iniciales]
	
	@CaseId bigint
	, @IdExpediente bigint

AS
BEGIN
	set nocount on;

	begin try
		begin transaction

			Declare @CurrentDate datetime = current_timestamp


			Update [dbWFCibergestionBanorte].[dbo].[CaseActivities] set DateCompleted = @CurrentDate, [status] = 'Completed' where CaseID = @CaseId and ActivityID = '_4fBQVMPDEeWPlbcvKjZuiw'
			Insert into [dbWFCibergestionBanorte].[dbo].[CaseActivities] ([CaseID], [ActivityID], [Secuence], [DisplayName], [Name], [Performer], [TaskFormType], [TaskFormURI], [Status], [DateProcessed], [DateCompleted], [FromActivity])
				 values
				(@CaseId, '_ruzjcMOSEeWvRf5ErAnj2A', '001.001', '', '', '', '', '', 'Completed',  @CurrentDate, @CurrentDate, '_4fBQVMPDEeWPlbcvKjZuiw'),
				(@CaseId, '_RlockEtsEeW4x7dCXQSUkg', '002.001', 'Ingreso y Valida Expediente', 'Ingreso Expediente', '_p5P0QFJ5EeWtpogMRSYlpg', 'UserDefined', 'Ingreso', 'InProgress',  @CurrentDate, null, '_ruzjcMOSEeWvRf5ErAnj2A'),
				(@CaseId, '__lvoMEtuEeW4x7dCXQSUkg', '002.001', 'Avalos', 'Avalos', '', '', '', 'SubFlow InProgress',  @CurrentDate, null, '__lvoMEtuEeW4x7dCXQSUkg'),
				(@CaseId, '_3Yy_cEtvEeW4x7dCXQSUkg', '003.001', 'StartEvent', 'StartEvent', '', '', '', 'Completed',  @CurrentDate, @CurrentDate, '__lvoMEtuEeW4x7dCXQSUkg'),
				(@CaseId, '_6CiB0EtvEeW4x7dCXQSUkg', '001.001', 'Dictamina y solicita Avalúo', 'Dictamina y solicita Avalúo', '_-73ScFJ5EeWtpogMRSYlpg', 'UserDefined', 'SolicitudAvaluos', 'InProgress',  @CurrentDate, null, '_3Yy_cEtvEeW4x7dCXQSUkg')

			Delete from [dbPrestoCibergestionBanorte].[dbo].[Actividades] where idExpediente = @IdExpediente
			Insert into [dbPrestoCibergestionBanorte].[dbo].[Actividades] ([idExpediente], [idWorkFlow], [idActividad], [idRol], [status], [idUsuario], [descripcion], [fechaAsignacion], [fechaInicio], [fechaAlta], [activo],mostrarActividad)
				 values
					   (@IdExpediente, @CaseId, '_RlockEtsEeW4x7dCXQSUkg', 1, 'Nueva', 0, 'Ingreso y Valida Expediente', @CurrentDate, @CurrentDate, @CurrentDate, 1,0), 
					   (@IdExpediente, @CaseId, '_6CiB0EtvEeW4x7dCXQSUkg', 4, 'Nueva', 0, 'Dictamina y solicita Avalúo', @CurrentDate, @CurrentDate, @CurrentDate, 1,1)
	
			--exec usp_ReasignarActividadIngresoExpediente @IdExpediente

			-- Asignación usuario prefirma
			Declare @IdUsuarioPrefirma int = 0
			--set @IdUsuarioPrefirma = (Select [dbPrestoCibergestionBanorte].[dbo].[ufn_AsignacionUsuario_CargaDeActividades](@IdExpediente, 1, '_RlockEtsEeW4x7dCXQSUkg'))
			set @IdUsuarioPrefirma = (Select [dbPrestoCibergestionBanorte].[dbo].[ufn_AsignacionUsuario_CargaDeActividades_Iniciales](@IdExpediente, 1, '_RlockEtsEeW4x7dCXQSUkg'))
			update [dbPrestoCibergestionBanorte].[dbo].[Actividades] set idUsuario = @IdUsuarioPrefirma where idExpediente = @IdExpediente and idActividad in ('_RlockEtsEeW4x7dCXQSUkg')

			-- Asignación usuario técnico prefirma
			Declare @IdUsuarioTecnicoAvaluos int = 0
			--set @IdUsuarioTecnicoAvaluos = (Select [dbPrestoCibergestionBanorte].[dbo].[ufn_AsignacionUsuario_CargaDeActividades](@IdExpediente, 4, '_6CiB0EtvEeW4x7dCXQSUkg'))
			set @IdUsuarioTecnicoAvaluos = (Select [dbPrestoCibergestionBanorte].[dbo].[ufn_AsignacionUsuario_CargaDeActividades_Iniciales](@IdExpediente, 4, '_6CiB0EtvEeW4x7dCXQSUkg'))
			update [dbPrestoCibergestionBanorte].[dbo].[Actividades] set idUsuario = @IdUsuarioTecnicoAvaluos where idExpediente = @IdExpediente and idActividad in ('_6CiB0EtvEeW4x7dCXQSUkg')
			update [dbPrestoCibergestionBanorte].[dbo].[tblIngreso_ValidaExpediente_Asignacion] set idTecnicoAvaluo = @IdUsuarioTecnicoAvaluos where idExpediente = @IdExpediente

			-- Se insertan correos
			--exec [dbPrestoCibergestionBanorte].[dbo].[usp_Insert_Email_Info] 1, @IdExpediente, 0, ''
			exec [dbPrestoCibergestionBanorte].[dbo].[usp_Insert_Email_Info] 12, @IdExpediente, 0, ''

			IF NOT EXISTS(Select top 1 * from dbPrestoCibergestionBanorte.dbo.Actividades where idExpediente = @IdExpediente and idActividad = 'Ingreso_ABM')
					BEGIN
						IF EXISTS(SELECT top 1 * FROM [dbPrestoCibergestionBanorte].[dbo].[tblIngreso_DatosCredito] WHERE idExpediente = @IdExpediente AND idProducto in (7,8,12,13))
								BEGIN
									EXEC dbPrestoCibergestionBanorte.dbo.usp_InsertarActividadABM @idExpediente, @CaseId
								END
					END


		commit
	end try
	begin catch
		if @@TRANCOUNT > 0
			begin
				rollback
			end

		Insert into [dbPrestoCibergestionBanorte].[dbo].[tblError] (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, Fecha_Error, USUARIO)
			Select error_number(), error_severity(), error_state(), error_procedure(), error_line(), error_message(), current_timestamp, 'WF_INIT'
	end catch

END
