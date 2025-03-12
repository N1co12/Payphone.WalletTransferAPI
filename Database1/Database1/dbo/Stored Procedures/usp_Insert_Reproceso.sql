CREATE PROCEDURE [dbo].[usp_Insert_Reproceso]
	
	@idExpediente bigint,
	@idCasoReproceso int,
	@comentarios varchar(500),
	@idUsuario int,
	@cambioCoefEndeudamiento bit

AS
BEGIN
	SET NOCOUNT ON;

    exec dbPrestoCibergestionBanorte.dbo.usp_Insert_Reproceso @idExpediente, @idCasoReproceso, @comentarios, @idUsuario, @cambioCoefEndeudamiento

END
