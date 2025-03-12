-- =============================================
-- Author:		Victor H. Guerrero
-- Create date: 27-12-2017
-- Description:	Envio de notificaciones
-- =============================================
CREATE PROCEDURE [dbo].[usp_Service_Insert_Notifications] 
	
	  @IdCorreo int
	, @IdExpediente bigint
	, @IdUsuario int
	, @Attachment nvarchar(max)

AS
BEGIN
	SET NOCOUNT ON;

    exec [dbPrestoCibergestionBanorte].[dbo].[usp_Insert_Email_Info] @IdCorreo, @IdExpediente, @IdUsuario, @Attachment, 0

END
