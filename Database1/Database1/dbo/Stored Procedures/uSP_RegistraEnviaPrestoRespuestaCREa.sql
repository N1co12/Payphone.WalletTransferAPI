-- =============================================
-- Author:		igs
-- Create date: 31Agosto2015
-- Description:	Store que almacena los datos enviados por Presto y la Respuesta del Banco en formato XML sin Procesarlo
-- exec [uSP_RegistraEnviaPrestoRespuestaCREa] ''
-- =============================================
CREATE PROCEDURE [dbo].[uSP_RegistraEnviaPrestoRespuestaCREa]
	-- Add the parameters for the stored procedure here
	  @codigo smallint,
	  @idExpediente NUMERIC,
	  @noCaso nVARCHAR(30) ,
      @xmlEnvioPrestoCREa XML,
	  @xmlRespuestaCREaPresto XML
AS
BEGIN
	SET NOCOUNT ON;
	Set transaction isolation level read uncommitted;

	IF(EXISTS(SELECT 1 FROM dbo.[tblCodigoEnvioPrestoRespuestaCREa] WHERE [noCaso] = @noCaso AND [status] = 0))
	  begin

		UPDATE dbo.tblCodigoEnvioPrestoRespuestaCREa SET 
			  [xmlRespuestaCREaPresto] = @xmlRespuestaCREaPresto
			, [status] = 1
			, [fechaRespuesta] = GETDATE() 
		WHERE 
			[noCaso] = @noCaso 
			AND [status] = 0
	
	  END
  ELSE
     BEGIN

		INSERT INTO [dbo].[tblCodigoEnvioPrestoRespuestaCREa] (   codigo
																, idExpediente
																, noCaso
																, xmlEnvioPrestoCREa
																, fechaEnvio
																, xmlRespuestaCREaPresto
																, fechaRespuesta
																, [status])
		VALUES(   @codigo
				, @idExpediente
				, @noCaso
				, @xmlEnvioPrestoCREa
				, GETDATE()
				, @xmlRespuestaCREaPresto
				, NULL
				, 0)

	 END    

	Select 'Exito' Exito

END
