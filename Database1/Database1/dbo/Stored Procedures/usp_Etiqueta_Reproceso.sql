CREATE PROCEDURE usp_Etiqueta_Reproceso 
	
	  @idExpediente	bigint
	, @idAnterior	bigint
	, @idNuevo		bigint

AS
BEGIN
	SET NOCOUNT ON;

    exec dbPrestoCibergestionBanorte.dbo.usp_Etiqueta_Reproceso @idExpediente, @idAnterior, @idNuevo

END
