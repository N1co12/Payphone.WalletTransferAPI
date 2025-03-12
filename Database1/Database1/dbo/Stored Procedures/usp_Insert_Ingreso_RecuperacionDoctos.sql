-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 16-02-2017
-- Description:	Módulo recuperación de documentos (ingreso solicitud)
-- =============================================
CREATE PROCEDURE usp_Insert_Ingreso_RecuperacionDoctos
	
	  @IdExpediente bigint
	, @ContactaClienteVendedor int
	, @FechaContacto nvarchar(10)
	, @FechaCompromiso nvarchar(10)
	, @PersonaEntrega nvarchar(300)
	, @NombreContacto nvarchar(300)
	, @CorreoContacto nvarchar(100)
	, @VoBoTecnicoPrefirma bit
	, @IdUsuario int
	, @FechaAlta datetime

AS
BEGIN
	SET NOCOUNT ON;

	Update [dbo].[tblIngreso_RecuperacionDoctos] set Activo = cast(0 as bit) where idExpediente = @IdExpediente

	Insert into [dbo].[tblIngreso_RecuperacionDoctos]
			([IdExpediente]
			, [ContactaClienteVendedor]
			, [FechaContacto]
			, [FechaCompromiso]
			, [PersonaEntrega]
			, [NombreContacto]
			, [CorreoContacto]
			, [VoBoTecnicoPrefirma]
			, [IdUsuarioAlta]
			, [FechaAlta]
			, [Activo]
		)
		values
			( @IdExpediente
			, @ContactaClienteVendedor
			, @FechaContacto
			, @FechaCompromiso
			, @PersonaEntrega
			, @NombreContacto
			, @CorreoContacto
			, @VoBoTecnicoPrefirma
			, @IdUsuario
			, current_timestamp
			, cast(1 as bit)
		)

END
