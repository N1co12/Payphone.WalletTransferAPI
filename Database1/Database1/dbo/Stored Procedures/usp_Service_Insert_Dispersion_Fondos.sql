-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 26-12-2017
-- Description:	Insert info dispersion fondos
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_Dispersion_Fondos]
	
	  @FolioBanco			nvarchar(30)
	, @IdEstatus			int
	, @Observaciones		nvarchar(max)
	, @ImporteDispuesto		decimal(18,2)
	, @ImporteComision		decimal(18,2)

AS
BEGIN
	SET NOCOUNT OFF;

	Declare @idExpediente bigint = (Select idExpediente from dbPrestoCibergestionBanorte.dbo.tblIngreso_DatosGenerales where folioBanco = @FolioBanco)

	if not exists (Select 1 from dbPrestoCibergestionBanorte.dbo.tblDispersionFondos where idExpediente = @IdExpediente)
		begin
			Insert into dbPrestoCibergestionBanorte.dbo.tblDispersionFondos (idEstatusGeneral, observaciones, idExpediente, idUsuarioAlta, fechaAlta, ImporteDispuesto, ImporteConComision)
				values (@IdEstatus, @Observaciones, @idExpediente, 16, current_timestamp, @ImporteDispuesto, @ImporteComision)
		end
	else
		begin
			Update dbPrestoCibergestionBanorte.dbo.tblDispersionFondos set
				  idEstatusGeneral		= @IdEstatus
				, observaciones			= @Observaciones
				, ImporteDispuesto		= @ImporteDispuesto
				, ImporteConComision	= @ImporteComision
				, idUsuarioModifica		= 16
				, fechaModifica			= current_timestamp
			where idExpediente = @IdExpediente
		end

	exec dbPrestoCibergestionBanorte.dbo.usp_Insert_Bitacora @idExpediente, '_WqTnEk_wEeWmubI992vDXg', 16, @Observaciones

END
